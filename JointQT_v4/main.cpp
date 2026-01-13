#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "src/managers/AppManager.h"
#include "src/models/ImageModel.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material"); // Modern look

    QQmlApplicationEngine engine;

    AppManager appManager;
    // engine.rootContext()->setContextProperty("appManager", &appManager);

    // Register types if needed for instantiation in QML, though model is exposed via AppManager
    qmlRegisterType<ImageModel>("JointQT", 1, 0, "ImageModel");
    qmlRegisterSingletonInstance("JointQT", 1, 0, "AppManager", &appManager);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl)
        {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
