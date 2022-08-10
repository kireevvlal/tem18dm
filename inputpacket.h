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
    ParameterList GetParameters();
    QByteArray GetData();
    bool Decode(QByteArray);
private:
    bool FlagBegin;
    char Checksum;
    char LastByte;
    int Counter;
    int BytesLen;
    int OffsetLength;
    ParameterList Parameters;
    QByteArray Data;
    int Length;
};

#endif // INPUTPACKET_H
