#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "ui_data/tts_online.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    TtsOnline *tts = new TtsOnline();
    return app.exec();
}
