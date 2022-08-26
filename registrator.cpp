#include "registrator.h"

Registrator::Registrator(QObject *parent) : QObject(parent) {
#ifdef Q_OS_WIN
    _os = 0;
#else
    _os = 1;
#endif
    _path = _extention = _alias = "";
    _quantity = 3600;
    _interval = 1000;
}
//--------------------------------------------------------------------------------
void  Registrator::AddRecord(QByteArray data) {
    QByteArray arr = data.mid(0,12);
}
//--------------------------------------------------------------------------------
int Registrator::Parse(NodeXML* node) {
    int i, record_size = 0;
    if (node->Child != nullptr) {
        node = node->Child;
        while (node != nullptr) {
            if (node->Name == "path")
                _path = node->Text;
            else if (node->Name == "file") {
                _alias = node->Text;
                for (i = 0; i < node->Attributes.count(); i++) {
                    AttributeXML *attr = node->Attributes[i];
                    if (attr->Name == "ext")
                        _extention = attr->Value.toLower();
                }
            }
            else if (node->Name == "records") {
                _quantity = node->Text.toInt();
                for (i = 0; i < node->Attributes.count(); i++) {
                    AttributeXML *attr = node->Attributes[i];
                    if (attr->Name == "size")
                        record_size = attr->Value.toInt();
                    if (attr->Name == "interval")
                        _interval = attr->Value.toInt();
                }
            }
            node = node->Next;
        }
    }
    return record_size;
}
