#include <QStorageInfo>
#include <QDateTime>
#include "registrator.h"
#ifdef Q_OS_WIN
#include <windows.h>
#endif

Registrator::Registrator(LcmSettings *settings, QObject *parent) : QObject(parent) {
    _settings = settings;
    _used_ram = false;
    _path = _alias = "";
    _quantity = 3600;
    _interval = 1000;
    _counter = 0;
    _record_size = 352;
    _bank = 0;
    _reg_type = RegistrationType::Record;
    _sector_size = 512;
    _position = 0;
    _need_compression = false;
}
//--------------------------------------------------------------------------------
void  Registrator::CloseFile() {
    _file.flush();
    _file.close();
    if (_need_compression) {
        QFileInfo info(_file.fileName());
        if (_file.open(QIODevice::ReadOnly)) {
            QByteArray compressed = qCompress(_file.readAll());
            if (compressed.length() > 0) {
                QFile outfile(info.path() + "/" + info.completeBaseName() + ".rcd"); // res  compressed data
                if (outfile.open(QIODevice::WriteOnly)) {
                    outfile.write(compressed);
                    outfile.close();
                    _file.remove();
                }
            }
        }
    }
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
//        _file.close();
        break;
    case RegistrationType::Bulk:
        if (_file.open(QIODevice::WriteOnly)) {
            _file.write(_banks[_bank].data(), _record_size * _counter);
//            _file.close();
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
//        _file.close();
        break;
    case RegistrationType::Archive:
        break;
    }
    CloseFile();
}
//--------------------------------------------------------------------------------
void Registrator::SetParameters(QString path, QString alias, RegistrationType regtype, int quantity, int recordsize, int interval, int sector, bool compress, bool ram) {
    _path = path;
    _alias = alias;
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
    if (compress)
        _need_compression = true;
    if (ram)
        _used_ram = true;
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
    int i;
    QDir directory(_path);
    if (!_used_ram) {
        QStorageInfo si = QStorageInfo(directory);
        qint64 available = si.bytesAvailable();
        //qint64 needvalue = (_settings->DmType == DisplayType::Atronic) ? ((_quantity + 100) * _record_size) : 105000000; //Atronic: + 100 - доп размер на 100 записей // ~100MB for TPK
        if (available >= 0) {
            QStringList files = directory.entryList(QStringList() << "*.rez" << "*.rcd", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time | QDir::Reversed);
            while (available <= NEEDVALUE && files.size()) { // + 100 - доп размер на 100 записей
                directory.remove(files[0]);
                si = QStorageInfo(directory);
                available = si.bytesAvailable();
                files = directory.entryList(QStringList() << "*.rez" << "*.rcd", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time | QDir::Reversed);
            }
        }
    } else { // - TPK, RAM drive
        qint64 allocated = 0;
        QFileInfoList filesinfo = directory.entryInfoList(QStringList() << "*.rez" << "*.rcd", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time | QDir::Reversed);
        for (i = 0; i < filesinfo.size(); i++) // summ onr time
            allocated += filesinfo[i].size();
        while (allocated > 400000000 && filesinfo.size()) {
            directory.remove(filesinfo[0].absoluteFilePath());
            allocated -= filesinfo[0].size();
            filesinfo = directory.entryInfoList(QStringList() << "*.rez" << "*.rcd", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time | QDir::Reversed);
        }
    }
    QDateTime dt = QDateTime::currentDateTime();
    QString name = _path + "/" + _alias + "_" + _settings->Number + "_" + dt.date().toString("yyMMdd") + dt.time().toString("hhmmss")
            + ((_settings->DmType == DisplayType::TPK) ? "k" : ((_settings->DmType == DisplayType::Atronic) ? "a" : "")) + ".rez"; // k - kontinent, a - atronic
    _file.setFileName(name);
}
//--------------------------------------------------------------------------------
bool Registrator::UpdateRecord(uint position, uint length, QByteArray buffer) {
    if (position + length > (uint)_record_size)
        return false;
    _record.replace(position, length, buffer);
//    qDebug() << QString::number(position) + " "  + QString::number(length) + " " + QString::number(_record.length());
    return true;
}
//--------------------------------------------------------------------------------
bool Registrator::SetByteRecord(uint position, quint8 value) {
    if (position > (uint)_record_size)
        return false;
    _record[position] = value;
    return true;
}
//--------------------------------------------------------------------------------
bool Registrator::SetWordRecord(uint position, quint16 value) {
    UnionUInt16 un;
    if (position + 1 > (uint)_record_size)
        return false;
    un.Value = value;
    _record[position] = un.Array[0];
    _record[position + 1] = un.Array[1];
    return true;
}
//--------------------------------------------------------------------------------
bool Registrator::SetDoubleWordRecord(uint position, quint32 value) {
    UnionUInt32 un;
    if (position + 3 > (uint)_record_size)
        return false;
    un.Value = value;
    _record[position] = un.Array[0];
    _record[position + 1] = un.Array[1];
    _record[position + 2] = un.Array[2];
    _record[position + 3] = un.Array[3];
    return true;
}
