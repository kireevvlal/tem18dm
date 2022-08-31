#ifndef PROCESSOR_H
#define PROCESSOR_H
#include <QObject>
#include <QJsonArray>
#include  "zapuso.h"
#include "threadserialport.h"
#include "treexml.h"
#include "datastore.h"
#include "registrator.h"

#define nobit0 0xfe
#define nobit1 0xfd
#define nobit2 0xfb
#define nobit3 0xf7
#define nobit4 0xef
#define nobit5 0xdf
#define nobit6 0xbf
#define nobit7 0x7f

class Processor : public QObject
{
    Q_OBJECT
private:
//    QByteArray _bytes_data;
//    QMap<QString, qint16> _int_data;
//    QMap<QString, float> _float_data;
    QThread *_reg_thread;
    QTimer *_reg_timer;
    Registrator *_registrator;
    QString _start_path;
    QStringList _files;
    TreeXML _tree;
    QJsonArray RejPrT();
    void Parse(NodeXML*);
    void ParseFiles(NodeXML*);
    void ParseObjects(NodeXML*);
    void ParseSerialPorts(NodeXML*);
    void ParseDiagnostic(NodeXML*);
public:
    QMap<QString, ThreadSerialPort*> SerialPorts;
    DataStore Storage;
    explicit Processor(QObject *parent = nullptr);
    ~ Processor() {}
    bool Load(QString, QString);
    void Run();
signals:
    void AddRecordSignal(QByteArray);
private slots:
    void RegTimerStep();
public slots:
    void Unpack(QString);
    void LostConnection(QString);
    void RestoreConnection(QString);
    // New:
    QJsonArray getTrevogaTotal();
    QJsonArray getTrevogaDiesel();
    QJsonArray getTrevogaElectr();
    QJsonArray getParamKdrVzb();
    QJsonArray getParamKdrTpl();
    QJsonArray getParamKdrSvz();
    QJsonArray getParamKdrReo();
    QJsonArray getParamKdrOhl();
    QJsonArray getParamKdrMot();
    QJsonArray getParamKdrMasl();
    QJsonArray getParamKdrDizl();
    QJsonArray getParamKdrBos();
    QJsonArray getParamKdrAvProgrev();
    QJsonArray getParamMain();
    QStringList getStructAnlg(int);
    QStringList getStructDiskr(int);
    QJsonArray getDiskretArray(int);
    QJsonArray getAnalogArray(int);

    // Old:
//    int getReversor();     // реверс
//    int getPKM();          // позиция контроллера машиниста
//    int getRegim();        // режим
//    QString getRejPro();   // прожиг
//    QString getRejAP();    // автопрогрев

//    QString getRejPrT(QString param);

//    QString getParam();
//    QString getParamDiap(int diapazon);
//    QString getParamExt(int ext);
//    QString tm();
//    QString dt();

    // менюшки
//    int getTrevogaTotal(int indx);//возвращает состояние лампочки-ошибки для главного(верхнего меню)
//    int getTrevogaDizel(int indx);//возвращает состояние лампочки-ошибки для Дизельного меню
//    int getTrevogaElektr(int indx);//возвращает состояние лампочки-ошибки для Дизельного меню



    // QString getStructAnlg(int indx, QString &s1, QString &s2, QString &s3, QString &s4, QString &s5);
    // аналоговое УСО
//    QString getStructAnlg_r(int indx);
//    QString getStructAnlg_n(int indx);
//    QString getStructAnlg_o(int indx);
//    QString getStructAnlg_i(int indx);
//    QString getStructAnlg_a(int indx);
//    int mysz();

    // дискретное УСО
//    QString getStructDiskr_r(int indx);
//    QString getStructDiskr_n(int indx);
//    QString getStructDiskr_o(int indx);
//    QString getStructDiskr_i(int indx);

};

#endif // PROCESSOR_H
