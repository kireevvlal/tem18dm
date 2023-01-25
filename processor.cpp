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
//#include <QDebug>
//#include <QTime>
//#include <QDate>
#endif
#include <QSound>
#include <QTextStream>
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
Processor::Processor(QObject *parent) : QObject(parent)
{
    _section = 0;
    _virtual_section = 0;
    _reg_timer = new QTimer();
    _reg_thread = new QThread();
    _registrator = new Registrator(&_settings);
    _diag_timer = new QTimer();
    _diag_interval = 200;
    _diagnostics = new Diagnostics(&_mainstore, &_settings);
    _is_active = false;
    _fswatcher = new QFileSystemWatcher;
    _saver =  new Saver(&_settings);
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
#ifdef Q_OS_WIN
    _fswatcher->addPath("D:/_USB");
#endif
#ifdef  Q_OS_UNIX
    _fswatcher->addPath("/dev");
#endif

    return true;
}
//--------------------------------------------------------------------------------
void Processor::SaveMessagesList() {
    // save tr messages list to file
    if (_trmess_file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&_trmess_file);
        stream.setCodec("UTF-8");
        foreach (QString s, _tr_strings) {
            stream << s << endl;
        }
        _trmess_file.close();
    }
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
//        connect(i.value(), SIGNAL(LostExchangeSignal(QString)), this, SLOT(LostConnection(QString)));
//        connect(i.value(), SIGNAL(RestoreExchangeSignal(QString)), this, SLOT(RestoreConnection(QString)));
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

    connect(_fswatcher, SIGNAL(directoryChanged(QString)), this, SLOT(ChangeMediaDir(QString)));

    _saver->moveToThread(_saver_thread);
    connect(this, SIGNAL(SaveFilesSignal()), _saver, SLOT(Save()));
    connect(this, SIGNAL(ChangeMediaDirSignal()), _saver, SLOT(MediaChange()));
    _saver_thread->start();
    _saver->Run();

    // read tr meaasges
    if (_trmess_file.open(QIODevice::ReadOnly)) {
        while (!_trmess_file.atEnd()) {
            QString str = _trmess_file.readLine();
            str.truncate(str.lastIndexOf("\n"));
            _tr_strings.append(str);
        }
        _trmess_file.close();
    }
    if (_tr_strings.count() >= 300)
        _tr_strings.removeFirst();
    _tr_strings.append(_diagnostics->Date().toString("yy/MM/dd") + " " + _diagnostics->Time().toString("hh:mm:ss") + " Начало работы");
    SaveMessagesList();

    _is_active = true;

//    QSound::play("/home/user/tada.wav");
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
void Processor::ChangeMediaDir(QString dir) {
    ChangeMediaDirSignal();
}
//--------------------------------------------------------------------------------
void Processor::querySaveToUSB() {
//#ifdef Q_OS_WIN
    SaveFilesSignal(); // (dir)
//#endif
//#ifdef Q_OS_UNIX
//    // find flash usb
//#endif
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
    int i, j;
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
    // word diagnostic
    _registrator->SetByteRecord(176, _mainstore.Byte("DIAG_CQ_BEL"));
    _registrator->SetByteRecord(178, _mainstore.Byte("DIAG_CQ_USTA"));
    _registrator->SetByteRecord(180, _mainstore.Byte("DIAG_CQ_IT"));
    _registrator->SetByteRecord(182, _mainstore.Byte("DIAG_CQ_MSS"));
    _registrator->SetWordRecord(184, _mainstore.Int16("DIAG_MESS_NUM"));
    _registrator->SetWordRecord(188, _mainstore.Int16("DIAG_Rplus"));
    _registrator->SetWordRecord(190, _mainstore.Int16("DIAG_Rminus"));
    _registrator->SetWordRecord(198, _mainstore.Int16("DIAG_Pg"));
    // double word diagnostic
    _registrator->SetDoubleWordRecord(206, _mainstore.UInt32("DIAG_Motoresurs"));
    _registrator->SetDoubleWordRecord(210, _mainstore.UInt32("DIAG_Apol"));
    _registrator->SetDoubleWordRecord(214, _mainstore.UInt32("DIAG_Tt"));
    // message params
    if (_tr_reg_queue.empty()) { // not tr soob
        for (i = 0; i < 4; i++)
            _registrator->SetByteRecord(318 + i, 0);
    } else {
        _registrator->SetByteRecord(318, _tr_reg_queue[0].hour); // hour
        _registrator->SetByteRecord(319, _tr_reg_queue[0].minute); // minute
        _registrator->SetByteRecord(320, _tr_reg_queue[0].second); // second
        _registrator->SetByteRecord(322, _tr_reg_queue[0].index); // index
        _tr_reg_queue.removeFirst();
    }
    // date and time
    _registrator->SetByteRecord(326, dt.date().day());
    _registrator->SetByteRecord(327, dt.date().month());
    _registrator->SetByteRecord(328, dt.date().year() % 100);
    _registrator->SetByteRecord(329, dt.time().hour());
    _registrator->SetByteRecord(330, dt.time().minute());
    _registrator->SetByteRecord(331, dt.time().second());
    // discret diagnostic
    quint8 byte;
    QBitArray* ba = _mainstore.Bits("DIAG_Connections");
    for (j = 0; j < 8; j++ )
        byte +=  ba->testBit(j) ? (1 << j) : 0;
    _registrator->SetByteRecord(346, byte);

    ba = _mainstore.Bits("PROG_TrSoob");
    for (i = 0; i < 5; i++) {
        byte = 0;
        for (j = 0; j < 8; j++ )
            byte +=  ba->testBit(i * 8 + j) ? (1 << j) : 0;
        _registrator->SetByteRecord(347 + i, byte);
    }
    AddRecordSignal();
}
//--------------------------------------------------------------------------------
void Processor::DiagTimerStep() {
    int i;
    int banner_key = 0;
    int pku = _mainstore.Int16("USTA_PKM") + (( _mainstore.Bit("DIAG_Connections", CONN_USTA)) ? 1 : 0);
    int pkb = _mainstore.Byte("BEL_PKM") + (( _mainstore.Bit("DIAG_Connections", CONN_BEL)) ? 1 : 0);
    if (pkb > 9)
        pkb = 9;
    if (pku > 9)
        pku = 9;
    _mainstore.SetByte("PROG_PKM", (pkb < pku) ? pku : pkb);
    _mainstore.SetByte("PROG_Regime", _mainstore.Bit("DIAG_Connections", CONN_BEL) ? ((_mainstore.Byte("PROG_Reversor") < 2 || pkb < 2) ? 3
                                                                                   : (_mainstore.Byte("BEL_Diagn") & 1) + 1) : 0); // 3 - XX
    _virtual_section = (_virtual_section == 1) ? 0 : 1;
    _diagnostics->RefreshDT();
    _diagnostics->Motoresurs();
    _diagnostics->Connections(_serial_ports, _registrator, &_slave);
    _diagnostics->RizCU(_mainstore.Byte("PROG_PKM"));
    _diagnostics->APSignalization(_mainstore.Byte("PROG_PKM"));
    SetSlaveData();
    // tr soob
    for ( QMap<int, TrMess*>::iterator it = _tr_messages.begin(); it != _tr_messages.end(); it++) {
        if (it.key() != 90) {
            if (_storage[_virtual_section]->Bit("PROG_TrSoob", it.key())) { // is trevoga
                // registration queue
                if (!_virtual_section) {
                    if (!_tr_states[0][it.key()]->status.testBit(0)) {
                        _tr_states[0][it.key()]->status.setBit(0);
                        _tr_reg_queue.append(TrRec(_diagnostics->Time().hour(), _diagnostics->Time().minute(),
                                                   _diagnostics->Time().second(), i));
                    }
                }
                // string list queue
                if (!_tr_states[_virtual_section][it.key()]->status.testBit(1)) {
                    _tr_states[_virtual_section][it.key()]->status.setBit(1);
                    if (_tr_strings.count() >= 300)
                        _tr_strings.removeFirst();
                    _tr_strings.append(_diagnostics->Date().toString("yy/MM/dd") + " " + _diagnostics->Time().toString("hh:mm:ss") + " " +
                                       FormMessage(_virtual_section, it.key(), it.value()->system) + " " + it.value()->text);
                    // save tr messages list to file
                    SaveMessagesList();
                }
                // banner output
                if (!_tr_states[_virtual_section][it.key()]->status.testBit(2)) { // init
                    _tr_states[_virtual_section][it.key()]->status.setBit(2);
                    _tr_states[_virtual_section][it.key()]->delay = it.value()->delay * 1000;
                    _tr_states[_virtual_section][it.key()]->kvit = false;
                } else { // coorect delay
                    if (_tr_states[_virtual_section][it.key()]->delay > 0) {
                        _tr_states[_virtual_section][it.key()]->delay -= (_diag_interval * 2);
                        if (_tr_states[_virtual_section][it.key()]->delay < 0 )
                            _tr_states[_virtual_section][it.key()]->delay = 0;
                    }
                }
                if (!_tr_states[_virtual_section][it.key()]->kvit) {  // add to queue
                    if (!_tr_states[_virtual_section][it.key()]->delay) {
                        banner_key = it.key() * 10 + _virtual_section;
                        if (!_tr_banner_queue.contains(banner_key)) {
                            _tr_banner_queue[banner_key] = TrBanner { FormMessage(_virtual_section, it.key(), it.value()->system), it.value()->text, _virtual_section, it.key() };
                        }
                    }
                }
            } else { // not trevoga
                if (!_virtual_section) {
                    // registration queue
                    if (_tr_states[0][it.key()]->status.testBit(0)) {
                        // ищем, есть ли в очереди такая тревога
                        for (i = 0; i < _tr_reg_queue.count(); i++)
                            if (_tr_reg_queue[i].index == it.key())
                                break;
                        // есть
                        if (i < _tr_reg_queue.count())
                            _tr_states[0][it.key()]->status.clearBit(0);
                    }
                }
                // string list queue
                if (_tr_states[_virtual_section][it.key()]->status.testBit(1)) {
                    _tr_states[_virtual_section][it.key()]->status.clearBit(1);
                }
                // banner output
                if (_tr_states[_virtual_section][it.key()]->status.testBit(2)) {
                    if (_tr_states[_virtual_section][it.key()]->kvit){
                        _tr_states[_virtual_section][it.key()]->status.clearBit(2);
                        banner_key = it.key() * 10 + _virtual_section;
                        if (_tr_banner_queue.contains(banner_key))
                            _tr_banner_queue.remove(banner_key);
                    }
                }
            }
        }
    }
}
//--------------------------------------------------------------------------------
QString Processor::FormMessage(int sec, int index, int system) {
    QString out;
    if (sec) //section
        out = "секц 2.";
    else
        out = "секц 1.";
    int high = system / 10;
    int low = system % 10;
    switch (high) {// устройство
    case 2: out += "БЭЛ: "; break;
    case 3: out += "УСТА: "; break;
    case 4: out += "СУД: авария "; break;
    case 5: out += "СУД: сокр. нагрузки "; break;
    case 6: out += "СУД: остановка ";  break;
    default:
        out += "Внимание: ";
        switch (low) {
        case 1: out += ("борт. сеть"); break;
        case 3: out += ("тэд"); break;
        case 2: out += ("возбуждение"); break;
        case 4: out += ("моторесурс"); break;
        case 5: out += ("топливо"); break;
        case 6: out += ("масло"); break;
        case 7: out += ("охлаждение"); break;
        case 8: out += ("газы"); break;
        }
    }
    if (high == 4 || high == 5 || high == 6) {
        switch (low) {
        case 1: out += ("топливо"); break;
        case 4: out += ("охлаждение"); break;
        case 7: out += ("картер"); break;
        case 2: out += ("масло"); break;
        case 5: out += ("газы"); break;
        case 8: out += ("отключатели"); break;
        case 3: out += ("воздух"); break;
        case 6: out += ("наддув"); break;
        case 9: out += ("автоматика"); break;
        }
    }
    return out;
}
//--------------------------------------------------------------------------------
void Processor::SetSlaveData()
{
    QByteArray date;
    QBitArray* ba = _mainstore.Bits("PROG_TrSoob");
    QByteArray ts;
    qint8 byte;
    QDate dt = _diagnostics->Date();
    QTime tm = _diagnostics->Time();

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
bool Processor::changeKdr(int kdr) {
    int section = kdr - 1;
//    _control->KdrNum = kdr;
//    section = kdr / 100 - 1;  // in qml: 1 - own section, 2 - additional section
    if ((section == 0) || (section == 1 && _mainstore.Bit("DIAG_Connections", CONN_MSS))) {
        _section = section;
        return true;
    } else
        return false;
}
//--------------------------------------------------------------------------------
void Processor::kvitTrBanner() {
    int first;
    if (!_tr_banner_queue.isEmpty()) {
        first = _tr_banner_queue.firstKey();
        _tr_states[_tr_banner_queue[first].section][_tr_banner_queue[first].index]->kvit = true;
        _tr_banner_queue.remove(first);
    }
}
//--------------------------------------------------------------------------------
void Processor::playSoundOnShowBanner() {
    QSound::play(_start_path + "/error.wav");
}
//--------------------------------------------------------------------------------
void Processor::Unpack(QString alias) {
    QByteArray data = _serial_ports[alias]->InData.Data();
    _serial_ports[alias]->InData.Swap();
    _mainstore.LoadSpData(_serial_ports[alias]);
    // update record registration
    if (alias == "USTA") {
        if (data.size() >= 87) {
            // post correction
            if (_settings.PressureSensors == 6) {
                _storage[_section]->SetFloat("USTA_Pf_tnvd", _storage[_section]->Float("USTA_Pf_tnvd") * 0.375);
                _storage[_section]->SetFloat("USTA_Pf_ftot", _storage[_section]->Float("USTA_Pf_ftot") * 0.375);
            }
            // save data
            _registrator->UpdateRecord(0, 80, /*data*/_serial_ports[alias]->InData.Data().mid(0, 80));  // аналоговые
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
            _registrator->SetByteRecord(186, _mainstore.Byte("BEL_PKM"));
            _registrator->UpdateRecord(338, 8, data.mid(1, 8)); // дискретные (+ ПКМ)
            _mainstore.SetByte("PROG_Reversor", (_mainstore.Byte("BEL_Diagn") & 3) + 1);
            _slave.UpdatePacket(0, 8, data.mid(1, 8)); // дискретные (+ ПКМ)
        }
    } else if (alias == "MSS") {
        if (data.size() >= 580)
            _slave.GetPacket(data, _serial_ports);
    }
}
//--------------------------------------------------------------------------------
void Processor::Parse(NodeXML *node)
{
    while (node != nullptr) {
        if (node->Name == "lcmconfig") {
            ParseCfg(node->Child);
        }
        node = node->Next;
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseCfg(NodeXML *node)
{
    while (node != nullptr) {
        if (node->Name == "settings") {
            _settings.Number = node->Text.rightJustified(4, '0');

            for (int i = 0; i < node->Attributes.count(); i++) {
                AttributeXML *attr = node->Attributes[i];
                if (attr->Name == "elinj")
                    _settings.ElInjection = (attr->Value.toLower() == "on") ? true : false;
                if (attr->Name == "psensor")
                    _settings.PressureSensors = attr->Value.toInt();
            }
        } else
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
                TrState *newState = new TrState;
                TrState *newStateSlave = new TrState;
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
                _tr_states[0][index] = newState;
                _tr_states[1][index] = newStateSlave;
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
            } else if (node->Name == "mrfile") {
                _mtr_file.setFileName(node->Text);
            } else if (node->Name == "trmessfile") {
                _trmess_file.setFileName(node->Text);
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
                //par1 = 1;
                if (_section == 0) {
                    if ((i.value()->system >= 1 && i.value()->system <= 4) || (i.value()->system >= 21 && i.value()->system <= 24)
                            || (i.value()->system >= 31 && i.value()->system <= 34))  // electric
                        par1 = par9 = 1;
                    if (i.value()->system == 5 || i.value()->system == 6 || i.value()->system == 7 || i.value()->system == 45
                            || i.value()->system == 46 ) // diesel
                        par1 = par8 = 1;
                }
            }
            if (_slave.Storage()->Bit("PROG_TrSoob", i.key())) { // additional section
//                par2 = 1;
                if (_section == 1) {
                    if ((i.value()->system >= 1 && i.value()->system <= 4) || (i.value()->system >= 21 && i.value()->system <= 24) ||
                            (i.value()->system >= 31 && i.value()->system <= 34)) // electric
                        par2 = par9 = 1;
                    if (i.value()->system == 5 || i.value()->system == 6 || i.value()->system == 7 || i.value()->system == 45
                            || i.value()->system == 46 ) // diesel
                        par2 = par8 = 1;
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
//                par1 = 1;
                if (_section == 0) {
                    if (i.value()->system == 5)
                        par1 = par6 = 1;
                    if (i.value()->system == 6)
                        par1 = par7 = 1;
                    if (i.value()->system == 7)
                        par1 = par9 = 1;
                    if (i.value()->system == 45 || i.value()->system == 46)
                        par1 = par8 = 1;
                }
            }
            if (_slave.Storage()->Bit("PROG_TrSoob", i.key())) {
//                par2 = 1;
                if (_section == 1) {
                    if (i.value()->system == 5)
                        par2 = par6 = 1;
                    if (i.value()->system == 6)
                        par2 = par7 = 1;
                    if (i.value()->system == 7)
                        par2 = par9 = 1;
                    if (i.value()->system == 45 || i.value()->system == 46)
                        par2 = par8 = 1;
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
//                par1 = 1;
                if (_section == 0) {
                    if (i.value()->system == 1 || i.value()->system == 21 || i.value()->system == 31)
                        par1 = par6 = 1;
                    if (i.value()->system == 2 || i.value()->system == 22 || i.value()->system == 32)
                        par1 = par7 = 1;
                    if (i.value()->system == 3 || i.value()->system == 23 || i.value()->system == 33)
                        par1 = par8 = 1;
                    if (i.value()->system == 4 || i.value()->system == 24 || i.value()->system == 34)
                        par1 = par9 = 1;
                }
            }
            if (_slave.Storage()->Bit("PROG_TrSoob", i.key())) {
//                par1 = 2;
                if (_section == 1) {
                    if (i.value()->system == 1 || i.value()->system == 21 || i.value()->system == 31)
                        par2 = par6 = 1;
                    if (i.value()->system == 2 || i.value()->system == 22 || i.value()->system == 32)
                        par2 = par7 = 1;
                    if (i.value()->system == 3 || i.value()->system == 23 || i.value()->system == 33)
                        par2 = par8 = 1;
                    if (i.value()->system == 4 || i.value()->system == 24 || i.value()->system == 34)
                        par2 = par9 = 1;
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
QJsonArray Processor::getParamMainWindow() {
    bool iKVmain_own = _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_KV);
    bool iKVmain_add = _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_KV);
    //bool iKVadd = _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_KV);
    int min[10] = { 240, 240, 240, 240, 307, 377, 457, 547, 627, 738};
    int max[10] = { 315, 315, 315, 315, 352, 422, 502, 592, 672, 757};
    int bt = _storage[_section]->Byte("BEL_PKM") & 0x30; //= dab[0,7];
    int dsk_iAPvkl1 = 0; // dsk_iAPvkl1= dsk[0,iAPvkl1]; // не используется
    int dsk_iSA1 = 1;   // dsk_iSA1  = dsk[0,iSA1 ];
    int dsk_iKMv0 = 1;  // dsk_iKMv0 = dsk[0,iKMv0];
    int dsk_iDizZ = 0;  // dsk_iDizZ = dsk[0,iDizZ];
    int pkm = _mainstore.Byte("PROG_PKM");

    int n_diz = _storage[_section]->Int16("USTA_N");
    float pt_min = 0, pt_max = 0, pm_min = 0, pm_max = 0, nd_min = 0, nd_max = 0;
    if (n_diz >= 100) {
        pm_min = 17;
        pm_max = 53;
        if (_settings.ElInjection) {
            pt_min = 40;
            pt_max = 65;
        } else {
            pt_min = 5;
            pt_max = 25;
        }
        nd_min = min[pkm];
        nd_max = max[pkm];
    }
    QStringList tr_banner;
    if (_tr_banner_queue.empty()) {
        tr_banner.append("");
        tr_banner.append("");
    }
    else {
        tr_banner.append(_tr_banner_queue.first().str1);
        tr_banner.append(_tr_banner_queue.first().str2);
    }
    return {
        // frame left
        QJsonArray { _storage[0]->Bit("DIAG_Connections", CONN_BEL), _storage[0]->Bit("DIAG_Connections", CONN_USTA), _storage[0]->Bit("DIAG_Connections", CONN_IT),
                    _storage[0]->Bit("DIAG_Connections", CONN_MSS), _storage[1]->Bit("DIAG_Connections", CONN_USTA)},
        _storage[0]->Float("USTA_Ug_filtr") * _storage[0]->Float("USTA_Ig_filtr") * 0.001,
        _storage[1]->Float("USTA_Ug_filtr") * _storage[1]->Float("USTA_Ig_filtr") * 0.001,
        _storage[0]->Float("USTA_Ubs_filtr"), _storage[1]->Float("USTA_Ubs_filtr"),
        _storage[0]->Float("USTA_Iakb"), _storage[1]->Float("USTA_Iakb"),
        QJsonArray { iKVmain_own && _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_OM2), iKVmain_own && _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_OM1), _storage[0]->Bit("USTA_Outputs", USTA_OUTPUTS_BOKS), // OM1, OM2, боксование
                _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_URV), _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_RZ), _storage[0]->Bit("USTA_Inputs", USTA_INPUTS_OBTM) } , // ур. воды, реле земли,обрыв ТМ
        QJsonArray { iKVmain_add && _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_OM2), iKVmain_add && _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_OM1), _storage[1]->Bit("USTA_Outputs", USTA_OUTPUTS_BOKS), // OM1, OM2, боксование
                _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_URV), _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_RZ), _storage[1]->Bit("USTA_Inputs", USTA_INPUTS_OBTM) } , // ур. воды, реле земли,обрыв ТМ
        // frame top
        _storage[_section]->Bit("DIAG_Connections", CONN_USTA),
        QJsonArray { pkm,  _mainstore.Byte("PROG_Reversor"), _mainstore.Byte("PROG_Regime") },
        QJsonArray { _diagnostics->Time().toString("HH:mm:ss"), _diagnostics->Date().toString("dd/MM/yy"), _settings.Number },
        QJsonArray { "", // RejPrT
            (bt == 0x00) ? "" : ((bt == 0x10) ? "Прожиг коллектора": "Завершение прожига"), // RejPro
            (dsk_iAPvkl1 == 00) ? "" : ((dsk_iSA1 == 01) ? "Режим АвтоПрогрева" : ((dsk_iKMv0 == 00) ? "АП: Установи ПКМ в 0" : ((dsk_iDizZ == 00) ? "АП: Запусти дизель" : ""))), },
        RejPrT(), // getRejPrT// RejAP
        QJsonArray { _saver->MediaInserted(), _saver->Recording(),  _saver->PercentRecorded() }, // load usb indicator
        QJsonArray { _storage[_section]->Float("USTA_Pf_tnvd") * 0.1, pt_min * 0.01, pt_max * 0.01,
                    _storage[_section]->Float("USTA_Po_diz") * 0.1, pm_min * 0.01, pm_max * 0.01,  n_diz, nd_min, nd_max },
        QJsonArray { tr_banner[0], tr_banner[1], /*_tr_banner_queue.first().section, _tr_banner_queue.first().index*/ }
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
// Tr soob string list
QStringList Processor::getKdrTrL() {
    return _tr_strings; //list;
}
//------------------------------------------------------------------------------
//
QStringList Processor::getKdrPrivet() {
    QStringList list;
    list.append(QString::number(_settings.PressureSensors));
    list.append((_settings.ElInjection) ? "El vp" : "no Elvp");
    return list;
}
