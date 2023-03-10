#include <QStorageInfo>
#include <QDateTime>
#include "registrator.h"
#ifdef Q_OS_WIN
#include <windows.h>
#endif

Registrator::Registrator(LcmSettings *settings, QObject *parent) : QObject(parent) {
    _settings = settings;
    _path = _extention = _alias = "";
    _quantity = 3600;
    _interval = 1000;
    _counter = 0;
    _record_size = 352;
    _bank = 0;
    _reg_type = RegistrationType::Record;
    _sector_size = 512;
    _position = 0;
}
//--------------------------------------------------------------------------------
void  Registrator::CloseFile() {
    _file.flush();
    _file.close();
#ifdef Q_OS_WIN
    Sleep(uint(10));
#endif
#ifdef Q_OS_UNIX
    int ms = 10;
    struct timespec ts = { ms / 1000, (ms % 1000) * 1000 * 1000 };
    nanosleep(&ts, NULL);
#endif
}
//--------------------------------------------------------------------------------
void  Registrator::AddRecord() {
    QByteArray data = _record;
    int remainder, len;
    switch (_reg_type) {
    case RegistrationType::Record:
        if (!_counter)
            _file.open(QIODevice::WriteOnly);
        if (_file.isOpen())
            _file.write(data);
        _counter++;
        if (_counter >= _quantity) {
            CloseFile();
            Prepare();
            _counter = 0;
        }
        break;
    case RegistrationType::Bulk:
        _banks[_bank].replace(_counter * _record_size, _record_size, data);
        _counter++;
        if (_counter >= _quantity) {
            if (_file.open(QIODevice::WriteOnly)) {
                _file.write(_banks[_bank]);
                CloseFile();
            }
            _bank = _bank ? 0 : 1;
            Prepare();
            _counter = 0;
        }
        break;
    case RegistrationType::Sector: // Пока не настроена на размер записи > размера сектора
        remainder = _sector_size - _position; // остаток в буфере
        len = (remainder >= _record_size) ? _record_size : remainder;
        _banks[0].replace(_position, len, data.mid(0, len));
        _position += _record_size;
        if (_position >= _sector_size) { // sector is full
            if (_file.isOpen())
                _file.write(_banks[0]);
            else
                if (_file.open(QIODevice::WriteOnly))
                    _file.write(_banks[0]);
            len = _position - _sector_size; // тут остаток от принятой записи
            if (len)
                _banks[0].replace(0, len, data.mid(remainder, len));
            _position = len;
        }
        _counter++;
        if (_counter >= _quantity) {
            if (_position)
                _file.write(_banks[0].data(), _position);
            _position = 0;
            CloseFile();
            Prepare();
            _counter = 0;
        }
        break;
    case RegistrationType::Archive:
        break;
    }
}
//--------------------------------------------------------------------------------
// при остановке программы
void  Registrator::Stop() {
    // моторесурс

    // файлы регистрации
    switch (_reg_type) {
    case RegistrationType::Record:
        _file.close();
        break;
    case RegistrationType::Bulk:
        if (_file.open(QIODevice::WriteOnly)) {
            _file.write(_banks[_bank].data(), _record_size * _counter);
            _file.close();
        }
        break;
    case RegistrationType::Sector:
        if (_position) {
            if (!_file.isOpen()) {
                if (_file.open(QIODevice::WriteOnly))
                    _file.write(_banks[0].data(), _position);
            } else
                _file.write(_banks[0].data(), _position);
        }
        _file.close();
        break;
    case RegistrationType::Archive:
        break;
    }
}
//--------------------------------------------------------------------------------
void Registrator::SetParameters(QString path, QString alias, QString extention, RegistrationType regtype, int quantity, int recordsize, int interval, int sector) {
    _path = path;
    _alias = alias;
    _extention = extention;
    _reg_type = regtype;
    if (quantity)
        _quantity = quantity;
    if (recordsize)
        _record_size = recordsize;
    _record.resize(_record_size);
    _record.fill('\0');
    if (interval)
        _interval = interval;
    if (sector)
        _sector_size = sector;

    if (_reg_type == RegistrationType::Bulk) {
        _banks[0].resize(_quantity * _record_size);
        _banks[1].resize(_quantity * _record_size);
    } else
        if (_reg_type == RegistrationType::Sector)
            _banks[0].resize(_sector_size);
    Prepare();
}
//--------------------------------------------------------------------------------
void Registrator::Prepare() {
    QDir directory(_path);
    if (_settings->DmType == DisplayType::Atronic) {
        QStorageInfo si = QStorageInfo(directory);
        qint64 available = si.bytesAvailable();
        while (available <= (_quantity + 100) * _record_size) { // + 100 - доп размер на 100 записей

            QStringList files = directory.entryList(QStringList() << "*.rez", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time | QDir::Reversed);
            if (files.size())
                directory.remove(files[0]);
            available = si.bytesAvailable();
        }
    }
    QDateTime dt = QDateTime::currentDateTime();
    QString name = _path + "/" + _alias + "_" + _settings->Number + "_" + dt.date().toString("yyMMdd") + dt.time().toString("hhmmss") + "." + _extention;
    _file.setFileName(name);
}
//--------------------------------------------------------------------------------
bool Registrator::UpdateRecord(uint position, uint length, QByteArray buffer) {
    if (position + length > (uint)_record.length())
        return false;
    _record.replace(position, length, buffer);
//    qDebug() << QString::number(position) + " "  + QString::number(length) + " " + QString::number(_record.length());
    return true;
}
//--------------------------------------------------------------------------------
bool Registrator::SetByteRecord(uint position, quint8 value) {
    if (position > (uint)_record.length())
        return false;
    _record[position] = value;
    return true;
}
//--------------------------------------------------------------------------------
bool Registrator::SetWordRecord(uint position, quint16 value) {
    UnionUInt16 un;
    if (position + 1 > (uint)_record.length())
        return false;
    un.Value = value;
    _record[position] = un.Array[0];
    _record[position + 1] = un.Array[1];
    return true;
}
//--------------------------------------------------------------------------------
bool Registrator::SetDoubleWordRecord(uint position, quint32 value) {
    UnionUInt32 un;
    if (position + 3 > (uint)_record.length())
        return false;
    un.Value = value;
    _record[position] = un.Array[0];
    _record[position + 1] = un.Array[1];
    _record[position + 2] = un.Array[2];
    _record[position + 3] = un.Array[3];
    return true;
}
