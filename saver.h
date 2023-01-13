#ifndef SAVER_H
#define SAVER_H

#include <QObject>
#include <QStorageInfo>
#include <QTimer>

class Saver : public QObject
{
    Q_OBJECT
private:
    QStringList _devices;
    bool _media_inserted;
    QTimer *_task_timer;
    int _task_interval;
    QString _media_path; // путь к каталогу (диску) для записи
    QString _reg_path; // путь к каталогу регистрации
    int _state; // состояние задачи 0 - простой
    QDir _directory;
    QString _current_dir;
    QFileInfoList _files;
    QStorageInfo _storage_info;
    int _index; // индекс копируемого файла
    int _quantity; // колоичество файлов для записи
    void FindUSBDevices(); // проверка на подключение USB flash
    QStringList ScanDev();
public:
    Saver(QObject *parent = nullptr);
    void Run();
    void SetParameters(QString, QString, int);
    bool MediaInserted() { return _media_inserted; }
    bool Recording() { return _state; }
    int PercentRecorded();
//    QString MediaPath() { return _media_path; }
public slots:
    void Save();
    void MediaChange();
    void TaskTimerStep();
};

#endif // SAVER_H
