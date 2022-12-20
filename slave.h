#ifndef SLAVE_H
#define SLAVE_H
#include "datastore.h"
#include "tem18dm.h"

class SlaveLcm
{
private:
    DataStore _storage;
    QByteArray _outdata;
//    CalcData _calc_data;
public:
    QByteArray Outdata() { return _outdata; }
    DataStore* Storage() { return &_storage; }
    void FillStore(DataStore*);
    void GetPacket(QByteArray, QMap<QString, ThreadSerialPort*>);
    void GetSpData(ThreadSerialPort*, QByteArray, int);
    bool UpdatePacket(uint, uint, QByteArray);
    bool SetBytePacket(uint, quint8);
    bool SetWordPacket(uint, quint16);
    bool SetDoubleWordPacket(uint, quint32);
    SlaveLcm();
};

#endif // SLAVE_H
