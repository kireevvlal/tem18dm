#include "processor.h"


Processor::Processor(QObject *parent) : QObject(parent)
{
    //_tr_total.resize(10);
}
//--------------------------------------------------------------------------------
// Load configuration from files and create objects
bool Processor:: Load(QString startPath)
{
    int i;
    if (_tree.ReadFile(startPath)) { // read start configuration file
        Parse(_tree.Root);
        for (i = 0; i < _files.length(); i++) {
            _tree.Clear();
            if (_tree.ReadFile(_files[i]))
                ParseObjects(_tree.Root);
            else
                return false;
        }
    } else
        return false;
    return true;
}
//--------------------------------------------------------------------------------
void Processor::Run()
{
    // start serial ports
    for (int i = 0; i < SerialPorts.count(); i++) {
        connect(SerialPorts[i], SIGNAL(DecodeSignal(ThreadSerialPort*)), this, SLOT(Unpack(ThreadSerialPort*)));
        SerialPorts[i]->Start();
    }
}
//--------------------------------------------------------------------------------
void Processor::Unpack(ThreadSerialPort *port)
{
    qDebug() << "Unpack " + port->Alias;
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
        node = node->Next;
    }
}
//--------------------------------------------------------------------------------
void Processor::ParseSerialPorts(NodeXML *node)
{
    while (node != nullptr) {
        if (node->Name == "spstream") {   // serial port stream
            ThreadSerialPort *newPort = new ThreadSerialPort;
            SerialPorts.append(newPort);
            newPort->Parse(node);
        }
        node = node->Next;
    }
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
QJsonArray Processor::getParamKdrVzb()
{
    return { rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrTpl()
{
    return { rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrSvz()
{
    return { rand() % 1000 };
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
QJsonArray Processor::getParamKdrOhl()
{
    return { rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrMot()
{
    return { rand() % 1000 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrMasl()
{
    return { rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000 };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrDizl()
{
    return {
        rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000,
        rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000
    };
}
//------------------------------------------------------------------------------
QJsonArray Processor::getParamKdrBos()
{
    return {
        rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000, rand() % 1000
    };
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
QJsonArray Processor::getParamMain()
{
    int rg = rand() % 4; // Regim заглушка
    int bt = rand() % 48; //= dab[0,7];
    int dsk_iAPvkl1 = rand() % 3; // dsk_iAPvkl1= dsk[0,iAPvkl1];
    int dsk_iSA1 = 1;   // dsk_iSA1  = dsk[0,iSA1 ];
    int dsk_iKMv0 = 1;  // dsk_iKMv0 = dsk[0,iKMv0];
    int dsk_iDizZ = 0;  // dsk_iDizZ = dsk[0,iDizZ];
    QJsonArray rej_prt = RejPrT();

    return {
        QTime::currentTime().toString("HH:mm:ss"), QDate::currentDate().toString("dd/MM/yy"), // date and time
        rand() % 4,  // Reversor заглушка пока возвращем число в диапазоне от 0 до 3
        rand() % 10, // PKM заглушка
        (!(rg >= 1 && rg <= 4)) ? 0 : rg, // Regim заглушка
        ((bt & 0x30) == 0x00) ? "" : (((bt & 0x30) == 0x10) ? "Прожиг коллектора": "Завершение прожига"), // RejPro
        (dsk_iAPvkl1 == 00) ? "" : ((dsk_iSA1 == 01) ? "Режим АвтоПрогрева" : ((dsk_iKMv0 == 00) ? "АП: Установи ПКМ в 0" : ((dsk_iDizZ == 00) ? "АП: Запусти дизель" : ""))), // RejAP
        rej_prt[0], rej_prt[1], rej_prt[2], // getRejPrT
        float(rand() % 100), float(rand() % 1500), float(rand() % 100), float(rand() % 100), float(rand() % 60), float(rand() % 60) // ??????????????
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
