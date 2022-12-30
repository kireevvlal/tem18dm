#ifndef DIAGNOSTICS_H
#define DIAGNOSTICS_H
#include <QObject>
#include <QBitArray>
#include <QDate>
#include <QTime>
#include "datastore.h"
#include "registrator.h"
#include "slave.h"

struct StructRizCU {
    float Up = 0, Um = 0;
    bool snh = false;
    qint64 tp = 0, tm = 0;
    qint8 rss;
};

class Diagnostics
{
private:
    float _pt_max; // макимальное значение давления топлива
    StructRizCU _riz_cu;
//    Processor* _processor;
    DataStore* _storage;
    qint8 _ports_state;  // состояние портов. побитно: 1- открыт, 0 - что-то не так
    qint64 _msec; // системное время в миллисекундах
    float _a_diz; // полезная работа дизеля
    void OnLostBel(ThreadSerialPort*, Registrator* reg, SlaveLcm* slave);
    void OnLostUsta(ThreadSerialPort*, Registrator* reg, SlaveLcm* slave);
    void OnLostIt(ThreadSerialPort*, Registrator* reg, SlaveLcm* slave);
//    void OnLostMss(ThreadSerialPort*);
public:
    QTime Time;
    QDate Date;
    qint8 PortsState() { return _ports_state; }
    float Adiz() { return _a_diz; }
    void Adiz(float value) { _a_diz = value; }
    Diagnostics(DataStore*, float);
    void Motoresurs();
    void Connections(QMap<QString, ThreadSerialPort*>, Registrator* reg, SlaveLcm* slave);
    void RizCU(int);
    void APSignalization(int);
};

#endif // DIAGNOSTICS_H
