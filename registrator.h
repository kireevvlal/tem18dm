#ifndef REGISTRATOR_H
#define REGISTRATOR_H

#include <QObject>
#include <QFile>
#include <QJsonArray>
#include "treexml.h"
#include "vktoolstypes.h"
#include "tem18dm.h"

class Registrator : public QObject
{
    Q_OBJECT
private:
    LcmSettings *_settings;
    QString _path;      // каталог для записи файлов
    QString _extention; // расширение файла результатов
    QString _alias;     // алиас локомотива для имени файла
    int _quantity;      // записей в файле
    int _interval;      // время между записями регистрации (мс)
    QByteArray _record;  // буфер данных (запись) для регистрации
    QFile _file;
    RegistrationType _reg_type;
    int _counter;
    int _record_size;   // длина записи
    int _position;      // позиция в буфере при записи секторами
    int _sector_size;   // физический размер сектора
    QByteArray _banks[2];
    int _bank;
    void Prepare();
    void CloseFile();
public:
    //int RecordSize() { return _record_size; }
    explicit Registrator(LcmSettings*, QObject *parent = nullptr);
    void Stop();
    int Interval() { return _interval; }
    void SetParameters( QString,  QString,  QString, RegistrationType, int, int, int, int);
    //void Parse(NodeXML*);           // разбор ветви дерава XML с параметрами объекта
    bool UpdateRecord(uint, uint, QByteArray);
    bool SetByteRecord(uint, quint8);
    bool SetWordRecord(uint, quint16);
    bool SetDoubleWordRecord(uint, quint32);
//    void SetRecordSize() { _record.resize(_record_size); _record.fill('\0'); }
//    void WriteRecord();
signals:
public slots:
    void AddRecord();
};

#endif // REGISTRATOR_H
