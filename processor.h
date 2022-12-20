#ifndef PROCESSOR_H
#define PROCESSOR_H
#include <QObject>
#include <QJsonArray>
#include <QFileSystemWatcher>
#include "zapuso.h"
#include "threadserialport.h"
#include "treexml.h"
#include "datastore.h"
#include "registrator.h"
#include "saver.h"
#include "control.h"
#include "diagnostics.h"
#include "slave.h"

//#define TR_SOOB_SIZE 64
// структура тревожного сообщения
struct TrMess {
    int delay; // z
    int output; // o
    int system; // i
    int repair; // v
    QString text; // s
    TrMess() { delay = output = system = repair = 0; text = ""; }
};

class Processor : public QObject
{
    Q_OBJECT
private:
    int _section; // 0 - тепловоз, 1 - дополнительная секеция
    QMap<int, TrMess*> _tr_messages;
    float _pt_max; // макимальное значение давления топлива
    DataStore* _storage[2];
    QMap<QString, ThreadSerialPort*> _serial_ports;
    DataStore _mainstore;
    SlaveLcm _slave; // additional section
    bool _is_active;
    QFile _mtr_file; // имя и путь файла моторесурса
    QThread *_reg_thread;
    QTimer *_reg_timer;
    //QThread *_diag_thread;
    QTimer *_diag_timer;
    int _diag_interval;
    Registrator *_registrator;
    Saver *_saver;
    QThread *_saver_thread;
    QString _start_path;
    QStringList _files;
    TreeXML _tree;
    Control* _control;
    Diagnostics* _diagnostics;
    QFileSystemWatcher *_fswatcher;
    QJsonArray RejPrT();
    void Parse(NodeXML*);
    void ParseFiles(NodeXML*);
    void ParseObjects(NodeXML*);
    void ParseSerialPorts(NodeXML*);
    void ParseDiagnostic(NodeXML*);
    void ParseRegistration(NodeXML*);
    void ParseTrMess(NodeXML*);
    void SetAddSectionData();
#ifdef Q_OS_UNIX
    void GPIO();
#endif
public:
    explicit Processor(QObject *parent = nullptr);
    ~Processor(); // { Stop(); }
    bool Load(QString, QString);
    void Run();
    void Stop();
signals:
    void AddRecordSignal();
    void SaveFilesSignal();
private slots:
    void RegTimerStep();
    void DiagTimerStep();
public slots:
    void Unpack(QString);
    void LostConnection(QString);
    void RestoreConnection(QString);
    void querySaveToUSB(QString);
    void changeKdr(int);
    // New:
    QJsonArray getParamKdrFoot();
    QJsonArray getParamKdrFtDzl();
    QJsonArray getParamKdrFtElektr();
    QJsonArray getParamKdrBos();
    QJsonArray getParamKdrVzb();
    QJsonArray getParamKdrTed();
    QJsonArray getParamKdrTpl();
    QJsonArray getParamKdrSvz();
    QJsonArray getParamKdrReo();
    QJsonArray getParamKdrOhl();
    QJsonArray getParamKdrMot();
    QJsonArray getParamKdrMasl();
    QJsonArray getParamKdrDizl();
    QJsonArray getParamKdrAvProgrev();
    QJsonArray getParamKdrSmlMain();
    QJsonArray getParamFrameTop();
    QJsonArray getParamFrameLeft();
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
