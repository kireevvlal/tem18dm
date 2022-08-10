#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QDebug>
#include "processor.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    Processor ioBf(&app);
    qmlRegisterType<Processor>("ConnectorModule", 1, 0, "Connector");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    engine.rootContext()->setContextProperty("ioBf", &ioBf);
    if (ioBf.Load("D:\\Development\\Qt\\tem18dm\\config.xml")) {
        qDebug() << "Config readed!";
        ioBf.Run();
    } else
        qDebug() << "Config read error.";

    return app.exec();
}
