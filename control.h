#ifndef CONTROL_H
#define CONTROL_H
#include <QObject>
#include <QBitArray>
#include "datastore.h"

class Control
{
private:
    DataStore* _storage;
    QBitArray _tr_soob;
public:    
//    bool TrSoob(int index) { return _tr_soob[index]; }
//    void TrSoob(int index, bool value) { _tr_soob[index] = value; }
    int KdrNum;
    qint8 _kdr_masl_flags;
    qint8 _kdr_tpl_flags;
    qint8 _kdr_ohl_flags;
    qint8 _kdr_bos_flags; // флаги кадра бортовой сети, ключи РСИ 0-й бит - минус, 1-й - плюс, 2- 2-5 - цветовое выделение индикаторов
    qint8 _kdr_vzb_flags;
    qint8 _kdr_ted_flags;
    int DeltaTC[6]; // отклонения температур цилиндров
    int MinTC;
    int MaxTC;
    int AvgTC;
    void CalculateTC();
    void KdrMasl();
    void KdrTpl();
    void KdrOhl();
    void KdrBos();
    void KdrVzb();
    void KdrTed();
    void Execute();
    Control(DataStore*, QBitArray);
};

#endif // CONTROL_H
