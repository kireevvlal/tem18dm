#include <QStorageInfo>
#include <QDateTime>
#include "registrator.h"

Registrator::Registrator(QObject *parent) : QObject(parent) {
#ifdef Q_OS_WIN
    _os = 0;
#elif Q_OS_UNIX
    _os = 1;
#endif
    _path = _extention = _alias = "";
    _quantity = 3600;
    _interval = 1000;
    _counter = 0;
    _record_size = 0;
    _bank = 0;
    _reg_type = RegistrationType::Record;
}
//--------------------------------------------------------------------------------
void  Registrator::AddRecord(QByteArray data) {
    switch (_reg_type) {
    case RegistrationType::Record:
        if (!_counter)
            _file.open(QIODevice::WriteOnly);
        if (_file.isOpen())
            _file.write(data);
        _counter++;
        if (_counter == _quantity) {
            _file.close();
            Prepare();
            _counter = 0;
        }
        break;
    case RegistrationType::Bulk:
        _banks[_bank].replace(_counter * _record_size, _record_size, data);
        _counter++;
        if (_counter == _quantity) {
            if (_file.open(QIODevice::WriteOnly)) {
                _file.write(_banks[_bank]);
                _file.close();
            }
            _bank = _bank ? 0 : 1;
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
            _file.write(_banks[_bank]);
            _file.close();
        }
        break;
    case RegistrationType::Archive:
        break;
    }
}
//--------------------------------------------------------------------------------
void Registrator::SetParameters(QString path, QString alias, QString extention, RegistrationType regtype, int quantity, int recordsize, int interval) {
    _path = path;
    _alias = alias;
    _extention = extention;
    _reg_type = regtype;
    if (quantity)
        _quantity = quantity;
    if (recordsize)
        _record_size = recordsize;
    if (interval)
        _interval = interval;

    if (_reg_type == RegistrationType::Bulk) {
        _banks[0].resize(_quantity * _record_size);
        _banks[1].resize(_quantity * _record_size);
    }
    Prepare();
}
//--------------------------------------------------------------------------------
void Registrator::Prepare() {
    QDir directory(_path);
    QStorageInfo si = QStorageInfo(directory);
    qint64 available = si.bytesAvailable();
    if (available <= _quantity * _record_size * 2) { // *2 - пока на всякий случай
        QStringList files = directory.entryList(QStringList() << "*.rez", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time | QDir::Reversed);
        if (files.size())
           directory.remove(files[0]);
    }
    QDateTime dt = QDateTime::currentDateTime();
    QString name = _path + "/" + _alias + "_" + "0018" + "_" + dt.date().toString("yyMMdd") + dt.time().toString("hhmmss") + "." + _extention;
    _file.setFileName(name);
}
//--------------------------------------------------------------------------------

