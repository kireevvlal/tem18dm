#ifndef CONTROL_H
#define CONTROL_H
#include <QObject>
#include <QBitArray>
#include "datastore.h"
#include "slave.h"
#include "tem18dm.h"

class Control
{
private:
    DataStore* _storage[2];
    //QBitArray* _tr_flags[2];
public:    
//    bool TrSoob(int index) { return _tr_soob[index]; }
//    void TrSoob(int index, bool value) { _tr_soob[index] = value; }
    int KdrNum;
//    qint8 _kdr_masl_flags;
//    qint8 _kdr_tpl_flags;
//    qint8 _kdr_ohl_flags;
//    qint8 _kdr_bos_flags; // флаги кадра бортовой сети, ключи РСИ 0-й бит - минус, 1-й - плюс, 2- 2-5 - цветовое выделение индикаторов
//    qint8 _kdr_vzb_flags;
//    qint8 _kdr_ted_flags;
    int DeltaTC[2][6]; // отклонения температур цилиндров
    int MinTC[2];
    int MaxTC[2];
    int AvgTC[2];
    void CalculateTC();
    qint8 KdrMasl(int); // 0 - this, 1 - second section
    qint8 KdrTpl(int);
    qint8 KdrOhl(int);
    qint8 KdrBos(int);
    qint8 KdrVzb(int);
    qint8 KdrTed(int);
    qint8 KdrSmlMain(int);
    Control(DataStore*, DataStore*);
};

#endif // CONTROL_H
