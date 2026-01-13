/**
 * @file main.cpp
 * @brief 应用程序入口
 *
 * 负责初始化 Qt 应用程序，设置 UI 风格，注册 C++ 类型，并加载主 QML 文件。
 */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "networkmanager.h"

int main(int argc, char *argv[])
{
    // 启用高 DPI 缩放支持
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    // 这样在 QML 中可以使用 import App 1.0 然后创建 NetworkManager 对象
    qmlRegisterType<NetworkManager>("App", 1, 0, "NetworkManager");

    QQmlApplicationEngine engine;

    // 加载主 QML 文件
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
                     {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
