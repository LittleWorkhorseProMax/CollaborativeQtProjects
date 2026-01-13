#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QDebug>
#include <curl/curl.h>

/**
 * @brief NetworkManager 类
 *
 * 这是一个继承自 QObject 的 C++ 类，主要用于演示：
 * 1. 如何封装 C++ 逻辑供 QML 调用。
 * 2. 如何使用第三方 C 库 (libcurl) 进行网络请求。
 * 3. 如何通过 Qt WebChannel 与网页 JS 通信。
 */
class NetworkManager : public QObject
{
Q_OBJECT // 【重要】所有需要使用信号槽、属性系统或被 QML 调用的类，都必须添加此宏
    public : explicit NetworkManager(QObject *parent = nullptr);
    ~NetworkManager();

    // 【重要】Q_INVOKABLE 宏
    // 原理：Qt 的元对象系统默认不暴露普通成员函数给 QML/JS。
    // 加上此宏后，该方法才可以被 QML 直接调用，或者通过 WebChannel 被网页 JS 调用。
    Q_INVOKABLE void fetchAPI();

signals:
    // 【重要】信号 (Signals)
    // 信号只需要声明，不需要实现（moc 编译器会自动生成实现）。
    // 当我们想要通知 QML 或 JS "有新数据了"，就发射这个信号。
    // QML 中可以使用 onDataReceived: code 响应。
    // WebChannel JS 中可以使用 object.dataReceived.connect(func) 响应。
    void dataReceived(QString data);

private:
    // libcurl 的回调函数，必须是静态函数，因为 C 语言库无法直接调用 C++ 成员函数
    static size_t WriteCallback(void *contents, size_t size, size_t nmemb, std::string *userp);
};

#endif // NETWORKMANAGER_H
