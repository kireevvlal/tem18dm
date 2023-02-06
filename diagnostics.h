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
    QBitArray _sp_thread_running;
    QBitArray _sp_is_bytes;
    int _sp_error_counters[4] = {0, 0, 0, 0 };
    int _it_packs; // счетчик пакетов от ТИ (связь с ТИ считается установленной помсле прихода четырех пакетов)
    LcmSettings *_settings;
    QDateTime _date_time;
    StructRizCU _riz_cu;
    DataStore* _storage;
//    qint8 _ports_state;  // состояние портов. побитно: 1- открыт, 0 - что-то не так
    qint64 _msec; // системное время в миллисекундах
    float _a_diz; // полезная работа дизеля
    void OnLostBel(ExtSerialPort*, Registrator* reg, SlaveLcm* slave);
    void OnLostUsta(ExtSerialPort*, Registrator* reg, SlaveLcm* slave);
    void OnLostIt(ExtSerialPort*, Registrator* reg, SlaveLcm* slave);
//    void OnLostMss(ThreadSerialPort*);
public:
    QBitArray* SpThreadRunning() { return &_sp_thread_running; }
    QBitArray* SpIsBytes() { return &_sp_is_bytes; }
    int SpErrorsCounter(int index) { return _sp_error_counters[index]; }
    void IncrementITPacks();
    void RefreshDT();
    QTime Time() { return _date_time.time(); }
    QDate Date() { return _date_time.date(); }
//    qint8 PortsState() { return _ports_state; }
    float Adiz() { return _a_diz; }
    void Adiz(float value) { _a_diz = value; }
    Diagnostics(DataStore*, LcmSettings*);
    void Motoresurs();
<<<<<<< HEAD
    void Connections(QMap<QString, ThrSerialPort*>, Registrator* reg, SlaveLcm* slave);
=======
    void Connections(QMap<QString, ExtSerialPort*>, Registrator* reg, SlaveLcm* slave);
>>>>>>> bi0504ext
    void RizCU(int);
    void APSignalization(int);
};

#endif // DIAGNOSTICS_H
