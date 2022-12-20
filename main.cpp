#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QDebug>
#include <QIcon>
#include <QFont>
#include <signal.h>
#include "processor.h"

Processor *pProcessor;

void handleSignals(int signal) {
    switch (signal) {
//    case SIGABRT:
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
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/Locomotive.ico"));

    Processor ioBf(&app);
    pProcessor = &ioBf;
    qmlRegisterType<Processor>("ConnectorModule", 1, 0, "Connector");
    if (ioBf.Load(/*"D:\\Development\\Qt\\tem18dm*/qApp->applicationDirPath(), "config.xml")) {
        qDebug() << "Config readed!";
        ioBf.Run();
    } else
        qDebug() << "Config read error.";


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    engine.rootContext()->setContextProperty("ioBf", &ioBf);
//    if (ioBf.Load(/*"D:\\Development\\Qt\\tem18dm*/qApp->applicationDirPath(), "config.xml")) {
//        qDebug() << "Config readed!";
//        ioBf.Run();
//    } else
//        qDebug() << "Config read error.";

    signal(SIGTERM, handleSignals);
#ifndef Q_OS_WIN
    signal(SIGHUP, handleSignals);
    signal(SIGQUIT, handleSignals);
#endif
    signal(SIGINT, handleSignals);
    QFont fon("Arial");

    app.setFont(fon);
    return app.exec();
}
