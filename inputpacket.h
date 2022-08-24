#ifndef INPUTPACKET_H
#define INPUTPACKET_H
#include <QObject>
#include "treexml.h"
#include "extratypes.h"
#include "parameter.h"

class InputPacket
{
public:
    int Index;
    OrderType Order;
    InputPacket();
    void Parse(NodeXML*);
    //QByteArray Build();
    ParameterList Parameters();
    QByteArray Data();
    bool Decode(QByteArray);
private:
    bool _flag_begin;
    char _checksum;
    char _last_byte;
    int _counter;
    int _bytes_len;
    int _offset;
    ParameterList _parameters;
    QByteArray _data;
    int _length;
};

#endif // INPUTPACKET_H
