#ifndef SAVER_H
#define SAVER_H

#include <QObject>
#include <QStorageInfo>
#include <QTimer>

class Saver : public QObject
{
    Q_OBJECT
private:
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
public:
    Saver(QObject *parent = nullptr);
    void Run();
    void SetParameters(QString, QString, int);
public slots:
    void Save();
    //void MediaDisconnected();
    void TaskTimerStep();
};

#endif // SAVER_H
