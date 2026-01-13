#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngine>
#include "networkmanager.h"

int main(int argc, char *argv[])
{
    // 【重要】WebEngine 初始化设置
    // QtWebEngine 必须在 QApplication 创建之前进行初始化
    // 此外，必须使用 QApplication 而不是 QCoreApplication，因为它依赖于 GUI 系统

    // Qt::AA_EnableHighDpiScaling: 启用高 DPI 缩放，防止在高分屏下界面太小
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    // Qt::AA_ShareOpenGLContexts: 允许 QML 和 WebEngine 共享 OpenGL 上下文，这对于性能至关重要
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);

    QtWebEngine::initialize();

    // 【调试技巧】启用远程调试端口
    // 设置环境变量后，运行程序。你可以在 Chrome 浏览器访问 http://localhost:9222
    // 来调试嵌入在 Qt 中的网页（查看 Console, Network 等）
    qputenv("QTWEBENGINE_REMOTE_DEBUGGING", "9222");

    // 创建应用程序实例
    // 注意：使用的是 QApplication（支持 Widgets 和 GUI），因为 WebEngineWidgets 模块需要它
    // 如果纯 QML 应用通常使用 QGuiApplication
    QApplication app(argc, argv);

    // 【重要】注册 C++ 类型到 QML 系统
    // 参数说明：
    // 1. 模板参数 <NetworkManager>: C++ 类名
    // 2. "App": QML 中引入该模块的名称 (import App 1.0)
    // 3. 1, 0: 版本号 (1.0)
    // 4. "NetworkManager": QML 中使用的组件名称
    // 这样在 QML 中就可以写: NetworkManager { ... }
    qmlRegisterType<NetworkManager>("App", 1, 0, "NetworkManager");

    // 创建 QML 引擎
    QQmlApplicationEngine engine;

    // 另一种交互方式：Context Property（上下文属性）
    // 如果取消注释下面代码，可以在 QML 全局直接使用 networkManager 变量，而不需要实例化
    // 这种方式适合单例对象。本项目采用的是 qmlRegisterType 方式。
    // engine.rootContext()->setContextProperty("networkManager", &manager);

    // 加载 QML 文件
    // 使用 qrc:/ 协议加载资源文件中的 main.qml
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    // 连接 objectCreated 信号，用于检测 QML 是否加载成功
    // 如果 QML 文件有语法错误导致加载失败，obj 将为 null，此时退出程序
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
                     {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    engine.load(url);

    // 进入主事件循环
    return app.exec();
}
