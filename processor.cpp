#include "processor.h"
#if QT_VERSION < QT_VERSION_CHECK(5, 12, 0)
#include <QDebug>
#include <QTime>
#include <QDate>
#endif
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
Processor::Processor(QObject *parent) : QObject(parent)
{
    _reg_timer = new QTimer();
    _reg_thread = new QThread();
    _registrator = new Registrator();
    _diag_timer = new QTimer();
    _diag_interval = 200;
    _msec = QDateTime::currentDateTime().toMSecsSinceEpoch();
    _is_active = false;
    _fswatcher = new QFileSystemWatcher;
#ifdef Q_OS_WIN
    _fswatcher->addPath("D:/000");
#elif  Q_OS_UNIX
    _fswatcher->addPath("/dev");
#endif
    _saver =  new Saver();
    _saver_thread = new QThread();
    _control = new Control(&Storage);
    _control->PortsState = 0;
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
    for (QMap<QString, ThreadSerialPort*>::iterator i = SerialPorts.begin(); i != SerialPorts.end(); i++)
        Storage.FillMaps(i.value());
    // read motoresurs
    if (_mtr_file.open(QIODevice::ReadOnly)) {
        _mtr_file.read(data, 12);
        for (i = 0; i < 4; i++)
            par.Array[i] = data[i];
        Storage.UInt32("DIAG_Motoresurs", par.Value);
        for (i = 0; i < 4; i++)
            par.Array[i] = data[i + 4];
        Storage.UInt32("DIAG_Adiz", par.Value);
        _Adiz = (float)par.Value / 10;
        for (i = 0; i < 4; i++)
            par.Array[i] = data[i + 8];
        Storage.UInt32("DIAG_Tt", par.Value);
        _mtr_file.close();
    }
    return true;
}
//--------------------------------------------------------------------------------
void Processor::Run()
{
    // start serial ports
    for (QMap<QString, ThreadSerialPort*>::iterator i = SerialPorts.begin(); i != SerialPorts.end(); i++) {
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
void Processor::querySaveToUSB(QString dir) {
#ifdef Q_OS_WIN
    SaveFilesSignal(); // (dir)
#elif Q_OS_UNIX
    // find flash usb
#endif
}
//--------------------------------------------------------------------------------
void Processor::Stop() {
    char data[12];
    UnionUInt32 par;
    int i;
    if (_mtr_file.open(QIODevice::WriteOnly)) {
        par.Value = Storage.UInt32("DIAG_Motoresurs");
        for (i = 0; i < 4; i++)
            data[i] = par.Array[i];
        par.Value = Storage.UInt32("DIAG_Adiz");
        for (i = 0; i < 4; i++)
            data[i + 4] = par.Array[i];
        par.Value = Storage.UInt32("DIAG_Tt");
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
    if (SerialPorts.contains("BEL"))
        Storage.Int16("DIAG_CQ_BEL", SerialPorts["BEL"]->Quality());
    if (SerialPorts.contains("USTA"))
        Storage.Int16("DIAG_CQ_USTA", SerialPorts["USTA"]->Quality());
    if (SerialPorts.contains("IT"))
        Storage.Int16("DIAG_CQ_IT", SerialPorts["IT"]->Quality());
    if (SerialPorts.contains("MSS"))
        Storage.Int16("DIAG_CQ_MSS", SerialPorts["MSS"]->Quality());
    //
    QDateTime dt = QDateTime::currentDateTime();
    QDate date = dt.date();
    QTime time = dt.time();
    // word diagnostic
    _registrator->SetWordRecord(176, Storage.Int16("DIAG_CQ_BEL"));
    _registrator->SetWordRecord(178, Storage.Int16("DIAG_CQ_USTA"));
    _registrator->SetWordRecord(180, Storage.Int16("DIAG_CQ_IT"));
    _registrator->SetWordRecord(182, Storage.Int16("DIAG_CQ_MSS"));
    _registrator->SetWordRecord(184, Storage.Int16("DIAG_MESS_NUM"));
    _registrator->SetWordRecord(186, Storage.Int16("DIAG_PKM_BEL"));
    _registrator->SetWordRecord(188, Storage.Int16("DIAG_Rplus"));
    _registrator->SetWordRecord(190, Storage.Int16("DIAG_Rminus"));
    _registrator->SetWordRecord(198, Storage.Int16("DIAG_Pg"));
    // double word diagnostic
    _registrator->SetDoubleWordRecord(206, Storage.UInt32("DIAG_Motoresurs"));
    _registrator->SetDoubleWordRecord(210, Storage.UInt32("DIAG_Apol"));
    _registrator->SetDoubleWordRecord(214, Storage.UInt32("DIAG_Tt"));
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
    _registrator->SetByteRecord(346, Storage.Byte("DIAG_Connections"));
    _registrator->SetByteRecord(347, Storage.Byte("DIAG_Discret_2"));
    _registrator->SetByteRecord(348, Storage.Byte("DIAG_Discret_3"));
    _registrator->SetByteRecord(349, Storage.Byte("DIAG_Discret_4"));
    _registrator->SetByteRecord(350, Storage.Byte("DIAG_Discret_5"));
    _registrator->SetByteRecord(351, Storage.Byte("DIAG_Discret_6"));
    AddRecordSignal();
}
//--------------------------------------------------------------------------------
void Processor::DiagTimerStep() {
    qint64 currtime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    qint64 diff;
    int n = Storage.Int16("USTA_N");
    if (n >= 99) {
        diff = currtime - _msec;
        if (diff >= 1000) {
            _msec = currtime;
            Storage.UInt32("DIAG_Motoresurs", Storage.UInt32("DIAG_Motoresurs") + 1); // increment motoresurs
            if (Storage.Byte("USTA_Inputs_2") & 64) { // КВ контроль возбуждения
                Storage.UInt32("DIAG_Tt", Storage.UInt32("DIAG_Tt") + 1); // increment время работы в тяге
                _Adiz += (float)Storage.Int16("DIAG_Pg") / 3600;
                Storage.UInt32("DIAG_Adiz", _Adiz * 10); // полезная работа
            }
        }
    }
    for (QMap<QString, ThreadSerialPort*>::iterator i = SerialPorts.begin(); i != SerialPorts.end(); i++)
        if (i.key() == "BEL") {
            if (i.value()->isOpen())
                _control->PortsState |= 1;
            else _control->PortsState &= nobit0;
        } else
            if (i.key() == "USTA") {
                if (i.value()->isOpen())
                    _control->PortsState |= 2;
                else _control->PortsState &= nobit1;
            } else
                if (i.key() == "IT") {
                    if (i.value()->isOpen())
                        _control->PortsState |= 4;
                    else _control->PortsState &= nobit2;
                } else
                    if (i.key() == "MSS") {
                        if (i.value()->isOpen())
                            _control->PortsState |= 8;
                        else _control->PortsState &= nobit3;
                    }
//    _control->Execute();
}
//--------------------------------------------------------------------------------
void Processor::changeKdr(int kdr) {
    _control->KdrNum = kdr;
}
//--------------------------------------------------------------------------------
void Processor::LostConnection(QString alias) {
    QByteArray arr;
    arr.fill('\0', 1024);
    if (alias == "BEL") {
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") & nobit0);
        _registrator->UpdateRecord(338, 8, arr.mid(0, 8)); // дискретные (+ ПКМ)
    }
    else if (alias == "USTA") {
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") & nobit1);
        _registrator->UpdateRecord(0, 80, arr.mid(0, 80));  // аналоговые
        _registrator->UpdateRecord(332, 6, arr.mid(0, 6)); // дискретные
    }
    if (alias == "IT") {
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") & nobit2);
        _registrator->UpdateRecord(80, 96, arr.mid(0, 96));
    }
    else if (alias == "MSS")
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") & nobit3);
}
//--------------------------------------------------------------------------------
void Processor::RestoreConnection(QString alias) {
    if (alias == "BEL")
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") | 1);
    else if (alias == "USTA")
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") | 2);
    if (alias == "IT")
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") | 4);
    else if (alias == "MSS")
        Storage.Byte("DIAG_Connections", Storage.Byte("DIAG_Connections") | 8);
}
//--------------------------------------------------------------------------------
void Processor::Unpack(QString alias) {
    QByteArray data = SerialPorts[alias]->InData.Data();
    SerialPorts[alias]->InData.Swap();
    Storage.LoadSpData(SerialPorts[alias]);
    // update record registration
    if (alias == "USTA") {
        // save data
        _registrator->UpdateRecord(0, 80, data.mid(0, 80));  // аналоговые
        _registrator->UpdateRecord(332, 6, data.mid(80, 6)); // дискретные
        // diagnostic
        Storage.Int16("DIAG_Pg", Storage.Float("USTA_Ug_filtr") * Storage.Float("USTA_Ig_filtr") * 0.001); // считаем мощность генератора
    }
    else if (alias == "IT") {
        int index = data[SerialPorts[alias]->InData.Index];
        if (index < 3) {// принимаются долько три пакета из четырех
            _registrator->UpdateRecord(80 + index * 32, 32, data.mid(5, 32));
            _control->CalculateTC();
        }
    }
    else if (alias == "BEL") {
        //Storage.SetByteRecord(186, Storage.Byte("BEL_PKM")); // ???????????????????????????????????????????????
        _registrator->UpdateRecord(338, 8, data.mid(1, 8)); // дискретные (+ ПКМ)
    }
    qDebug() << "Unpack " + alias;
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
        node = node->Next;
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
                Storage.Add(newPar->Variable, newPar->Type);
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
            SerialPorts[newPort->Alias] = newPort; //SerialPorts.append(newPort);
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
QJsonArray Processor::getTrevogaTotal()
{
//    QJsonArray arr;
//    for (int i = 0; i < 9; i++)
//        arr.append(rand() % 2);
//    return arr;
    return { rand() % 2, rand() % 2, rand() % 2, rand() % 2 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getTrevogaDiesel()
{
    return { rand() % 2, rand() % 2, rand() % 2, rand() % 2, rand() % 2, rand() % 2 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getTrevogaElectr()
{
    return { rand() % 2, rand() % 2, rand() % 2, rand() % 2, rand() % 2, rand() % 2 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrBos()
{
    _control->KdrBos();
    return {
       Storage.Float("USTA_Ubs_filtr"), rand() % 1000, rand() % 1000,
       Storage.Float("USTA_Iakb"), Storage.Int16("USTA_Ucu"), Storage.Float("USTA_Ivzb_vst"),
       Storage.Float("USTA_Ugol_uvvg"), Storage.Float("USTA_Ugol_uvvg") / 60, // ?? 60 - ?
       _control->_kdr_bos_flags
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrVzb()
{
    _control->KdrVzb();
    return { Storage.Float("USTA_Ig_filtr"), Storage.Float("USTA_Ug_filtr"), Storage.Float("USTA_Ivzb_gen"), Storage.Float("USTA_Ugol_uvvg"), _control->_kdr_vzb_flags };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrTed()
{
    _control->KdrTed();
    return { Storage.Float("USTA_Ig_filtr"), Storage.Float("USTA_Ited1_filtr"), Storage.Float("USTA_Ited2_filtr"), _control->_kdr_ted_flags };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrSvz()
{
    return { Storage.Float("USTA_Ubs_filtr"),  Storage.Byte("DIAG_Connections"), _control->PortsState,
                Storage.Byte("DIAG_CQ_MSS"), 0, 0, Storage.Byte("DIAG_CQ_IT"), Storage.Byte("DIAG_CQ_USTA"), Storage.Byte("DIAG_CQ_BEL") };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrReo()
{
    return {
        rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000,
        rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000,
        rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrMasl()
{
    _control->KdrMasl();
    return { Storage.Float("USTA_Po_diz") / 10, Storage.Float("IT_TSM3"), Storage.Float("USTA_Po_mn2") / 10,
                Storage.Float("IT_TSM4"), Storage.Int16("USTA_N"), _control->_kdr_masl_flags };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrTpl() {
    _control->KdrTpl();
    float PiF = Storage.Float("USTA_Pf_ftot") / 10, PiD = Storage.Float("USTA_Pf_tnvd") / 10;
    return { 0, 0, PiF, PiF - PiD, PiD, Storage.Float("IT_TSM6"), Storage.Int16("USTA_N"), _control->_kdr_tpl_flags };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrOhl()
{
    _control->KdrOhl();
    return { Storage.Float("IT_TSM9"), Storage.Float("IT_TSM8"), Storage.Float("IT_TSM10"), Storage.Float("IT_TSM6"), Storage.Int16("USTA_N"), _control->_kdr_ohl_flags };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrMot()
{
    return { (qint32)Storage.UInt32("DIAG_Motoresurs"), (qint32)Storage.UInt32("DIAG_Tt"),(qint32)Storage.UInt32("DIAG_Adiz") / 10, Storage.Int16("USTA_N") };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrDizl()
{
   return { Storage.Int16("USTA_N"), Storage.Float("IT_TSM1"), // N, темп хол спая
            Storage.Int16("IT_THA19"), Storage.Int16("IT_THA21"), Storage.Int16("IT_THA23"), Storage.Int16("IT_THA12"), Storage.Int16("IT_THA10"), Storage.Int16("IT_THA8"), // ТЦ
            Storage.Int16("IT_THA11"), Storage.Int16("IT_THA2"), // ТК
            _control->MinTC, _control->MaxTC, _control->AvgTC,
            _control->DeltaTC[0], _control->DeltaTC[1], _control->DeltaTC[2], _control->DeltaTC[3], _control->DeltaTC[4], _control->DeltaTC[5] };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrAvProgrev()
{
    return {
        rand() % 1000, rand() % 1000,
        float(rand() % 1000), float(rand() % 1000), float(rand() % 1000), float(rand() % 1000), float(rand() % 1000), // ???
        rand() % 1000
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrSmlMain()
{
    int Ig, ogrUgMax = 0, ogrIgMax = 0;
    if ((Storage.Byte("USTA_Inputs_3") & 16) && (Storage.Byte("USTA_Inputs_3") & 32)) // Признак «Выход БЭЛ ЭДТ» и Признак «РЭТ по сх. КВТ 1,2»
        Ig = Storage.Float("USTA_Itorm_zad");
    else
        Ig = Storage.Float("USTA_Ig_filtr");

    if (Storage.Byte("USTA_Inputs_2") & 32) // Признак КВ
        ogrUgMax = 800;
    if (Storage.Byte("USTA_Inputs_2") & 32) // Признак КВ
        ogrIgMax = 2000;
    return {Ig, Storage.Float("USTA_Ug_filtr"), Storage.Float("IT_TSM6"), Storage.Float("IT_TSM3"), ogrIgMax, ogrUgMax };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrTop()
{
    return { QTime::currentTime().toString("HH:mm:ss"), QDate::currentDate().toString("dd/MM/yy") };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamMain()
{
    int rg = rand() % 4; // Regim заглушка
    int bt = rand() % 48; //= dab[0,7];
    int dsk_iAPvkl1 = rand() % 3; // dsk_iAPvkl1= dsk[0,iAPvkl1];
    int dsk_iSA1 = 1;   // dsk_iSA1  = dsk[0,iSA1 ];
    int dsk_iKMv0 = 1;  // dsk_iKMv0 = dsk[0,iKMv0];
    int dsk_iDizZ = 0;  // dsk_iDizZ = dsk[0,iDizZ];
    //QJsonArray rej_prt = RejPrT();

    return {
        QJsonArray { rand() % 4,  // Reversor заглушка пока возвращем число в диапазоне от 0 до 3
        rand() % 10, // PKM заглушка
        (!(rg >= 1 && rg <= 4)) ? 0 : rg }, // Regim заглушка
        QJsonArray { ((bt & 0x30) == 0x00) ? "" : (((bt & 0x30) == 0x10) ? "Прожиг коллектора": "Завершение прожига"), // RejPro
        (dsk_iAPvkl1 == 00) ? "" : ((dsk_iSA1 == 01) ? "Режим АвтоПрогрева" : ((dsk_iKMv0 == 00) ? "АП: Установи ПКМ в 0" : ((dsk_iDizZ == 00) ? "АП: Запусти дизель" : ""))) }, // RejAP
        RejPrT(), // getRejPrT
        QJsonArray { float(rand() % 100), float(rand() % 1500), float(rand() % 100), float(rand() % 100), float(rand() % 60), float(rand() % 60) } // ??????????????
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

    if (d==0) {
        // TxC.Visible:=false; TxM.Visible:=false; TxS.Visible:=false; TxT.Visible:=false;
        // RejPrT.Visible:=false;
        capt= "00:00:00";
        vzbl_msg = "0"; // сообщение убрали
        vzbl_tm = "0";  // время убрали
    }
    else
    {
        t = (d%60); // inttostr( d mod 60);  //секунды    х.х.
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
    qint8 byte1, byte2, byte3;
    switch (offset) {
    case (0) : // БЭЛ Дискретные выходы
        byte1 = Storage.Byte("BEL_Keys_1");
        byte2 = Storage.Byte("BEL_Keys_2");
        byte3 = Storage.Byte("BEL_Keys_3");
        break;
    case (24) : // БЭЛ Дискретные входы
        byte1 = Storage.Byte("BEL_Inputs_1");
        byte2 = Storage.Byte("BEL_Inputs_2");
        byte3 = Storage.Byte("BEL_Inputs_3");
        break;
    case (48) : // УСТА Дискретные выходы
        byte1 = Storage.Byte("USTA_Outputs_1");
        byte2 = Storage.Byte("USTA_Outputs_2");
        byte3 = Storage.Byte("USTA_Outputs_3");
        break;
    case (72) : // УСТА Дискретные входы
        byte1 = Storage.Byte("USTA_Inputs_1");
        byte2 = Storage.Byte("USTA_Inputs_2");
        byte3 = Storage.Byte("USTA_Inputs_3");
        break;
    }
    result = { byte1 & 1, (byte1 & 2) >> 1, (byte1 & 4) >> 2, (byte1 & 8) >> 3, (byte1 & 16) >> 4, (byte1 & 32) >> 5, (byte1 & 64) >> 6, (byte1 & 128) >> 7,
             byte2 & 1, (byte2 & 2) >> 1, (byte2 & 4) >> 2, (byte2 & 8) >> 3, (byte2 & 16) >> 4, (byte2 & 32) >> 5, (byte2 & 64) >> 6, (byte2 & 128) >> 7,
             byte3 & 1, (byte3 & 2) >> 1, (byte3 & 4) >> 2, (byte3 & 8) >> 3, (byte3 & 16) >> 4, (byte3 & 32) >> 5, (byte3 & 64) >> 6, (byte3 & 128) >> 7 };
    return result;
}
//------------------------------------------------------------------------------
// Discret values for tables
QJsonArray Processor::getAnalogArray(int offset) {
    QJsonArray result;
    qint8 byte;
    switch (offset) {
    case (0) : // USTA
        result = { 2, Storage.Float("USTA_Ug"), Storage.Float("USTA_Ig"), Storage.Float("USTA_Ubuks2"), Storage.Float("USTA_Ubuks1"), Storage.Int16("USTA_Ucu"),
                 Storage.Float("USTA_Ited1"), Storage.Float("USTA_Ited2"), Storage.Float("USTA_Ubs"), Storage.Float("USTA_Ivzb_vst"), Storage.Float("USTA_Pf_tnvd") };
        break;
    case (10) : // USTA
        result = { 2, Storage.Float("USTA_Pf_ftot"), Storage.Float("USTA_Iakb"), Storage.Float("USTA_Po_diz"), Storage.Float("USTA_Po_mn2"), Storage.Float("USTA_Ivzb_gen"),
                 Storage.Int16("USTA_PKM"), Storage.Int16("USTA_N"), Storage.Int16("USTA_F"), Storage.Float("USTA_Ubs_filtr"), Storage.Float("USTA_Ugol_vsv") };
        break;
    case (20) : // USTA
        result = { 2, Storage.Float("USTA_Ug_zad"), Storage.Float("USTA_Ug_filtr"), Storage.Float("USTA_Ugol_uvvg"), Storage.Float("USTA_Ig_filtr"), Storage.Float("USTA_Ited1_filtr"),
                   Storage.Float("USTA_Ited2_filtr"), Storage.Float("USTA_Pg_zad"), Storage.Float("USTA_Pg_rasch"), Storage.Float("USTA_Pg"), Storage.Int16("USTA_Regim_rn") };
        break;
    case (30) : // USTA
        result = { 2, Storage.Float("USTA_Itorm_zad"), Storage.Float("USTA_Ivozb_zad"), Storage.Float("USTA_Ubuks1_filtr"), Storage.Float("USTA_Ubuks2_filtr"), Storage.Int16("USTA_Flag_buks"),
                   Storage.Int16("USTA_Rezerv1"), Storage.Int16("USTA_Rezerv2"), Storage.Int16("USTA_Rezerv3"), Storage.Int16("USTA_Rezerv4"), Storage.Int16("USTA_Rezerv5") };
        break;
    case (40) : // BEL
         byte = Storage.Byte("BEL_Diagn");
        result = { 0, byte & 1, (byte & 2) >> 1, (byte & 4) >> 2, (byte & 8) >> 3, (byte & 16) >> 4, (byte & 32) >> 5, (byte & 64) >> 6, (byte & 128) >> 7,
                   Storage.Byte("BEL_PKM"), 0 };
        break;
    case (50) : // TI TSM
        result = { 2, Storage.Float("IT_TSM1"), Storage.Float("IT_TSM2"), Storage.Float("IT_TSM3"), Storage.Float("IT_TSM4"), Storage.Float("IT_TSM5"), Storage.Float("IT_TSM6"),
                 Storage.Float("IT_TSM7"), Storage.Float("IT_TSM8"), Storage.Float("IT_TSM9"), Storage.Float("IT_TSM10") };
        break;
    case (60) : // TI TSM
        result = { 2, Storage.Float("IT_TSM11"), Storage.Float("IT_TSM12"), Storage.Float("IT_TSM13"), Storage.Float("IT_TSM14"), Storage.Float("IT_TSM15"), Storage.Float("IT_TSM16"),
                 Storage.Float("IT_TSM17"), Storage.Float("IT_TSM18"), Storage.Float("IT_TSM19"), Storage.Float("IT_TSM20") };
        break;
    case (70) : // TI TSM
        result = { 2, Storage.Float("IT_TSM21"), Storage.Float("IT_TSM22"), Storage.Float("IT_TSM23"), Storage.Float("IT_TSM24"), 0, 0, 0, 0, 0, 0 };
        break;
    case (80) : // TI THA
        result = { 0, Storage.Int16("IT_THA1"), Storage.Int16("IT_THA2"), Storage.Int16("IT_THA3"), Storage.Int16("IT_THA4"), Storage.Int16("IT_THA5"), Storage.Int16("IT_THA6"),
                 Storage.Int16("IT_THA7"), Storage.Int16("IT_THA8"), Storage.Int16("IT_THA9"), Storage.Int16("IT_THA10") };
        break;
    case (90) : // TI THA
        result = { 0, Storage.Int16("IT_THA11"), Storage.Int16("IT_THA12"), Storage.Int16("IT_THA13"), Storage.Int16("IT_THA14"), Storage.Int16("IT_THA15"), Storage.Int16("IT_THA16"),
                 Storage.Int16("IT_THA17"), Storage.Int16("IT_THA18"), Storage.Int16("IT_THA19"), Storage.Int16("IT_THA10") };
        break;
    case (100) : // TI THA
        result = { 0, Storage.Int16("IT_THA21"), Storage.Int16("IT_THA22"), Storage.Int16("IT_THA23"), Storage.Int16("IT_THA24"), 0, 0, 0, 0, 0, 0 };
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

QString Processor::getParamDiap(int diapazon)
{
    float d = rand() % diapazon ;
    QString v = QString::number(d);
    return v;
}

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
