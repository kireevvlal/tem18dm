#include "inputpacket.h"

InputPacket::InputPacket()
{
    Data.resize(1024);
    FlagBegin = false;
    Checksum = 0;
    Counter = 0;
    BytesLen = 1;
    OffsetLength = 0;
    Index = 0;
    Order = OrderType::Direct;
}
//--------------------------------------------------------------------------------
void InputPacket::Parse(NodeXML* node)
{
    int i;
    QString value;
    for (i = 0; i < node->Attributes.count(); i++) {
        AttributeXML *attr = node->Attributes[i];
        if (attr->Name == "inclen")
            OffsetLength = attr->Value.toInt();
        else if (attr->Name == "order")
            Order = (attr->Value.toLower() == "reverse") ? OrderType::Reverse : OrderType::Direct;
        else if (attr->Name == "byteslen")
            BytesLen = attr->Value.toInt();
        else if (attr->Name == "index")
            Index = attr->Value.toInt();
    }
    if (node->Child != nullptr) {
        node = node->Child;
        while (node != nullptr) {
            if (node->Name == "par") {
                Parameter *newPar = new Parameter;
                newPar->Parse(node);
                Parameters.append(newPar);
            }
            node = node->Next;
        }
    }
}
//--------------------------------------------------------------------------------
bool InputPacket::Decode(QByteArray data)
{
    uchar ch;
    bool error = false, flagEnd = false;
    int len = data.length();
    for (int i = 0; i < len; i++)
    {
        ch = data[i]; // Прием байта
        if (ch == 0xff)          // Прием синхробайта?
            LastByte = 0xff;
        else
            if (ch == 0xfe)      // Прием байт-стаффинга (FE)
            {
                if ((quint8)LastByte == 0xff)
                {                   // Был байт ff информации
                    ch = 0xff;      // Восстановление ff
                    LastByte = 0;   // Сброс
                }
                if (FlagBegin == false)  // Прием без стартового байта FF
                    error = true;
                else
                {
                    Checksum += ch;     // накапливаем сумму
                    Counter++;       // принят очередной байт информации
                    // Data[Counter] = ch;         // в пакет
                    Data[Counter - BytesLen - 1] = ch;         // в пакет
                    if (Counter == Length + OffsetLength + 1)        // заказанная длина пакета
                    {
                        if (Checksum != 0)          // ошибка контрольной суммы
                            error = true;
                        else     // конец пакета
                            flagEnd = true;     // Happy end !!!!
                    }
                }
            }
            else                    // Прием иного символа
                if ((quint8)LastByte == 0xff)
                {                   // Был действительно!
                    Length = ch;  // Байт длины посылки
                    Checksum = ch;      // инициализация констрольной суммы
                    Counter = 1;       // Счетчик байт
                    LastByte = 0;
                    FlagBegin = true; // Начало информации в пакете
                   // Data[0] = 0xff;
                   // Data[1] = ch;
                    if (BytesLen == 2)
                    {
                        i++;
                        if (i < data.length())
                        {
                            ch = data[i];
                            Length += (ch << 8);
                            Checksum += ch;
                            Counter++;
                     //       Data[2] = ch;
                        }
                        else
                            error = true; // не принят второй байт длины пакета
                    }
                }
                else
                {
                    if (FlagBegin == false)  // Прием без стартового байта FF
                        error = true;
                    else
                    {
                        Checksum += ch;     // накапливаем сумму
                        Counter++;       // принят очередной байт информации
                        // Data[Counter] = ch;         // в пакет
                        Data[Counter - BytesLen - 1] = ch;         // в пакет
                        if (Counter == Length + OffsetLength + 1)        // заказанная длина пакета ????? : +1
                        {
                            if (Checksum != 0)          // ошибка контрольной суммы
                                error = true;
                            else     // конец пакета
                                flagEnd = true;     // Happy end !!!!
                        }
                    }
                }
        if ((error == true) || (flagEnd == true)) // обработка ошибки или приема конца пакета
        {
            Counter = 1;           // все инициализируем исходными данными
            FlagBegin = false;
            Checksum = 0;
            LastByte = 0;
            if (error == true)
                return false; // произошла ошибка
            else
                return true; // пакет принят без ошибок
        }
    }
    return false;
}
//--------------------------------------------------------------------------------
ParameterList InputPacket::GetParameters()
{
    return Parameters;
}
//--------------------------------------------------------------------------------
QByteArray InputPacket::GetData()
{
    return Data;
}
