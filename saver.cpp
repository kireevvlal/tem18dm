#include "saver.h"
#include <QDateTime>
Saver::Saver(QObject *parent) : QObject(parent) {
    _task_timer =  new QTimer();
    _task_interval = 500;
    _media_path = _reg_path = _current_dir = "";
    _state = _index= _quantity = 0;
    _media_inserted = false;
    _devices = ScanDev();
}
//--------------------------------------------------------------------------------
void Saver::Run() {
    connect(_task_timer, SIGNAL(timeout()), this, SLOT(TaskTimerStep()));
    _task_timer->start(_task_interval);
}
//--------------------------------------------------------------------------------
void Saver::TaskTimerStep() {
    qint64 available;
    switch (_state) {
    case 0: // простой
        break;
    case 1: // начальная обработка
        _directory.setPath(_media_path);
        _storage_info = QStorageInfo(_directory);
        available = _storage_info.bytesAvailable();
        if (available > 2600000) {
            QDateTime dt(QDateTime::currentDateTime());
            _current_dir = "tm180018" + dt.toString("yyMMddhhmmss");
            _directory.mkdir(_current_dir);
            _files = QDir(_reg_path).entryInfoList(QStringList() << "*.rez", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time);
            _index = 1;
            _state = 2;
            _quantity = _files.size();
        }
        break;
    case 2: // копирование файла
        available = _storage_info.bytesAvailable();
        if (available > 2600000) {
            if (_index < _quantity) {
                QFile file(_files[_index].filePath());
                file.copy(_media_path + "/" + _current_dir + "/" + _files[_index].fileName());
                _index++;

            } else {
                _state = _index = _quantity = 0;
            }
        } else {
            _state = _index = _quantity = 0;
        }
        break;
    }
}
//--------------------------------------------------------------------------------
int Saver::PercentRecorded() {
    float pie = (_quantity > 0) ? (float)_index / (float)_quantity : 0;
    return  pie * 100;
}
//--------------------------------------------------------------------------------
void Saver::Save() {
    if (!_state && _media_inserted)
        _state = 1; // старт
}
//--------------------------------------------------------------------------------
void Saver::MediaChange() {
#ifdef Q_OS_WIN
    _media_inserted = true;
#endif
#ifdef Q_OS_UNIX
    QStringList devs = ScanDev();
    if (devs.length() != _devices.length()) {
        _media_inserted = (devs.length() > _devices.length()) ? true : false;
        if (!_media_inserted && state)
            _state = _index = _quantity = 0;
        _devices.clear();
        foreach (QString str, devs)
            _devices.append(str);
    }
#endif
}
//--------------------------------------------------------------------------------
QStringList Saver::ScanDev() {
    QStringList res;
    QFileInfoList files = QDir("/dev").entryInfoList(QStringList() << "sd*", QDir::System);
    foreach (QFileInfo item, files) {
        res.append(item.fileName());
    }
    return res;
}
//--------------------------------------------------------------------------------
void Saver::FindUSBDevices() {

}
//--------------------------------------------------------------------------------
void Saver::SetParameters(QString mpath, QString rpath, int interval) {
    _media_path = mpath;
    _reg_path = rpath;
    _task_interval = interval;
}
