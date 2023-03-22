#include "saver.h"
#include <QDateTime>
Saver::Saver(LcmSettings *settings, QObject *parent) : QObject(parent) {
    _settings = settings;
    _task_timer =  new QTimer();
    _task_interval = 500;
    _media_path = _reg_path = _current_dir = "";
    _state = _index= _quantity = 0;
    _media_inserted = false;
    _is_running = false;
//    _devices = ScanDev();
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
        if (!_is_running) {
            _is_running = true;
            _save_path = _media_path + _devices.last();
            _directory.setPath(_save_path);
            _storage_info = QStorageInfo(_directory);
            if (_storage_info.isValid() && _storage_info.isReady()) {
                available = _storage_info.bytesAvailable();
                if (available > 2600000) {
                    QDateTime dt(QDateTime::currentDateTime());
                    _current_dir = "tm18" + _settings->Number + dt.toString("yyMMddhhmmss");
                    if (_directory.mkdir(_current_dir)) {
                        _files = QDir(_reg_path).entryInfoList(QStringList() << "*.rez" << "*.rcd", QDir::Files | QDir::NoSymLinks | QDir::Readable, QDir::Time);
                        _index = 1;
                        _state = 2;
                        _quantity = _files.size();
                    } else
                        Reset();
                }
            } else
                Reset();
            _is_running = false;
        }
        break;
    case 2: // копирование файла
        if (!_is_running) {
            _is_running = true;
            available = _storage_info.bytesAvailable();
            if (available > 2600000) {
                if (_index < _quantity) {
                    QFile file(_files[_index].filePath());
                    file.copy(_save_path + "/" + _current_dir + "/" + _files[_index].fileName());
                    _index++;

                } else
                    Reset();
            } else
                Reset();
            _is_running = false;
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
void Saver::Reset() {
    _state = _index = _quantity = 0;
}
//--------------------------------------------------------------------------------
void Saver::Save() {
    if (!_state && _media_inserted)
        _state = 1; // старт
}
//--------------------------------------------------------------------------------
void Saver::MediaChange() {
//#ifdef Q_OS_WIN
//    _media_inserted = true;
//#endif
//#ifdef Q_OS_UNIX
    QStringList devs = ScanDev();
    if (devs.length() != _devices.length()) {
        if (devs.length() > _devices.length()) {
            _media_inserted = true;
            QString dev = devs.last();
            if (dev[dev.length() - 1] == '1')
                _media_inserted = true;
            else
                _media_inserted = false;
        } else
            _media_inserted = false;
        if (!_media_inserted && _state)
            Reset();
        _devices.clear();
        foreach (QString str, devs)
            _devices.append(str);
    }


//    QStringList devs = ScanDev();
//    if (devs.length() != _devices.length()) {
//        if (devs.length() > _devices.length()) {
//            QString dev = devs.last();
//            if (dev[dev.length() - 1] == '1')
//                _media_inserted = true;
//            else
//                _media_inserted = false;
//        } else
//            _media_inserted = false;
//        if (!_media_inserted && _state)
//            Reset();
//        _devices.clear();
//        foreach (QString str, devs)
//            _devices.append(str);
//    }
//#endif
}
//--------------------------------------------------------------------------------
QStringList Saver::ScanDev() {
    QStringList res;
//#ifdef TPK
//    QFileInfoList files = QDir(_media_path).entryInfoList(QStringList() << "sd*", QDir::Dirs);
//#else
    QFileInfoList files = QDir("/dev").entryInfoList(QStringList() << "sd*", QDir::System);
//#endif
    foreach (QFileInfo item, files) {
        res.append(item.fileName());
    }
    return res;
}
//--------------------------------------------------------------------------------
void Saver::SetParameters(QString mpath, QString rpath, int interval) {
    _media_path = mpath;
    _reg_path = rpath;
    _task_interval = interval;
    _devices = ScanDev();
}
