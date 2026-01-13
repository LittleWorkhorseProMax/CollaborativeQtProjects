#include "networkmanager.h"
#include <iostream>
#include <string>

NetworkManager::NetworkManager(QObject *parent) : QObject(parent)
{
    // 初始化 libcurl 全局状态
    // 通常建议在程序启动时只需调用一次，这里放在构造函数中仅为演示方便
    curl_global_init(CURL_GLOBAL_DEFAULT);
}

NetworkManager::~NetworkManager()
{
    // 清理 libcurl 全局资源
    curl_global_cleanup();
}

/**
 * @brief libcurl 的写回调函数
 * 
 * 当 curl 接收到网络数据时，会分块调用此函数。
 * @param contents 指向接收到的数据块的指针
 * @param size 每个数据项的大小
 * @param nmemb 数据项的个数
 * @param userp 用户自定义指针（这里我们在 CURLOPT_WRITEDATA 中传入了 std::string 的地址）
 * @return size_t 返回实际处理的字节数
 */
size_t NetworkManager::WriteCallback(void *contents, size_t size, size_t nmemb, std::string *userp)
{
    size_t totalSize = size * nmemb;
    // 将接收到的新数据追加到我们的 string 缓冲区中
    userp->append((char*)contents, totalSize);
    return totalSize;
}

/**
 * @brief 执行网络请求
 * 
 * 此函数被设计为 Q_INVOKABLE，即可以从 QML/JS 异步调用。
 * 它使用 libcurl 发起同步 HTTP GET 请求（注意：在主线程做同步网络请求会卡顿 UI，
 * 实际项目中建议放入 QThread 或使用 Qt 的异步 QNetworkAccessManager）。
 */
void NetworkManager::fetchAPI()
{
    CURL *curl;
    CURLcode res;
    std::string readBuffer; // 用于存储响应数据

    curl = curl_easy_init();
    if (curl) {
        // 设置目标 URL (一个免费的测试 API)
        curl_easy_setopt(curl, CURLOPT_URL, "https://jsonplaceholder.typicode.com/posts/1");
        
        // 设置超时时间（秒），防止无限等待
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10L); 
        
        // 设置回调函数，用于处理响应数据
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        // 设置传递给回调函数的自定义数据指针
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        
        // 【注意】跳过 SSL 证书验证
        // 在开发环境或访问自签名服务器时常用，但在生产环境如果不安全可以去掉
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L); 
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L);

        qDebug() << "NetworkManager: Waiting for response...";
        
        // 执行请求（阻塞操作）
        res = curl_easy_perform(curl);

        if (res == CURLE_OK) {
            // 请求成功
            QString response = QString::fromStdString(readBuffer);
            qDebug() << "NetworkManager: Success:" << response;
            
            // 【关键】发射信号
            // 这会通知所有连接了 dataReceived 信号的槽（包括 QML 和 WebChannel）
            emit dataReceived(response);
        } else {
            // 请求失败
            QString error = QString("Error: %1").arg(curl_easy_strerror(res));
            qDebug() << "NetworkManager:" << error;
            emit dataReceived(error);
        }

        // 清理本次请求的 handle
        curl_easy_cleanup(curl);
    }
}

