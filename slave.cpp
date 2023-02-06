#include <QMap>
#include "slave.h"


SlaveLcm::SlaveLcm()
{
    _outdata = QByteArray(580, 0);
}
//--------------------------------------------------------------------------------
void SlaveLcm::FillStore(DataStore* mainStore)
{
   QMap<QString, QBitArray*> bitsmap = mainStore->BitsMap();
   for ( QMap<QString, QBitArray*>::iterator i = bitsmap.begin(); i != bitsmap.end(); i++) {
       _storage.Insert(i.key(), new QBitArray(i.value()->count()));
    }
    QMap<QString, qint8> bytemap = mainStore->BytesMap();
    for ( QMap<QString, qint8>::iterator i = bytemap.begin(); i != bytemap.end(); i++) {
        _storage.Insert(i.key(), i.value());
    }
    QMap<QString, qint16> i16map = mainStore->Int16Map();
    for ( QMap<QString, qint16>::iterator i = i16map.begin(); i != i16map.end(); i++) {
        _storage.Insert(i.key(), i.value());
    }
    QMap<QString, quint32> ui32map = mainStore->UInt32Map();
    for ( QMap<QString, quint32>::iterator i = ui32map.begin(); i != ui32map.end(); i++) {
        _storage.Insert(i.key(), i.value());
    }
    QMap<QString, float> fmap = mainStore->FloatMap();
    for ( QMap<QString, float>::iterator i = fmap.begin(); i != fmap.end(); i++) {
        _storage.Insert(i.key(), i.value());
    }
}
//--------------------------------------------------------------------------------
<<<<<<< HEAD
void SlaveLcm::GetPacket(QByteArray packet, QMap<QString, ThrSerialPort*> ports)
=======
void SlaveLcm::GetPacket(QByteArray packet, QMap<QString, ExtSerialPort*> ports)
>>>>>>> bi0504ext
{
//    int i;
//    for (i = 0; i < 8; i++)
//        _storage.SetBit("DIAG_Connections", i, packet[192] & (1 << i));
    _storage.SetBitArray("DIAG_Connections", packet[192]);
//    for (i = 0; i < 7; i++)
//        for (int j = 0; j < 8; j++)
//            _storage.SetBit("PROG_TrSoob", i * 8 + 8 + j, packet[193 + i] & (1 << j));
    _storage.SetBitArray("PROG_TrSoob", packet.mid(193,7));
    _storage.SetByte("DIAG_CQ_BEL", packet[204]);
    _storage.SetByte("DIAG_CQ_USTA", packet[205]);
    _storage.SetByte("DIAG_CQ_IT", packet[206]);
    _storage.SetByte("DIAG_CQ_MSS", packet[207]);
    _storage.SetInt16("DIAG_Rplus", packet[216] + (packet[217] << 8));
    _storage.SetInt16("DIAG_Rminus", packet[218] + (packet[219] << 8));
    _storage.SetInt16("DIAG_Pg", packet[222] + (packet[223] << 8));
    _storage.SetUInt32("DIAG_Motoresurs", packet[236] + (packet[237] << 8) + (packet[238] << 16) + (packet[239] << 24));
    _storage.SetUInt32("DIAG_Adiz", packet[240] + (packet[241] << 8) + (packet[242] << 16) + (packet[243] << 24));
    _storage.SetUInt32("DIAG_Tt", packet[244] + (packet[245] << 8) + (packet[246] << 16) + (packet[247] << 24));
    // ????????????????????_second.UpdatePacket(276, 6 , date); // date and time
    _storage.SetByte("PROG_Reversor", packet[288]);
    _storage.SetByte("PROG_PKM", packet[289]);
    _storage.SetByte("PROG_Regime", packet[290]);
<<<<<<< HEAD
    for (QMap<QString, ThrSerialPort*>::iterator i = ports.begin(); i != ports.end(); i++) {
=======
    for (QMap<QString, ExtSerialPort*>::iterator i = ports.begin(); i != ports.end(); i++) {
>>>>>>> bi0504ext
        if (i.key() == "USTA") {
//            QByteArray data = packet.mid(8, 86);
//            data
            GetSpData(&i.value()->Port, packet.mid(8, 86), 0);
        } else if (i.key() == "BEL") {
            QByteArray a;
            GetSpData(&i.value()->Port, QByteArray("\xC") + packet.mid(0, 8), 0);
        } else if (i.key() == "IT") {
            QByteArray pref(5, '\0');
            GetSpData(&i.value()->Port, pref + packet.mid(96, 32), 0);
            pref[0] = 1;
            GetSpData(&i.value()->Port, pref + packet.mid(128, 32), 1);
            pref[0] = 2;
            GetSpData(&i.value()->Port, pref + packet.mid(160, 32), 2);
        }
    }
}
//--------------------------------------------------------------------------------
void SlaveLcm::GetSpData(ExtSerialPort *port, QByteArray data, int index) {
    ParameterList parameters = port->InData.Parameters();
    Parameter *current;
    int tmp;

    for (int i = 0; i < parameters.size(); i++) {
        current = parameters[i];
        if (current->Index == index) {
           if (port->InData.Order() == OrderType::Reverse && (current->Type == DataType::Float
               || current->Type == DataType::Int16 || current->Type == DataType::Uint16)) {
               tmp = data[current->Byte];
               data[current->Byte] = data[current->Byte + 1];
               data[current->Byte + 1] = tmp;
           }
           _storage.Normalize(current, data);
        }
    }
}
//--------------------------------------------------------------------------------
bool SlaveLcm::UpdatePacket(uint position, uint length, QByteArray buffer) {
    if (position + length > _outdata.length())
        return false;
    _outdata.replace(position, length, buffer);
    return true;
}
//--------------------------------------------------------------------------------
bool SlaveLcm::SetBytePacket(uint position, quint8 value) {
    if (position > _outdata.length())
        return false;
    _outdata[position] = value;
    return true;
}
//--------------------------------------------------------------------------------
bool SlaveLcm::SetWordPacket(uint position, quint16 value) {
    UnionUInt16 un;
    if (position + 1 > _outdata.length())
        return false;
    un.Value = value;
    _outdata[position] = un.Array[0];
    _outdata[position + 1] = un.Array[1];
    return true;
}
//--------------------------------------------------------------------------------
bool SlaveLcm::SetDoubleWordPacket(uint position, quint32 value) {
    UnionUInt32 un;
    if (position + 3 > _outdata.length())
        return false;
    un.Value = value;
    _outdata[position] = un.Array[0];
    _outdata[position + 1] = un.Array[1];
    _outdata[position + 2] = un.Array[2];
    _outdata[position + 3] = un.Array[3];
    return true;
}
