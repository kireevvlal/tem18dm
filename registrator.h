#ifndef REGISTRATOR_H
#define REGISTRATOR_H

#include <QObject>
#include "treexml.h"

class Registrator : public QObject
{
    Q_OBJECT
private:
    bool _os;            // 0 - win, 1 - linux
    QString _path;      // каталог для записи файлов
    QString _extention; // расширение файла результатов
    QString _alias;     // алиас локомотива для имени файла
    int _quantity;
    int _interval;      // время между записями регистрации (мс)
public:
    explicit Registrator(QObject *parent = nullptr);
    int Interval() { return _interval; }
    int Parse(NodeXML*);           // разбор ветви дерава XML с параметрами объекта
signals:
public slots:
    void AddRecord(QByteArray);
};

#endif // REGISTRATOR_H
