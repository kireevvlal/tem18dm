#include "processor.h"
//#include "tem18dm.h"

#ifdef Q_OS_UNIX
#include <string>
#include <cstring>

#include <termios.h>
#include <linux/serial.h>

#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

using namespace std;
#endif


#if QT_VERSION < QT_VERSION_CHECK(5, 12, 0)
#include <QDebug>
#include <QTime>
#include <QDate>
#endif
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
Processor::Processor(QObject *parent) : QObject(parent)
{
     _pt_max = 0.5;
    _section = 0;
    _reg_timer = new QTimer();
    _reg_thread = new QThread();
    _registrator = new Registrator();
    _diag_timer = new QTimer();
    _diag_interval = 200;
    _diagnostics = new Diagnostics(&_mainstore, _pt_max);
    _is_active = false;
    _fswatcher = new QFileSystemWatcher;
#ifdef Q_OS_WIN
    _fswatcher->addPath("D:/000");
#endif
#ifdef  Q_OS_UNIX
    _fswatcher->addPath("/dev");
#endif
    _saver =  new Saver();
    _saver_thread = new QThread();
    _control = new Control(&_mainstore, _slave.Storage());
    _storage[0] = &_mainstore;
    _storage[1] = _slave.Storage();
    //_diag_thread = new QThread();
}
//--------------------------------------------------------------------------------
Processor::~Processor() {
    if (_is_active)
        Stop();
}
//--------------------------------------------------------------------------------
// Load configuration from files and create objects
bool Processor:: Load(QString startPath, QString cfgfile)
{
    int i;
    char data[12];
    UnionUInt32 par;
    // read configs
    _start_path = startPath;
    if (_tree.ReadFile(_start_path + "/" + cfgfile)) { // read start configuration file
        Parse(_tree.Root);
        for (i = 0; i < _files.length(); i++) {
            _tree.Clear();
            if (_tree.ReadFile(_start_path + "/" + _files[i]))
                ParseObjects(_tree.Root);
            else
                return false;
        }
    } else
        return false;
    // fill main and additional section storage maps
    for (QMap<QString, ThreadSerialPort*>::iterator i = _serial_ports.begin(); i != _serial_ports.end(); i++)
        _mainstore.FillMaps(i.value());
    _slave.FillStore(&_mainstore);
    // read motoresurs
    if (_mtr_file.open(QIODevice::ReadOnly)) {
        _mtr_file.read(data, 12);
        for (i = 0; i < 4; i++)
            par.Array[i] = data[i];
        _mainstore.SetUInt32("DIAG_Motoresurs", par.Value);
        for (i = 0; i < 4; i++)
            par.Array[i] = data[i + 4];
        _mainstore.SetUInt32("DIAG_Adiz", par.Value);
        _diagnostics->Adiz((float)par.Value / 10);
        for (i = 0; i < 4; i++)
            par.Array[i] = data[i + 8];
        _mainstore.SetUInt32("DIAG_Tt", par.Value);
        _mtr_file.close();
    }
    return true;
}
//--------------------------------------------------------------------------------
void Processor::Run()
{
#ifdef Q_OS_UNIX
    GPIO();
#endif
    // start serial ports
    for (QMap<QString, ThreadSerialPort*>::iterator i = _serial_ports.begin(); i != _serial_ports.end(); i++) {
        connect(i.value(), SIGNAL(DecodeSignal(QString)), this, SLOT(Unpack(QString)));
        connect(i.value(), SIGNAL(LostExchangeSignal(QString)), this, SLOT(LostConnection(QString)));
        connect(i.value(), SIGNAL(RestoreExchangeSignal(QString)), this, SLOT(RestoreConnection(QString)));
        i.value()->Start();
    }
    // start registration
    _registrator->moveToThread(_reg_thread);
    connect(this, SIGNAL(AddRecordSignal()), _registrator, SLOT(AddRecord()));
    _reg_thread->start();
    connect(_reg_timer, SIGNAL(timeout()), this, SLOT(RegTimerStep()));
    _reg_timer->start(_registrator->Interval());
    connect(_diag_timer, SIGNAL(timeout()), this, SLOT(DiagTimerStep()));
    _diag_timer->start(_diag_interval);

    connect(_fswatcher, SIGNAL(directoryChanged(QString)), this, SLOT(querySaveToUSB(QString)));

    _saver->moveToThread(_saver_thread);
    connect(this, SIGNAL(SaveFilesSignal()), _saver, SLOT(Save()));
    _saver_thread->start();
    _saver->Run();
    _is_active = true;
}
//--------------------------------------------------------------------------------
#ifdef Q_OS_UNIX
void Processor::GPIO() {
    string s = "/dev/GpioCom1Mode";
    int port_f = open(s.c_str(),O_RDWR | O_SYNC);
    char buf[2];
    buf[0] = 48; // 0 in ascii
    write(port_f, buf, 1);
    close(port_f);
    s = "/dev/GpioCom2Mode";
    port_f = open(s.c_str(),O_RDWR | O_SYNC);
    buf[0] = 48; // 0 in ascii
    write(port_f, buf, 1);
    close(port_f);
    s = "/dev/GpioCom3Mode";
    port_f = open(s.c_str(),O_RDWR | O_SYNC);
    buf[0] = 48; // 0 in ascii
    write(port_f, buf, 1);
    close(port_f);
    s = "/dev/GpioCom4Mode";
    port_f = open(s.c_str(),O_RDWR | O_SYNC);
    buf[0] = 48; // 0 in ascii
    write (port_f, buf, 1);
    close (port_f);
}
#endif
//--------------------------------------------------------------------------------
void Processor::querySaveToUSB(QString dir) {
#ifdef Q_OS_WIN
    SaveFilesSignal(); // (dir)
#endif
#ifdef Q_OS_UNIX
    // find flash usb
#endif
}
//--------------------------------------------------------------------------------
void Processor::Stop() {
    char data[12];
    UnionUInt32 par;
    int i;
    if (_mtr_file.open(QIODevice::WriteOnly)) {
        par.Value = _mainstore.UInt32("DIAG_Motoresurs");
        for (i = 0; i < 4; i++)
            data[i] = par.Array[i];
        par.Value = _mainstore.UInt32("DIAG_Adiz");
        for (i = 0; i < 4; i++)
            data[i + 4] = par.Array[i];
        par.Value = _mainstore.UInt32("DIAG_Tt");
        for (i = 0; i < 4; i++)
            data[i + 8] = par.Array[i];
        _mtr_file.write(data, 12);
        _mtr_file.close();
    }
    _registrator->Stop();
    _is_active = false;
}
//--------------------------------------------------------------------------------
void Processor::RegTimerStep() {
    // for main circle
    if (_serial_ports.contains("BEL"))
        _mainstore.SetByte("DIAG_CQ_BEL", _serial_ports["BEL"]->Quality());
    if (_serial_ports.contains("USTA"))
        _mainstore.SetByte("DIAG_CQ_USTA", _serial_ports["USTA"]->Quality());
    if (_serial_ports.contains("IT"))
        _mainstore.SetByte("DIAG_CQ_IT", _serial_ports["IT"]->Quality());
    if (_serial_ports.contains("MSS"))
        _mainstore.SetByte("DIAG_CQ_MSS", _serial_ports["MSS"]->Quality());
    //
    QDateTime dt = QDateTime::currentDateTime();
    QDate date = dt.date();
    QTime time = dt.time();
    // word diagnostic
    _registrator->SetByteRecord(176, _mainstore.Byte("DIAG_CQ_BEL"));
    _registrator->SetByteRecord(178, _mainstore.Byte("DIAG_CQ_USTA"));
    _registrator->SetByteRecord(180, _mainstore.Byte("DIAG_CQ_IT"));
    _registrator->SetByteRecord(182, _mainstore.Byte("DIAG_CQ_MSS"));
    _registrator->SetWordRecord(184, _mainstore.Int16("DIAG_MESS_NUM"));
    _registrator->SetWordRecord(186, _mainstore.Int16("DIAG_PKM_BEL"));
    _registrator->SetWordRecord(188, _mainstore.Int16("DIAG_Rplus"));
    _registrator->SetWordRecord(190, _mainstore.Int16("DIAG_Rminus"));
    _registrator->SetWordRecord(198, _mainstore.Int16("DIAG_Pg"));
    // double word diagnostic
    _registrator->SetDoubleWordRecord(206, _mainstore.UInt32("DIAG_Motoresurs"));
    _registrator->SetDoubleWordRecord(210, _mainstore.UInt32("DIAG_Apol"));
    _registrator->SetDoubleWordRecord(214, _mainstore.UInt32("DIAG_Tt"));
    // message params
    _registrator->SetByteRecord(318, 0); // hour
    _registrator->SetByteRecord(319, 0); // minute
    _registrator->SetByteRecord(320, 0); // second
    _registrator->SetByteRecord(322, 0); // index
    // date and time
    _registrator->SetByteRecord(326, date.day());
    _registrator->SetByteRecord(327, date.month());
    _registrator->SetByteRecord(328, date.year() % 100);
    _registrator->SetByteRecord(329, time.hour());
    _registrator->SetByteRecord(330, time.minute());
    _registrator->SetByteRecord(331, time.second());
    // discret diagnostic
    _registrator->SetByteRecord(346, _mainstore.Byte("DIAG_Connections"));
    quint8 byte;
    QBitArray* ba = _mainstore.Bits("PROG_TrSoob");
    for (int i = 0; i < 5; i++) {
        byte = 0;
        for (int j = 0; j < 8; j++ )
            byte +=  ba->testBit(i * 8 + j) ? (1 << i) : 0;
        _registrator->SetByteRecord(347 + i, byte);
    }
//    _registrator->SetByteRecord(348, _mainstore.Byte("DIAG_Discret_3"));
//    _registrator->SetByteRecord(349, _mainstore.Byte("DIAG_Discret_4"));
//    _registrator->SetByteRecord(350, _mainstore.Byte("DIAG_Discret_5"));
//    _registrator->SetByteRecord(351, _mainstore.Byte("DIAG_Discret_6"));
    AddRecordSignal();
}
//--------------------------------------------------------------------------------
void Processor::DiagTimerStep() {
    int pku = _mainstore.Int16("USTA_PKM") + 1;
    int pkb = _mainstore.Byte("BEL_PKM") + 1;
    if (pkb > 9)
        pkb = 9;
    if (pku > 9)
        pku = 9;
    _mainstore.SetInt16("PROG_PKM", (pkb < pku) ? pku : pkb);
    _mainstore.SetInt16("PROG_Regime", (_mainstore.Int16("PROG_Reversor") < 2 || pkb < 2) ? 3 : (_mainstore.Byte("BEL_Diagn") & 1) + 1); // 3 - XX
    _diagnostics->Motoresurs();
    _diagnostics->Connections(_serial_ports);
    _diagnostics->RizCU(_mainstore.Int16("PROG_PKM"));
    _diagnostics->APSignalization(_mainstore.Int16("PROG_PKM"));
    SetAddSectionData();
    for (QMap<QString, ThreadSerialPort*>::iterator i = _serial_ports.begin(); i != _serial_ports.end(); i++) {
        if (i.key() == "BEL")
            i.value()->OutData.SetByteParameter("BEL_SIGNALIZATION",
                 ((_mainstore.Float("IT_TSM4") >= 40) ? 1 : 0) + (_mainstore.Bit("USTA_Inputs", USTA_INPUTS_PKM18) ? 2 : 0));
        else if (i.key() == "USTA")
            i.value()->OutData.SetByteParameter("USTA_SIGNALIZATION", (_mainstore.Bit("PROG_TrSoob", 17) ? 1 : 0) + (_mainstore.Bit("PROG_TrSoob", 16) ? 2 : 0));
        else if  (i.key() == "MSS") {
            _serial_ports["MSS"]->OutData.SetData(0, 580, _slave.Outdata());
        }
    }
}
//--------------------------------------------------------------------------------
void Processor::SetAddSectionData()
{
    QTime tm = QTime::currentTime();
    QDate dt = QDate::currentDate();
    QByteArray date;
    QBitArray* ba = _mainstore.Bits("PROG_TrSoob");
    QByteArray ts;
    qint8 byte;

    date.resize(6);
    date[0] = dt.day();
    date[1] = dt.month();
    date[2] = dt.year() - 2000;
    date[3] = tm.hour();
    date[4] = tm.minute();
    date[5] = tm.second();

    for (int i = 1; i < 8; i++) {
        byte = 0;
        for (int j = 0; j < 8; j++ )
            byte +=  ba->testBit(i * 8 + j) ? (1 << i) : 0;
        ts.append(byte);
    }
    _slave.SetBytePacket(192, (_mainstore.Bit("DIAG_Connections", CONN_BEL) ? 1 : 0) + (_mainstore.Bit("DIAG_Connections", CONN_USTA) ? 2 : 0)
                           + (_mainstore.Bit("DIAG_Connections", CONN_IT) ? 4 : 0) + (_mainstore.Bit("DIAG_Connections", CONN_MSS) ? 8 : 0));
    _slave.UpdatePacket(193, 7, ts); // trev. soob.
    _slave.SetBytePacket(204, _mainstore.Byte("DIAG_CQ_BEL"));
    _slave.SetBytePacket(205, _mainstore.Byte("DIAG_CQ_USTA"));
    _slave.SetBytePacket(206, _mainstore.Byte("DIAG_CQ_IT"));
    _slave.SetBytePacket(207, _mainstore.Byte("DIAG_CQ_MSS"));
    _slave.SetWordPacket(216, _mainstore.Int16("DIAG_Rplus"));
    _slave.SetWordPacket(218, _mainstore.Int16("DIAG_Rminus"));
    _slave.SetWordPacket(222, _mainstore.Int16("DIAG_Pg"));
    _slave.SetDoubleWordPacket(236, _mainstore.UInt32("DIAG_Motoresurs"));
    _slave.SetDoubleWordPacket(240, _mainstore.UInt32("DIAG_Adiz"));
    _slave.SetDoubleWordPacket(244, _mainstore.UInt32("DIAG_Tt"));
    _slave.UpdatePacket(276, 6 , date); // date and time
    _slave.SetBytePacket(288, _mainstore.Byte("PROG_Reversor"));
    _slave.SetBytePacket(289, _mainstore.Byte("PROG_PKM"));
    _slave.SetBytePacket(290, _mainstore.Byte("PROG_Regime"));
}
//--------------------------------------------------------------------------------
void Processor::changeKdr(int kdr) {
    _control->KdrNum = kdr;
    _section = kdr / 100 - 1;  // in qml: 1 - own section, 2 - additional section
}
//--------------------------------------------------------------------------------
void Processor::LostConnection(QString alias) {
    QByteArray arr(128, 0);
    _mainstore.LoadSpData(_serial_ports[alias]); // reset parameters to 0
    if (alias == "BEL") {
        _mainstore.SetBit("DIAG_Connections", CONN_BEL, 0);
        // в 0
        _registrator->UpdateRecord(338, 8, arr.mid(0, 8)); // дискретные (+ ПКМ)
        _slave.UpdatePacket(0, 8, arr.mid(0, 8)); // дискретные (+ ПКМ)
    }
    else if (alias == "USTA") {
        _mainstore.SetBit("DIAG_Connections", CONN_USTA, 0);
        // в 0
        _registrator->UpdateRecord(0, 80, arr.mid(0, 80));  // аналоговые
        _registrator->UpdateRecord(332, 6, arr.mid(0, 6)); // дискретные
        _slave.UpdatePacket(8, 80, arr.mid(0, 80));  // аналоговые
        _slave.UpdatePacket(88, 6, arr.mid(0, 6));
    }
    if (alias == "IT") {
        _mainstore.SetBit("DIAG_Connections", CONN_IT, 0);
        // в 0
        _registrator->UpdateRecord(80, 96, arr.mid(0, 96));
        _slave.UpdatePacket(96, 96, arr.mid(0, 96));
    }
    else if (alias == "MSS")
        _mainstore.SetBit("DIAG_Connections", CONN_MSS, 0);
     qDebug() << "Lost " + alias;
}
//--------------------------------------------------------------------------------
void Processor::RestoreConnection(QString alias) {
    if (alias == "BEL")
        _mainstore.SetBit("DIAG_Connections", CONN_BEL, 1);
    else if (alias == "USTA")
        _mainstore.SetBit("DIAG_Connections", CONN_USTA, 1);
    if (alias == "IT")
        _mainstore.SetBit("DIAG_Connections", CONN_IT, 1);
    else if (alias == "MSS")
        _mainstore.SetBit("DIAG_Connections", CONN_MSS, 1);
     qDebug() << "Restore " + alias;
}
//--------------------------------------------------------------------------------
void Processor::Unpack(QString alias) {
    QByteArray data = _serial_ports[alias]->InData.Data();
    _serial_ports[alias]->InData.Swap();
    _mainstore.LoadSpData(_serial_ports[alias]);
    // update record registration
    if (alias == "USTA") {
        if (data.size() >= 87) {
            // save data
            _registrator->UpdateRecord(0, 80, data.mid(0, 80));  // аналоговые
            _registrator->UpdateRecord(332, 6, data.mid(80, 6)); // дискретные
            // diagnostic
            _mainstore.SetInt16("DIAG_Pg", _mainstore.Float("USTA_Ug_filtr") * _mainstore.Float("USTA_Ig_filtr") * 0.001); // считаем мощность генератора
            _slave.UpdatePacket(8, 80, data.mid(0, 80));  // аналоговые
            _slave.UpdatePacket(88, 6, data.mid(80, 6));
        }
    }
    else if (alias == "IT") {
        if (data.size() >= 38) {
            int index = data[_serial_ports[alias]->InData.Index];
            if (index < 3) {// принимаются долько три пакета из четырех
                _registrator->UpdateRecord(80 + index * 32, 32, data.mid(5, 32));
                _control->CalculateTC();
                _slave.UpdatePacket(96 + index * 32, 32, data.mid(5, 32));
            }
        }
    }
    else if (alias == "BEL") {
        if (data.size() >= 10) {
            //Storage.SetByteRecord(186, Storage.Byte("BEL_PKM")); // ???????????????????????????????????????????????
            _registrator->UpdateRecord(338, 8, data.mid(1, 8)); // дискретные (+ ПКМ)
            _mainstore.SetInt16("PROG_Reversor", (_mainstore.Byte("BEL_Diagn") & 3) + 1);
            _slave.UpdatePacket(0, 8, data.mid(1, 8)); // дискретные (+ ПКМ)
        }
    } else if (alias == "MSS") {
        if (data.size() >= 580)
            _slave.GetPacket(data, _serial_ports);
    }

//    qDebug() << "Unpack " + alias;
}
//--------------------------------------------------------------------------------
void Processor::Parse(NodeXML *node)
{
    while (node != nullptr) {
        if (node->Name == "files") {
            ParseFiles(node->Child);
        }
        node = node->Next;
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseFiles(NodeXML *node)
{
    while (node != nullptr) {
        if (node->Name == "path") {
            _files.append(node->Text);
        }
        node = node->Next;
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseObjects(NodeXML *node)
{
    while (node != nullptr) {
        if (node->Name == "serialports") {
            ParseSerialPorts(node->Child);
        }
        if (node->Name == "registration") {
            ParseRegistration(node);
//            _registrator->SetRecordSize();
        }
        if (node->Name == "diagnostic") {
            ParseDiagnostic(node);
        }
        if (node->Name == "trmess") {
            ParseTrMess(node);
        }
        node = node->Next;
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseTrMess(NodeXML *node)
{
    int index;
    if (node->Child != nullptr) {
        node = node->Child;
        while (node != nullptr) {
            if (node->Name == "message") {
                TrMess *newMess = new TrMess;
                newMess->text = node->Text;
                for (int i = 0; i < node->Attributes.count(); i++) {
                    AttributeXML *attr = node->Attributes[i];
                    if (attr->Name == "delay")
                        newMess->delay = attr->Value.toInt();
                    if (attr->Name == "output")
                        newMess->output = attr->Value.toInt();
                    if (attr->Name == "system")
                        newMess->system = attr->Value.toInt();
                    if (attr->Name == "repair")
                        newMess->repair = attr->Value.toInt();
                    if (attr->Name == "index")
                        index = attr->Value.toInt();
                }
                _tr_messages[index] = newMess;
                //Storage.Add(newMess->Variable, newPar->Type);
            }
            node = node->Next;
        }
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseDiagnostic(NodeXML *node)
{
    for (int i = 0; i < node->Attributes.count(); i++) {
        AttributeXML *attr = node->Attributes[i];
        if (attr->Name == "interval")
            _diag_interval = attr->Value.toInt();
    }
    if (node->Child != nullptr) {
        node = node->Child;
        while (node != nullptr) {
            if (node->Name == "par") {
                Parameter *newPar = new Parameter;
                newPar->Parse(node);
                _mainstore.Add(newPar->Variable, newPar);
            } else if (node->Name == "path") {
                _mtr_file.setFileName(node->Text);
            }
            node = node->Next;
        }
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseSerialPorts(NodeXML *node)
{
    while (node != nullptr) {
        if (node->Name == "spstream") {   // serial port stream
            ThreadSerialPort *newPort = new ThreadSerialPort;
            newPort->Parse(node);
            _serial_ports[newPort->Alias] = newPort; //SerialPorts.append(newPort);
        }
        node = node->Next;
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseRegistration(NodeXML* node) {
    int i;
    QString path, alias, extention, drive;
    RegistrationType regtype = RegistrationType::Record;
    int quantity = 0, recordsize = 0, interval = 0, save_interval = 0;;
    if (node->Child != nullptr) {
        node = node->Child;
        while (node != nullptr) {
            if (node->Name == "path")
                path = node->Text;
            else if (node->Name == "file") {
                alias = node->Text;
                for (i = 0; i < node->Attributes.count(); i++) {
                    AttributeXML *attr = node->Attributes[i];
                    if (attr->Name == "ext")
                        extention = attr->Value.toLower();
                    if (attr->Name == "type")
                        regtype = (attr->Value.toLower() == "bulk") ? RegistrationType::Bulk : ((attr->Value.toLower() == "archive") ? RegistrationType::Archive : RegistrationType::Record);
                }
            }
            else if (node->Name == "records") {
                quantity = node->Text.toInt();
                for (i = 0; i < node->Attributes.count(); i++) {
                    AttributeXML *attr = node->Attributes[i];
                    if (attr->Name == "size")
                        recordsize = attr->Value.toInt();
                    if (attr->Name == "interval")
                        interval = attr->Value.toInt();
                }
            }
            else if (node->Name == "save") {
                drive = node->Text;
                for (i = 0; i < node->Attributes.count(); i++) {
                    AttributeXML *attr = node->Attributes[i];
                    if (attr->Name == "interval")
                        save_interval = attr->Value.toInt();
                }
            }
            node = node->Next;
        }
    }
    _registrator->SetParameters(path, alias, extention, regtype, quantity, recordsize, interval);
    _saver->SetParameters(drive, path, save_interval);
}
//------------------------------------------------------------------------------
// New realisation
QJsonArray Processor::getParamKdrFoot()
{
    int par1 = 0, par2 = 0, par8 = 0, par9 = 0;
    for ( QMap<int, TrMess*>::iterator i = _tr_messages.begin(); i != _tr_messages.end(); i++) {
        if (i.key() != 90) {
            if (_mainstore.Bit("PROG_TrSoob", i.key())) { // main section
                par1 = 1;
                if (_section == 0) {
                    if ((i.key() >= 1 && i.key() <= 4) || (i.key() >= 21 && i.key() <= 24) || (i.key() >= 31 && i.key() <= 34)) // electric
                        par8 = 1;
                    if (i.key() == 5 || i.key() == 6 || i.key() == 7 || i.key() == 45 || i.key() == 46 ) // diesel
                        par9 = 1;
                }
            }
            if (_slave.Storage()->Bit("PROG_TrSoob", i.key())) { // additional section
                par2 = 1;
                if (_section == 1) {
                    if ((i.key() >= 1 && i.key() <= 4) || (i.key() >= 21 && i.key() <= 24) || (i.key() >= 31 && i.key() <= 34)) // electric
                        par8 = 1;
                    if (i.key() == 5 || i.key() == 6 || i.key() == 7 || i.key() == 45 || i.key() == 46 ) // diesel
                        par9 = 1;
                }
            }
        }
    }
    return { par1, par2, par8, par9 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrFtDzl()
{
    int par1 = 0, par2 = 0, par6 = 0, par7 = 0, par8 = 0, par9 = 0;
    for ( QMap<int, TrMess*>::iterator i = _tr_messages.begin(); i != _tr_messages.end(); i++) {
        if (i.key() != 90) {
            if (_mainstore.Bit("PROG_TrSoob", i.key())) {
                par1 = 1;
                if (_section == 0) {
                    if (i.key() == 5)
                        par6 = 1;
                    if (i.key() == 6)
                        par7 = 1;
                    if (i.key() == 7)
                        par8 = 1;
                    if (i.key() == 45 || i.key() == 46)
                        par9 = 1;
                }
            }
            if (_slave.Storage()->Bit("PROG_TrSoob", i.key())) {
                par2 = 1;
                if (_section == 1) {
                    if (i.key() == 5)
                        par6 = 1;
                    if (i.key() == 6)
                        par7 = 1;
                    if (i.key() == 7)
                        par8 = 1;
                    if (i.key() == 45 || i.key() == 46)
                        par9 = 1;
                }
            }
        }
    }
    return { par1, par2, par6, par7, par8, par9 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrFtElektr()
{
    int par1 = 0, par2 = 0, par6 = 0, par7 = 0, par8 = 0, par9 = 0;
    for ( QMap<int, TrMess*>::iterator i = _tr_messages.begin(); i != _tr_messages.end(); i++) {
        if (i.key() != 90) {
            if (_mainstore.Bit("PROG_TrSoob", i.key())) {
                par1 = 1;
                if (_section == 0) {
                    if (i.key() == 1 || i.key() == 21 || i.key() == 31)
                        par6 = 1;
                    if (i.key() == 2 || i.key() == 22 || i.key() == 32)
                        par7 = 1;
                    if (i.key() == 3 || i.key() == 23 || i.key() == 33)
                        par8 = 1;
                    if (i.key() == 4 || i.key() == 24 || i.key() == 34)
                        par9 = 1;
                }
            }
            if (_slave.Storage()->Bit("PROG_TrSoob", i.key())) {
                par1 = 2;
                if (_section == 1) {
                    if (i.key() == 1 || i.key() == 21 || i.key() == 31)
                        par6 = 1;
                    if (i.key() == 2 || i.key() == 22 || i.key() == 32)
                        par7 = 1;
                    if (i.key() == 3 || i.key() == 23 || i.key() == 33)
                        par8 = 1;
                    if (i.key() == 4 || i.key() == 24 || i.key() == 34)
                        par9 = 1;
                }
            }
        }
    }
    return { par1, par2, par6, par7, par8, par9 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrBos()
{
    return {
       _storage[_section]->Float("USTA_Ubs_filtr"), _storage[_section]->Int16("DIAG_Rplus"), _storage[_section]->Int16("DIAG_Rminus"),
       _storage[_section]->Float("USTA_Iakb"), _storage[_section]->Int16("USTA_Ucu"), _storage[_section]->Float("USTA_Ivzb_vst"),
       _storage[_section]->Float("USTA_Ugol_uvvg"), _storage[_section]->Float("USTA_Ugol_uvvg") / 60, // ?? 60 - ?
       _control->KdrBos(_section)
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrVzb()
{
    return { _storage[_section]->Float("USTA_Ig_filtr"), _storage[_section]->Float("USTA_Ug_filtr"), _storage[_section]->Float("USTA_Ivzb_gen"),
                _storage[_section]->Float("USTA_Ugol_uvvg"), _control->KdrVzb(_section) };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrTed()
{
    return { _storage[_section]->Float("USTA_Ig_filtr"), _storage[_section]->Float("USTA_Ited1_filtr"), _storage[_section]->Float("USTA_Ited2_filtr"),
                _control->KdrTed(_section) };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrSvz()
{
    return { _storage[_section]->Float("USTA_Ubs_filtr"),
             QJsonArray  { _storage[_section]->Bit("DIAG_Connections", CONN_BEL), _storage[_section]->Bit("DIAG_Connections", CONN_USTA),
                        _storage[_section]->Bit("DIAG_Connections", CONN_IT),_storage[_section]->Bit("DIAG_Connections", CONN_MSS), false },
                _diagnostics->PortsState(), _storage[_section]->Byte("DIAG_CQ_MSS"),
                0, 0, _storage[_section]->Byte("DIAG_CQ_IT"), _storage[_section]->Byte("DIAG_CQ_USTA"), _storage[_section]->Byte("DIAG_CQ_BEL") };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrReo()
{
    return {
        _storage[_section]->Int16("IT_THA19"), _storage[_section]->Int16("IT_THA21"), _storage[_section]->Int16("IT_THA23"), _storage[_section]->Int16("IT_THA12"), _storage[_section]->Int16("IT_THA10"), _storage[_section]->Int16("IT_THA8"), // ТЦ
        _storage[_section]->Int16("IT_THA11"), _storage[_section]->Int16("IT_THA2"), // ТК
        _storage[_section]->Int16("USTA_N"), _storage[_section]->Float("USTA_Ug_filtr") * _storage[_section]->Float("USTA_Ig_filtr") * 0.001, _storage[_section]->Float("USTA_Pg_zad"), _storage[_section]->Float("USTA_Ug_filtr"),
        _storage[_section]->Float("USTA_Ug_zad"), _storage[_section]->Float("USTA_Ig_filtr"), _storage[_section]->Float("USTA_Ited1_filtr"), _storage[_section]->Float("USTA_Ited2_filtr"), _storage[_section]->Float("USTA_Ivzb_gen"),
        _storage[_section]->Float("USTA_Iakb"), _storage[_section]->Float("USTA_Ubs_filtr"),
        _storage[_section]->Float("USTA_Ugol_uvvg"), _storage[_section]->Float("USTA_Ugol_vsv"),
        _storage[_section]->Float("USTA_Po_diz") * 0.1, _storage[_section]->Float("USTA_Pf_tnvd") * 0.1, // !!!!!!!
        _storage[_section]->Float("IT_TSM6"), _storage[_section]->Float("IT_TSM4"),
        _storage[_section]->Bit("USTA_Outputs", USTA_OUTPUTS_OP1) ? 1 : 0, _storage[_section]->Bit("USTA_Outputs", USTA_OUTPUTS_OP2) ? 1: 0
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrDizl() // Разобраться с цветом гистограмм
{
    return {
    _storage[_section]->Bit("DIAG_Connections", CONN_IT),
    _storage[_section]->Int16("USTA_N"), _storage[_section]->Float("IT_TSM1"), // N, темп хол спая
    QJsonArray { _storage[_section]->Int16("IT_THA19"), _storage[_section]->Int16("IT_THA21"), _storage[_section]->Int16("IT_THA23"),
    _storage[_section]->Int16("IT_THA12"), _storage[_section]->Int16("IT_THA10"), _storage[_section]->Int16("IT_THA8") }, // ТЦ
    QJsonArray { _storage[_section]->Int16("IT_THA11"), _storage[_section]->Int16("IT_THA2") }, // ТК
    _control->MinTC[_section], _control->MaxTC[_section], _control->AvgTC[_section],
    QJsonArray { _control->DeltaTC[_section][0], _control->DeltaTC[_section][1], _control->DeltaTC[_section][2],
    _control->DeltaTC[_section][3], _control->DeltaTC[_section][4], _control->DeltaTC[_section][5] } };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrMasl()
{
    return { _storage[_section]->Float("USTA_Po_diz") / 10, _storage[_section]->Float("IT_TSM3"), _storage[_section]->Float("USTA_Po_mn2") / 10,
                _storage[_section]->Float("IT_TSM4"), _storage[_section]->Int16("USTA_N"), _control->KdrMasl(_section) };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrTpl() { // первые два параметра: объем и масса
    float PiF = _storage[_section]->Float("USTA_Pf_ftot") / 10, PiD = _storage[_section]->Float("USTA_Pf_tnvd") / 10;
    return { 0, 0, PiF, PiF - PiD, PiD, _storage[_section]->Float("IT_TSM6"), _storage[_section]->Int16("USTA_N"), _control->KdrTpl(_section) };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrOhl()
{
    return { _storage[_section]->Float("IT_TSM9"), _storage[_section]->Float("IT_TSM8"), _storage[_section]->Float("IT_TSM10"), _storage[_section]->Float("IT_TSM6"),
                _storage[_section]->Int16("USTA_N"), _control->KdrOhl(_section) };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrMot()
{
    return { (qint32)_storage[_section]->UInt32("DIAG_Motoresurs"), (qint32)_storage[_section]->UInt32("DIAG_Tt"),(qint32)_storage[_section]->UInt32("DIAG_Adiz") / 10, _storage[_section]->Int16("USTA_N") };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrAvProgrev()
{
    return {
        _storage[_section]->Float("USTA_Iakb"), _storage[_section]->Float("USTA_Ubs_filtr"),
         _storage[_section]->Float("IT_TSM4"), _storage[_section]->Float("IT_TSM11"), _storage[_section]->Float("IT_TSM6"), _storage[_section]->Float("IT_TSM12"), _storage[_section]->Float("IT_TSM13"),
        rand() % 1000 // wFdzU - и так везде, где F
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrSmlMain()
{
    int Ig, ogrUgMax = 0, ogrIgMax = 0;
    if (_storage[_section]->Bit("USTA_Inputs", USTA_INPUTS_BELEDT) && _storage[_section]->Bit("USTA_Inputs", USTA_INPUTS_RET)) // Признак «Выход БЭЛ ЭДТ» и Признак «РЭТ по сх. КВТ 1,2»
        Ig = _storage[_section]->Float("USTA_Itorm_zad");
    else
        Ig = _storage[_section]->Float("USTA_Ig_filtr");

    if (_storage[_section]->Bit("USTA_Inputs", USTA_INPUTS_KV)) // Признак КВ
        ogrUgMax = 800;
    if (_storage[_section]->Bit("USTA_Inputs", USTA_INPUTS_KV)) // Признак КВ
        ogrIgMax = 2000;
    return { QJsonArray  { _storage[_section]->Bit("DIAG_Connections", CONN_USTA), _storage[_section]->Bit("DIAG_Connections", CONN_IT) },
        Ig, _storage[_section]->Float("USTA_Ug_filtr"), _storage[_section]->Float("IT_TSM6"), _storage[_section]->Float("IT_TSM3"),
                ogrIgMax, ogrUgMax, _control->KdrSmlMain(_section) };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamFrameTop()
{
    int min[10] = { 240, 240, 240, 240, 307, 377, 457, 547, 627, 738};
    int max[10] = { 315, 315, 315, 315, 352, 422, 502, 592, 672, 757};
    int bt = _storage[_section]->Byte("BEL_PKM") & 0x30; //= dab[0,7];
    int dsk_iAPvkl1 = 0; // dsk_iAPvkl1= dsk[0,iAPvkl1]; // не используется
    int dsk_iSA1 = 1;   // dsk_iSA1  = dsk[0,iSA1 ];
    int dsk_iKMv0 = 1;  // dsk_iKMv0 = dsk[0,iKMv0];
    int dsk_iDizZ = 0;  // dsk_iDizZ = dsk[0,iDizZ];
    int pkm = _mainstore.Int16("PROG_PKM");

    int n_diz = _storage[_section]->Int16("USTA_N");
    float pt_min = 0, pt_max = 0, pm_min = 0, pm_max = 0, nd_min = 0, nd_max = 0;
    if (n_diz >= 100) {
        pm_min = 17;
        pm_max = 53;
        if (_pt_max > 3) {
            pt_min = 40;
            pt_max = 65;
        } else {
            pt_min = 5;
            pt_max = 25;
        }
        nd_min = min[pkm];
        nd_max = max[pkm];
    }
    return {
         _storage[_section]->Bit("DIAG_Connections", CONN_USTA),
        QJsonArray { pkm,  _mainstore.Int16("PROG_Reversor"), _mainstore.Int16("PROG_Regime") },
        QJsonArray { QTime::currentTime().toString("HH:mm:ss"), QDate::currentDate().toString("dd/MM/yy") },
        QJsonArray { "", // RejPrT
            (bt == 0x00) ? "" : ((bt == 0x10) ? "Прожиг коллектора": "Завершение прожига"), // RejPro
            (dsk_iAPvkl1 == 00) ? "" : ((dsk_iSA1 == 01) ? "Режим АвтоПрогрева" : ((dsk_iKMv0 == 00) ? "АП: Установи ПКМ в 0" : ((dsk_iDizZ == 00) ? "АП: Запусти дизель" : ""))), },
        RejPrT(), // getRejPrT// RejAP
        rand() % 100, // load usb indicator
        QJsonArray { _storage[_section]->Float("USTA_Pf_tnvd") * 0.1, pt_min * 0.01, pt_max * 0.01,
                    _storage[_section]->Float("USTA_Po_diz") * 0.1, pm_min * 0.01, pm_max * 0.01,  n_diz, nd_min, nd_max } }; // !!! исправить нормирование!!!
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamFrameLeft() {
    bool iKVmain_own = _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_KV);
    bool iKVmain_add = _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_KV);
    //bool iKVadd = _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_KV);
    return {
        QJsonArray { _storage[0]->Bit("DIAG_Connections", CONN_USTA), _storage[1]->Bit("DIAG_Connections", CONN_USTA) },
        _storage[0]->Float("USTA_Ug_filtr") * _storage[0]->Float("USTA_Ig_filtr") * 0.001,
        _storage[1]->Float("USTA_Ug_filtr") * _storage[1]->Float("USTA_Ig_filtr") * 0.001,
        _storage[0]->Float("USTA_Ubs_filtr"), _storage[1]->Float("USTA_Ubs_filtr"),
        _storage[0]->Float("USTA_Iakb"), _storage[1]->Float("USTA_Iakb"),
        QJsonArray { iKVmain_own && _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_OM2), iKVmain_own && _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_OM1), _storage[0]->Bit("USTA_Outputs", USTA_OUTPUTS_BOKS), // OM1, OM2, боксование
                _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_URV), _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_RZ), _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_OBTM) } , // ур. воды, реле земли,обрыв ТМ
        QJsonArray { iKVmain_add && _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_OM2), iKVmain_add && _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_OM1), _storage[1]->Bit("USTA_Outputs", USTA_OUTPUTS_BOKS), // OM1, OM2, боксование
                _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_URV), _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_RZ), _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_OBTM) } , // ур. воды, реле земли,обрыв ТМ
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::RejPrT()

{
    QJsonArray arr;
    int t;
    QString  vzbl_msg, vzbl_tm ;
    int d = rand() % 4000;// dal[0,lTxox];

    QString TxS= "00";
    QString TxM= "00";
    QString TxC= "00";
    QString capt= "00:00:00";

    if (d == 0) {
        // TxC.Visible:=false; TxM.Visible:=false; TxS.Visible:=false; TxT.Visible:=false;
        // RejPrT.Visible:=false;
        capt= "00:00:00";
        vzbl_msg = "0"; // сообщение убрали
        vzbl_tm = "0";  // время убрали
    }
    else
    {
        t = (d % 60); // inttostr( d mod 60);  //секунды    х.х.
        TxS.setNum(t);

        t = (d%3600)/60; // inttostr((d mod 3600)div 60);  //минуты
        TxM.setNum(t);

        t = d/3600; // inttostr( d div 3600 );  //часы
        TxC.setNum(t);

        //  if(dal[0,lTxox]<2400)then begin //40мин
        if (d<2400) { //40мин
            // TxC.Font.Color:=clGray;TxM.Font.Color:=clGray; TxS.Font.Color:=clGray; TxT.Font.Color:=clGray;
            // RejPrT.Visible:=false;
            vzbl_msg = "0"; // сообщение убираем
            vzbl_tm = "1";  // время серое

        }
        else
        {
            // TxC.Font.Color:=clYellow;TxM.Font.Color:=clYellow; TxS.Font.Color:=clYellow; TxT.Font.Color:=clYellow;
            // RejPrT.Visible:=true;
            vzbl_msg = "1"; // сообщение показываем
            vzbl_tm = "2";  // время желтое
        }

        // TxC.Visible:=true; TxM.Visible:=true;
        // TxS.Visible:=true; TxT.Visible:=true;
        // capt = TxC +" : "+ TxM+" : " + TxS;
    }
    arr.append(TxC +" : "+ TxM+" : " + TxS);
    arr.append(vzbl_msg);
    arr.append(vzbl_tm);

    return arr;
}
//------------------------------------------------------------------------------
QStringList Processor::getStructAnlg(int indx)
{
    QStringList list;
    list.append(zapAnalog[indx].r);
    list.append(zapAnalog[indx].n);
    list.append(zapAnalog[indx].o);
    list.append(zapAnalog[indx].i);
    list.append(zapAnalog[indx].a);
    return list;
}
//------------------------------------------------------------------------------
QStringList Processor::getStructDiskr(int indx)
{
    QStringList list;
    list.append(zapDiskr[indx].r);
    list.append(zapDiskr[indx].n);
    list.append(zapDiskr[indx].o);
    list.append(zapDiskr[indx].i);
    return list;
}
//------------------------------------------------------------------------------
// Discret values for tables
QJsonArray Processor::getDiskretArray(int offset) {
    QJsonArray result;
    QString key;
    switch (offset) {
    case (0) : // БЭЛ Дискретные выходы
        key = "BEL_Keys";
        break;
    case (24) : // БЭЛ Дискретные входы
        key = "BEL_Inputs";
        break;
    case (48) : // УСТА Дискретные выходы
        key = "USTA_Outputs";
        break;
    case (72) : // УСТА Дискретные входы
        key = "USTA_Inputs";
        break;
    }
    if (_storage[_section]->Exist(key, DataType::Bits)) {
        QBitArray* bits(_storage[_section]->Bits(key));

    bits->resize(24);
    result = { bits->testBit(0), bits->testBit(1), bits->testBit(2), bits->testBit(3), bits->testBit(4), bits->testBit(5), bits->testBit(6), bits->testBit(7),
             bits->testBit(8), bits->testBit(9), bits->testBit(10), bits->testBit(11), bits->testBit(12), bits->testBit(13), bits->testBit(14), bits->testBit(15),
             bits->testBit(16), bits->testBit(17), bits->testBit(18), bits->testBit(19), bits->testBit(20), bits->testBit(21), bits->testBit(22), bits->testBit(23) };
    return result;
    }
    else {
        return { false, false, false, false, false, false, false, false,
         false, false, false, false, false, false, false, false,
         false, false, false, false, false, false, false, false };
    }
}
//------------------------------------------------------------------------------
// Discret values for tables
QJsonArray Processor::getAnalogArray(int offset) {
    QJsonArray result;
    QBitArray* bits; //(_storage[_section]->Bits("BEL_Diagn"));
    //qint8 byte;
    switch (offset) {
    case (0) : // USTA
        result = { 2, _storage[_section]->Float("USTA_Ug"), _storage[_section]->Float("USTA_Ig"), _storage[_section]->Float("USTA_Ubuks2"), _storage[_section]->Float("USTA_Ubuks1"), _storage[_section]->Int16("USTA_Ucu"),
                 _storage[_section]->Float("USTA_Ited1"), _storage[_section]->Float("USTA_Ited2"), _storage[_section]->Float("USTA_Ubs"), _storage[_section]->Float("USTA_Ivzb_vst"), _storage[_section]->Float("USTA_Pf_tnvd") };
        break;
    case (10) : // USTA
        result = { 2, _storage[_section]->Float("USTA_Pf_ftot"), _storage[_section]->Float("USTA_Iakb"), _storage[_section]->Float("USTA_Po_diz"), _storage[_section]->Float("USTA_Po_mn2"), _storage[_section]->Float("USTA_Ivzb_gen"),
                 _storage[_section]->Int16("USTA_PKM"), _storage[_section]->Int16("USTA_N"), _storage[_section]->Int16("USTA_F"), _storage[_section]->Float("USTA_Ubs_filtr"), _storage[_section]->Float("USTA_Ugol_vsv") };
        break;
    case (20) : // USTA
        result = { 2, _storage[_section]->Float("USTA_Ug_zad"), _storage[_section]->Float("USTA_Ug_filtr"), _storage[_section]->Float("USTA_Ugol_uvvg"), _storage[_section]->Float("USTA_Ig_filtr"), _storage[_section]->Float("USTA_Ited1_filtr"),
                   _storage[_section]->Float("USTA_Ited2_filtr"), _storage[_section]->Float("USTA_Pg_zad"), _storage[_section]->Float("USTA_Pg_rasch"), _storage[_section]->Float("USTA_Pg"), _storage[_section]->Int16("USTA_Regim_rn") };
        break;
    case (30) : // USTA
        result = { 2, _storage[_section]->Float("USTA_Itorm_zad"), _storage[_section]->Float("USTA_Ivozb_zad"), _storage[_section]->Float("USTA_Ubuks1_filtr"), _storage[_section]->Float("USTA_Ubuks2_filtr"), _storage[_section]->Int16("USTA_Flag_buks"),
                   _storage[_section]->Int16("USTA_Rezerv1"), _storage[_section]->Int16("USTA_Rezerv2"), _storage[_section]->Int16("USTA_Rezerv3"), _storage[_section]->Int16("USTA_Rezerv4"), _storage[_section]->Int16("USTA_Rezerv5") };
        break;
    case (40) : // BEL
        bits = _storage[_section]->Bits("BEL_Diagn");
        result = { 0, (int)bits->testBit(0), (int)bits->testBit(1), (int)bits->testBit(2), (int)bits->testBit(3),
                   (int)bits->testBit(4), (int)bits->testBit(5), (int)bits->testBit(6), (int)bits->testBit(7),
                   _storage[_section]->Byte("BEL_PKM"), 0 };
        break;
    case (50) : // TI TSM
        result = { 2, _storage[_section]->Float("IT_TSM1"), _storage[_section]->Float("IT_TSM2"), _storage[_section]->Float("IT_TSM3"), _storage[_section]->Float("IT_TSM4"), _storage[_section]->Float("IT_TSM5"), _storage[_section]->Float("IT_TSM6"),
                 _storage[_section]->Float("IT_TSM7"), _storage[_section]->Float("IT_TSM8"), _storage[_section]->Float("IT_TSM9"), _storage[_section]->Float("IT_TSM10") };
        break;
    case (60) : // TI TSM
        result = { 2, _storage[_section]->Float("IT_TSM11"), _storage[_section]->Float("IT_TSM12"), _storage[_section]->Float("IT_TSM13"), _storage[_section]->Float("IT_TSM14"), _storage[_section]->Float("IT_TSM15"), _storage[_section]->Float("IT_TSM16"),
                 _storage[_section]->Float("IT_TSM17"), _storage[_section]->Float("IT_TSM18"), _storage[_section]->Float("IT_TSM19"), _storage[_section]->Float("IT_TSM20") };
        break;
    case (70) : // TI TSM
        result = { 2, _storage[_section]->Float("IT_TSM21"), _storage[_section]->Float("IT_TSM22"), _storage[_section]->Float("IT_TSM23"), _storage[_section]->Float("IT_TSM24"), 0, 0, 0, 0, 0, 0 };
        break;
    case (80) : // TI THA
        result = { 0, _storage[_section]->Int16("IT_THA1"), _storage[_section]->Int16("IT_THA2"), _storage[_section]->Int16("IT_THA3"), _storage[_section]->Int16("IT_THA4"), _storage[_section]->Int16("IT_THA5"), _storage[_section]->Int16("IT_THA6"),
                 _storage[_section]->Int16("IT_THA7"), _storage[_section]->Int16("IT_THA8"), _storage[_section]->Int16("IT_THA9"), _storage[_section]->Int16("IT_THA10") };
        break;
    case (90) : // TI THA
        result = { 0, _storage[_section]->Int16("IT_THA11"), _storage[_section]->Int16("IT_THA12"), _storage[_section]->Int16("IT_THA13"), _storage[_section]->Int16("IT_THA14"), _storage[_section]->Int16("IT_THA15"), _storage[_section]->Int16("IT_THA16"),
                 _storage[_section]->Int16("IT_THA17"), _storage[_section]->Int16("IT_THA18"), _storage[_section]->Int16("IT_THA19"), _storage[_section]->Int16("IT_THA10") };
        break;
    case (100) : // TI THA
        result = { 0, _storage[_section]->Int16("IT_THA21"), _storage[_section]->Int16("IT_THA22"), _storage[_section]->Int16("IT_THA23"), _storage[_section]->Int16("IT_THA24"), 0, 0, 0, 0, 0, 0 };
        break;
    }
    return result;
}
//------------------------------------------------------------------------------
// Old realisation

//int Processor::getReversor()
//{
//   // if(revs=dab[0,bReV])then exit;revs:=dab[0,bReV];

//    int revs = rand() % 4;// // заглушка пока возвращем число в диапазоне от 0 до 3
//    return revs;
//}

//int Processor::getPKM()
//{
//   //  int pkms:=dab[0,bPKV];
//    int pkm = rand() % 10; // заглушка
//    return pkm;
//}

//int Processor::getRegim()
//{
//    int rg = rand() % 4; // заглушка
//    // if not(dab[0,bRjV]in[1..3])then Visible:=false
//    // rg = dab[0,bRjV];

//     if ( (rg != 1) & (rg !=2 ) & (rg !=3 ) ) { rg = 0; }  // нет режима - не отрисовывать

//    return rg;
//}

////*****************************************
//QString Processor::getRejPrT(QString param)

//{

//   int t;
//   QString  vzbl_msg, vzbl_tm ;
//   int d = rand() % 4000;// dal[0,lTxox];

//   QString TxS= "00";
//   QString TxM= "00";
//   QString TxC= "00";
//   QString capt= "00:00:00";

//   if (d==0) {
//        // TxC.Visible:=false; TxM.Visible:=false; TxS.Visible:=false; TxT.Visible:=false;
//        // RejPrT.Visible:=false;
//        capt= "00:00:00";
//        vzbl_msg = "0"; // сообщение убрали
//        vzbl_tm = "0";  // время убрали
//    }
//    else
//    {
//              t = (d%60); // inttostr( d mod 60);  //секунды    х.х.
//              TxS.setNum(t);

//              t = (d%3600)/60; // inttostr((d mod 3600)div 60);  //минуты
//              TxM.setNum(t);

//              t = d/3600; // inttostr( d div 3600 );  //часы
//              TxC.setNum(t);

//                //  if(dal[0,lTxox]<2400)then begin //40мин
//                if (d<2400) { //40мин
//                            // TxC.Font.Color:=clGray;TxM.Font.Color:=clGray; TxS.Font.Color:=clGray; TxT.Font.Color:=clGray;
//                            // RejPrT.Visible:=false;
//                            vzbl_msg = "0"; // сообщение убираем
//                            vzbl_tm = "1";  // время серое

//                            }
//                            else
//                            {
//                            // TxC.Font.Color:=clYellow;TxM.Font.Color:=clYellow; TxS.Font.Color:=clYellow; TxT.Font.Color:=clYellow;
//                            // RejPrT.Visible:=true;
//                            vzbl_msg = "1"; // сообщение показываем
//                            vzbl_tm = "2";  // время желтое
//                            }

//     // TxC.Visible:=true; TxM.Visible:=true;
//     // TxS.Visible:=true; TxT.Visible:=true;
//     // capt = TxC +" : "+ TxM+" : " + TxS;
//     }
//if (param == "value") { capt = TxC +" : "+ TxM+" : " + TxS;;}

//if (param == "ms") {capt = vzbl_msg;}

//if (param == "tm") {capt = vzbl_tm;}

//{return capt;}
//}
////*****************************************
//QString Processor::getRejPro()
//{
////исходник    with RejPro do
////    if((dab[0,7]and $30)=$00)
////    then Visible:=false
////    else
////      begin          //прожиг коллектора
////           if ((dab[0,7]and $30)=$10)
////           then Caption:='Прожиг коллектора'
////           else Caption:='Завершение прожига';
////           Visible:=true;
////      end;

// QString capt;
// int bt = rand() % 48 ; //= dab[0,7];

//      if ( (bt & 0x30) == 0x00) {
//       capt = ""; }
//      else
//        {    //прожиг коллектора
//             if ((bt & 0x30) == 0x10)
//             { capt = "Прожиг коллектора"; }
//             else capt = "Завершение прожига";

//        };

//    return capt;
//}
////********************************************
//QString Processor::getRejAP()
//{
////{$IFDEF ES_OBO}  исходник  with RejAP do
////    if(dsk[0,iAPvkl1]=00)
////    then Visible:=false //режим автопрогрева
////    else
////       begin
////        if(dsk[0,iSA1 ]=01)then Caption:='Режим АвтоПрогрева'  else
////         if(dsk[0,iKMv0]=00)then Caption:='АП: Установи ПКМ в 0'else
////            if(dsk[0,iDizZ]=00)then Caption:='АП: Запусти дизель'  else
////                                Caption:='';
////        Visible:=true;
////       end;{$ENDIF}

// QString capt;
// int dsk_iAPvkl1 = rand() % 3 ; // dsk_iAPvkl1= dsk[0,iAPvkl1];
// int dsk_iSA1=1 ;  // dsk_iSA1  = dsk[0,iSA1 ];
// int dsk_iKMv0=1;  // dsk_iKMv0 = dsk[0,iKMv0];
// int dsk_iDizZ= 0; // dsk_iDizZ = dsk[0,iDizZ];

//     if(dsk_iAPvkl1 == 00){
//        capt = ""; } //режим автопрогрева
//     else
//        {
//         if(dsk_iSA1 == 01) { capt="Режим АвтоПрогрева"; }  else
//          if(dsk_iKMv0 == 00) { capt="АП: Установи ПКМ в 0"; } else
//             if( dsk_iDizZ == 00) { capt="АП: Запусти дизель" ;} else
//                                  capt="";
//         };

//    return capt;
//}
////***********************************************
//QString Processor::getParam()
//{
//    int d = rand() % 1000 ;
//    QString v = QString::number(d);
//    return v;
//}

//QString Processor::getParamExt(int ext)
//{
//   float d = rand() % 1000 ;
//   QString v = QString::number(d, 'f', ext);
//   return v;
//}

//QString Processor::getParamDiap(int diapazon)
//{
//    float d = rand() % diapazon ;
//    QString v = QString::number(d);
//    return v;
//}

//QString Processor::tm()
//{// текущее время
//    QString v = QTime::currentTime().toString("HH:mm:ss");
//    return v;
//}

//QString Processor::dt()
//{// текущая дата
//    QString v = QDate::currentDate().toString("dd/MM/yy");
//    return v;
//}

//int Processor::mysz()
//{// проверка размерности разных структур
//    // QString v = QDate::currentDate().toString("dd/MM/yy");
//    QString v = "ффффффф"; // указатель на строку/  размер указателя 4 байта
//    int r=v.count();// количество символов

//    // QByteArray vv[] = "я";
//    //char vv[] = "я";
//    //int r = sizeof(vv); // размер в байтах

//    return r;
//}

////QString Connector::getStructAnlg_r(int indx, QString &s1, QString &s2, QString &s3, QString &s4, QString &s5)
////{

////    s1 = zapAnalog[indx].r;
////    s2 = zapAnalog[indx].n;
////    s3 = zapAnalog[indx].o;
////    s4 = zapAnalog[indx].i;
////    s5 = zapAnalog[indx].a;

////    return s1;
////}

//QString Processor::getStructAnlg_r(int indx){return zapAnalog[indx].r;}
//QString Processor::getStructAnlg_n(int indx){return zapAnalog[indx].n;}
//QString Processor::getStructAnlg_o(int indx){return zapAnalog[indx].o;}
//QString Processor::getStructAnlg_i(int indx){return zapAnalog[indx].i;}
//QString Processor::getStructAnlg_a(int indx){return zapAnalog[indx].a;}

//QString Processor::getStructDiskr_r(int indx){return zapDiskr[indx].r;}
//QString Processor::getStructDiskr_n(int indx){return zapDiskr[indx].n;}
//QString Processor::getStructDiskr_o(int indx){return zapDiskr[indx].o;}
//QString Processor::getStructDiskr_i(int indx){return zapDiskr[indx].i;}

//***********************************************
//int  Processor::getTrevogaTotal(int indx)//возвращает состояние лампочки-ошибки для главного(верхнего меню)
//{
//    // indx - номер лампочки, потом по нему к массиву будем обращаться
//    // массив TrTotal создадим в другой подпрограмме

//    int d = rand() % 2 ;// ! отладка
//    return d;
//}

//int  Processor::getTrevogaDizel(int indx)//возвращает состояние лампочки-ошибки для Дизельного меню
//{
//    // indx - номер лампочки, потом по нему к массиву будем обращаться
//    // массив TrDizel создадим в другой подпрограмме - согласoвывается с массивом TrTotal

//    int d = rand() % 2 ;// ! отладка
//    return d;
//}

//int  Processor::getTrevogaElektr(int indx)//возвращает состояние лампочки-ошибки для Дизельного меню
//{
//    // indx - номер лампочки, потом по нему к массиву будем обращаться
//    // массив TrDizel создадим в другой подпрограмме - согласoвывается с массивом TrTotal

//    int d = rand() % 2 ; // ! отладка
//    return d;
//}
