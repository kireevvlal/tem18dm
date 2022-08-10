#include "outputpacket.h"

OutputPacket::OutputPacket()
{
    Order = OrderType::Direct;
}
//--------------------------------------------------------------------------------
void OutputPacket::Parse(NodeXML* node)
{
    int i;
    QString value;
    for (i = 0; i < node->Attributes.count(); i++) {
        AttributeXML *attr = node->Attributes[i];
        if (attr->Name == "length") {
            Length = attr->Value.toInt();
//            Data.resize(Length + 1);
//            Data[0] = 0xff;
//            Data[1] = Length;
        } else if (attr->Name == "order")
            Order = (attr->Value.toLower() == "reverse") ? OrderType::Reverse : OrderType::Direct;
    }
    if (node->Child != nullptr) {
        node = node->Child;
        while (node != nullptr) {
            if (node->Name == "par") {
                Parameter *newPar = new Parameter;
                newPar->Parse(node);
                Values.append(newPar);
            }
            node = node->Next;
        }     
    }
    // Init Data
    Data.resize(Length - 1);
    Data.fill(0);
    for (i = 0; i < Values.size(); i++)
        Data[Values[i]->Byte] = Values[i]->Value;
}
//--------------------------------------------------------------------------------
QByteArray OutputPacket::Build() //Build()
{
    return (this->*BuildFunction)();
}

//--------------------------------------------------------------------------------
QByteArray OutputPacket::Staffing() // Staffing byte
{
    QByteArray data;
    char ks = 0;
    int i;
    data.append(0xff);
    ks = Length;
    data.append(Length);
    for (i = 0; i < Data.size(); i++) {
        data.append(Data[i]);
        ks += Data[i];
        if ((quint8)Data[i] == 0xff)
            data.append(0xfe);
    }
    data.append(~ks + 1);
    return data;
}
//--------------------------------------------------------------------------------
void OutputPacket::SetProtocol(ProtocolType protocol)
{
    if (protocol == ProtocolType::Staffing)
        this->BuildFunction = &OutputPacket::Staffing;
}
