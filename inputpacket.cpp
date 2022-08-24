#include "inputpacket.h"

InputPacket::InputPacket()
{
    // Data.resize(1024);
    _flag_begin = false;
    _checksum = 0;
    _counter = 0;
    _bytes_len = 1;
    _offset = 0;
    Index = 0xff; // нет индекса
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
            _offset = attr->Value.toInt();
        else if (attr->Name == "order")
            Order = (attr->Value.toLower() == "reverse") ? OrderType::Reverse : OrderType::Direct;
        else if (attr->Name == "byteslen")
            _bytes_len = attr->Value.toInt();
        else if (attr->Name == "index")
            Index = attr->Value.toInt();
    }
    if (node->Child != nullptr) {
        node = node->Child;
        while (node != nullptr) {
            if (node->Name == "par") {
                Parameter *newPar = new Parameter;
                newPar->Parse(node);
                _parameters.append(newPar);
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
            _last_byte = 0xff;
        else
            if (ch == 0xfe)      // Прием байт-стаффинга (FE)
            {
                if ((quint8)_last_byte == 0xff)
                {                   // Был байт ff информации
                    ch = 0xff;      // Восстановление ff
                    _last_byte = 0;   // Сброс
                }
                if (_flag_begin == false)  // Прием без стартового байта FF
                    error = true;
                else
                {
                    _checksum += ch;     // накапливаем сумму
                    _counter++;       // принят очередной байт информации
                    // Data[Counter] = ch;         // в пакет
                    _data.append(ch); // Data[Counter - BytesLen - 1] = ch;         // в пакет
                    if (_counter == _length + _offset + 1)        // заказанная длина пакета
                    {
                        if (_checksum != 0)          // ошибка контрольной суммы
                            error = true;
                        else     // конец пакета
                            flagEnd = true;     // Happy end !!!!
                    }
                }
            }
            else                    // Прием иного символа
                if ((quint8)_last_byte == 0xff)
                {                   // Был действительно!
                    _length = ch;  // Байт длины посылки
                    _checksum = ch;      // инициализация констрольной суммы
                    _counter = 1;       // Счетчик байт
                    _last_byte = 0;
                    _flag_begin = true; // Начало информации в пакете
                   // Data[0] = 0xff;
                   // Data[1] = ch;
                    _data.clear();
                    if (_bytes_len == 2)
                    {
                        i++;
                        if (i < data.length())
                        {
                            ch = data[i];
                            _length += (ch << 8);
                            _checksum += ch;
                            _counter++;
                     //       Data[2] = ch;
                        }
                        else
                            error = true; // не принят второй байт длины пакета
                    }
                }
                else
                {
                    if (_flag_begin == false)  // Прием без стартового байта FF
                        error = true;
                    else
                    {
                        _checksum += ch;     // накапливаем сумму
                        _counter++;       // принят очередной байт информации
                        // Data[Counter] = ch;         // в пакет
                        _data.append(ch); // Data[Counter - BytesLen - 1] = ch;         // в пакет
                        if (_counter == _length + _offset + 1)        // заказанная длина пакета ????? : +1
                        {
                            if (_checksum != 0)          // ошибка контрольной суммы
                                error = true;
                            else     // конец пакета
                                flagEnd = true;     // Happy end !!!!
                        }
                    }
                }
        if ((error == true) || (flagEnd == true)) // обработка ошибки или приема конца пакета
        {
            _counter = 1;           // все инициализируем исходными данными
            _flag_begin = false;
            _checksum = 0;
            _last_byte = 0;
            if (error == true)
                return false; // произошла ошибка
            else
                return true; // пакет принят без ошибок
        }
    }
    return false;
}
//--------------------------------------------------------------------------------
ParameterList InputPacket::Parameters()
{
    return _parameters;
}
//--------------------------------------------------------------------------------
QByteArray InputPacket::Data()
{
    return _data;
}
