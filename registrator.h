#ifndef REGISTRATOR_H
#define REGISTRATOR_H

#include <QObject>
#include <QFile>
#include <QJsonArray>
#include "treexml.h"
#include "vktoolstypes.h"
#include "tem18dm.h"

#define NEEDVALUE 104857600 // min free disk space

class Registrator : public QObject
{
    Q_OBJECT
private:
    LcmSettings *_settings;
    bool _used_ram;     // запись RAM-диск
    QString _path;      // каталог для записи файлов
    QString _alias;     // алиас локомотива для имени файла
    int _quantity;      // записей в файле
    int _interval;      // время между записями регистрации (мс)
    QByteArray _record;  // буфер данных (запись) для регистрации
    QFile _file;
    RegistrationType _reg_type;
    int _counter;       // счетчик принятых записей в текущий файл
    int _record_size;   // длина записи
    int _position;      // позиция в буфере при записи секторами
    int _sector_size;   // физический размер сектора
    bool _need_compression; // необходимо сжатие файла после окончания записи
    QByteArray _banks[2];
    int _bank;
    void Prepare();
    void CloseFile();
public:
    bool UsedRAM() { return _used_ram; }
    QString Path() { return _path; }
    int RecordSize() { return _record_size; }
    explicit Registrator(LcmSettings*, QObject *parent = nullptr);
    void Stop();
    int Interval() { return _interval; }
    void SetParameters(QString,  QString, RegistrationType, int, int, int, int, bool, bool);
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
