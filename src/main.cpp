#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "common/config_setter.h"
#include "ui_data/tts_online.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("ttsOnline", new ConfigSetter());
    engine.rootContext()->setContextProperty("configSetter", new TtsOnline());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
