#ifndef THREADSERIALPORT_H
#define THREADSERIALPORT_H
#include <QThread>
#include <QtSerialPort/QSerialPort>
#include <QTimer>
#include "treexml.h"
#include "outputpacket.h"
#include "inputpacket.h"
#include "extratypes.h"
#define TIMEOUT 100

struct SerialPortSettings { //Структура с настройками порта
    QString Name;
    qint32 BaudRate;
    QSerialPort::DataBits DataBits;
    QSerialPort::Parity Parity;
    QSerialPort::StopBits StopBits;
    QSerialPort::FlowControl FlowControl;
 };

class ThreadSerialPort : public QSerialPort
{
    Q_OBJECT
public:
    OutputPacket OutData;
    InputPacket InData;
    explicit ThreadSerialPort(QObject *parent = nullptr);
    ~ThreadSerialPort();
    QString Alias;
    bool IsExchange() { return _isExchange; }
    int QualityCounter() { return _qualityCounter; }
    void Parse(NodeXML*);           // разбор ветви дерава XML с параметрами объекта
    void WriteSettings(QString, int, int, int, int, int);
private:
    bool _isExchange;          // наличие приема данных за заданный интервал
    int _qualityCounter;
    QTimer _timer;
    //QSerialPort *_port;
    SerialPortSettings _settings;
    QThread *_thread;
    ExchangeType _typeExchange; // тип обмена: master - ведущий, slave - ведомый, async - асинхронный
    ProtocolType _typeProtocol; // тип протокола: Staffing - со стафинг-байтом
    int _delay;              // Интервал в мс между посылаемыми пакетами (для Master и Async)
    int _limit;              // Интервал в мс, после которого связь считается утерянной
    int _wait;               // Накапливаемое время ожидания между пакетами
    int _watchdog;           // Накапливаемое время наличия прихода пакетов
    int _counter;
    bool Connect();         // Сроединение по последовательному порту
    void ParsePort(NodeXML*);
    void Write();       //
signals:
    void FinishedSignal();      // Сигнал закрытия класса
    void LogSignal(QString);    // Сигнал лога порта
    void ReadSignal(QString);   // QByteArray data); // Сигнал получения данных
    void DecodeSignal(ThreadSerialPort*); // Success decode packet
    void WriteSignal(QString);  // QByteArray);
public slots:
    void Disconnect();  // Слот отключения порта
    void Start();       // Run threader? open port and start timer
    void Process();     //Тело
private slots:
    void HandleError(QSerialPort::SerialPortError error);//Слот обработки ощибок
    void Read(); //Слот чтения из порта по ReadyRead
    void TimerStep();
};

#endif // THREADSERIALPORT_H
