#ifndef PROCESSOR_H
#define PROCESSOR_H
#include <QObject>
#include  "zapuso.h"
#include <QJsonArray>

class Processor : public QObject
{
    Q_OBJECT
private:
    QByteArray _bytes_data;
    QJsonArray rejPrT();
public:
    explicit Processor(QObject *parent = nullptr);
    ~ Processor() {}

    public slots:
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
