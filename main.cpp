#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QDebug>
#include <QIcon>
#include <QFont>
#include <QCursor>
#include <signal.h>
#include "processor.h"
#include <iostream>
#include <exception>
#ifdef Q_OS_WIN
#define LOGPATH QString("D:/CF")
#endif
#ifdef Q_OS_UNIX
#define LOGPATH QString("/media/user/cf_sda_1")
#endif
//--------------------------------------------------------------------------------
Processor *pProcessor;
//--------------------------------------------------------------------------------
void handleExitSignals(int signal) {
    switch (signal) {
    case SIGABRT:
//        break;
    case SIGTERM:
//        break;
#ifndef Q_OS_WIN
    case SIGHUP:
//        break;
    case SIGQUIT:
//        break;
#endif
    case SIGINT:
        pProcessor->Stop();
        exit(0);
        break;
    }
}
//--------------------------------------------------------------------------------
void handleErrorsSignals(int signal) {
    QFile file;
    file.setFileName(LOGPATH + "/errors_"  + QDate::currentDate().toString("ddMMyy") + ".txt");
    if (file.open(QIODevice::Append)) {
        QTextStream stream(&file);
        stream.setCodec("UTF-8");
        QString error;
        switch (signal) {
        case SIGSEGV:
            error =  "Error Segmentation fault"; break;
        case SIGFPE:
            error = "Error Floating point exception"; break;
#ifndef Q_OS_WIN
        case SIGBUS:
            error = "Bus error (bad memory access)"; break;
#endif
        }
        stream << QTime::currentTime().toString("hh:mm:ss") + " " + error << endl;
        file.close();
    }
    pProcessor->Stop();
    exit(EXIT_FAILURE);
}
//--------------------------------------------------------------------------------
int main(int argc, char *argv[])
{
    int ret;
    QString apppath;

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/Locomotive.ico"));

    Processor ioBf(&app);
    pProcessor = &ioBf;
    qmlRegisterType<Processor>("ConnectorModule", 1, 0, "Connector");
    apppath = qApp->applicationDirPath();
    if (ioBf.Load(apppath, "config.xml")) {
        ioBf.Run();
    }
    else {
        qDebug() << "Config read error. Program exit.";
        return 0;
    }


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    engine.rootContext()->setContextProperty("ioBf", &ioBf);
    // exit signals
    signal(SIGABRT, handleExitSignals);
    signal(SIGTERM, handleExitSignals);
#ifndef Q_OS_WIN
    signal(SIGHUP, handleExitSignals);
    signal(SIGQUIT, handleExitSignals);
#endif
    signal(SIGINT, handleExitSignals);
    // errors signals
    signal(SIGSEGV, handleErrorsSignals);
    signal(SIGFPE, handleErrorsSignals);
#ifndef Q_OS_WIN
    signal(SIGBUS, handleErrorsSignals);
#endif

//    QFont fon("Gigi");
//    app.setFont(fon);
#ifndef Q_OS_WIN
    app.setOverrideCursor(QCursor(Qt::BlankCursor));
#endif
    try {
        ret = app.exec();
    } catch (const std::exception &e) {
        pProcessor->Stop();
        std::cerr << e.what() << std::endl;
        return EXIT_FAILURE;
    }

    return ret;
}
