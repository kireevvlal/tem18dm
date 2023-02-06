#ifndef PROCESSOR_H
#define PROCESSOR_H
#include <QObject>
#include <QJsonArray>
#include <QFileSystemWatcher>
#include <QQueue>
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
// структура для регистрации тр. сооб.
struct TrRec {
    quint8 hour;
    quint8 minute;
    quint8 second;
    quint8 index;
    TrRec(quint8 h, quint8 m, quint8 s, quint8 i) { hour = h; minute = m; second = s; index = i;}
};
// структура отслеживания состояния обработки тревожного сообщения
struct TrState {
    QBitArray status; // state bits: 0 - wait registration, 1 - wait addition to list, 2 - ready for banner out
    int delay; //
    bool kvit;
    TrState() { status.fill(false, 3); delay = 0; kvit = false; }
};
// структура для вывода и квитирования тревожных сообщений на баннере
struct TrBanner {
    QString str1; // система
    QString str2; // тревожное сообщение
    int section; // номер секции
    int index;   // индекс тревожного сообщения
    TrBanner() { str1 = str2 = ""; section = index = 0; }
    TrBanner(QString s1, QString s2, int s, int i) { str1 = s1; str2 = s2; section = s; index = i; };
};

class Processor : public QObject
{
    Q_OBJECT
private:
    LcmSettings _settings;
    int _virtual_section; // переключение номера секции (0, 1) в циклах диагностики
    QMap<int, TrBanner> _tr_banner_queue; // очередь на вывод в баннер
    QMap<int, TrState*> _tr_states[2]; // состояния обработки тревог (для мастрера и слейва (0 - своя секция, 1 - ведомая)
    QList<TrRec> _tr_reg_queue; // очередь на запись в файл регистрации
    int _section; // 0 - тепловоз, 1 - дополнительная секеция
    QMap<int, TrMess*> _tr_messages;
    QStringList _tr_strings;
    DataStore* _storage[2];
    QMap<QString, ThreadSerialPort*> _serial_ports;
    DataStore _mainstore;
    SlaveLcm _slave; // additional section
    bool _is_active;
    QFile _mtr_file; // имя и путь файла моторесурса
    QFile _trmess_file; // имя и путь файла тревожных сообщений
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
    void ParseCfg(NodeXML*);
    void ParseFiles(NodeXML*);
    void ParseObjects(NodeXML*);
    void ParseSerialPorts(NodeXML*);
    void ParseDiagnostic(NodeXML*);
    void ParseRegistration(NodeXML*);
    void ParseTrMess(NodeXML*);
    void SetSlaveData();
    QString FormMessage(int, int);
    void SaveMessagesList();
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
    void ChangeMediaDirSignal();
private slots:
    void RegTimerStep();
    void DiagTimerStep();
public slots:
    void Unpack(QString);
//    void LostConnection(QString);
//    void RestoreConnection(QString);
    void ChangeMediaDir(QString);
    void querySaveToUSB();
    bool changeKdr(int);
    void kvitTrBanner();
    void playSoundOnShowBanner();
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
    QJsonArray getParamMainWindow();
    QStringList getStructAnlg(int);
    QStringList getStructDiskr(int);
    QJsonArray getDiskretArray(int);
    QJsonArray getAnalogArray(int);
    QStringList getKdrTrL();
    QStringList getKdrPrivet();
    QJsonArray getKdrDevelop();

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
