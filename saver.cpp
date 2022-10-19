#include "saver.h"
#include <QDateTime>
Saver::Saver(QObject *parent) : QObject(parent) {
    _task_timer =  new QTimer();
    _task_interval = 500;
    _media_path = _reg_path = _current_dir = "";
    _state = 0;
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
        }
        break;
    case 2: // копирование файла
        available = _storage_info.bytesAvailable();
        if (available > 2600000) {
            if (_index < _files.size()) {
                QFile file(_files[_index].filePath());
                file.copy(_media_path + "/" + _current_dir + "/" + _files[_index].fileName());
                _index++;
            } else {
                _state = 0;
                _index = 0;
            }
        } else {
            _state = 0;
            _index = 0;
        }
        break;
    }
}
//--------------------------------------------------------------------------------
void Saver::Save() {
    if (!_state)
        _state = 1; // старт

}
//--------------------------------------------------------------------------------
void Saver::SetParameters(QString mpath, QString rpath, int interval) {
    _media_path = mpath;
    _reg_path = rpath;
    _task_interval = interval;
}
