#ifndef REGISTRATOR_H
#define REGISTRATOR_H

#include <QObject>
#include <QFile>
#include "treexml.h"
#include "extratypes.h"

class Registrator : public QObject
{
    Q_OBJECT
private:
    bool _os;            // 0 - win, 1 - linux
    QString _path;      // каталог для записи файлов
    QString _extention; // расширение файла результатов
    QString _alias;     // алиас локомотива для имени файла
    int _quantity;      // записей в файле
    int _interval;      // время между записями регистрации (мс)
    QFile _file;
    RegistrationType _reg_type;
    int _counter;
    int _record_size;
    QByteArray _banks[2];
    int _bank;
    void Prepare();
public:
    int RecordSize() { return _record_size; }
    explicit Registrator(QObject *parent = nullptr);
    void Stop();
    int Interval() { return _interval; }
    void Parse(NodeXML*);           // разбор ветви дерава XML с параметрами объекта
signals:
public slots:
    void AddRecord(QByteArray);
};

#endif // REGISTRATOR_H
