#include "networkmanager.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QImage>
#include <QBuffer>
#include <QFileInfo>
#include <QUrl> // Add QUrl includes
#include <thread>
#include <chrono>

NetworkManager::NetworkManager(QObject *parent) : QObject(parent)
{
    // 初始化 libcurl 全局资源
    curl_global_init(CURL_GLOBAL_DEFAULT);
}

NetworkManager::~NetworkManager()
{
    // 清理 libcurl 资源
    curl_global_cleanup();
}

/**
 * @brief LibCurl 回调函数，用于将服务器响应写入 std::string
 */
size_t NetworkManager::WriteCallback(void *contents, size_t size, size_t nmemb, std::string *userp)
{
    size_t totalSize = size * nmemb;
    userp->append((char *)contents, totalSize);
    return totalSize;
}

/**
 * @brief 模拟从服务器获取仪表盘统计数据
 * 此处使用 std::thread 模拟异步请求，防止阻塞 UI
 */
void NetworkManager::fetchDashboardData()
{
    std::thread([this]()
                {
        // 模拟 500ms 网络延迟
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        
        // 构造模拟数据
        QVariantMap data;
        data["totalImages"] = 1250;
        data["serverStatus"] = "Online";
        data["uploadCount"] = 45;
        data["storageUsed"] = "1.2 GB";
        
        // 切换回主线程触发信号
        // 注意：在实际生产环境中，需确保 `this` 指针在线程执行期间有效
        QMetaObject::invokeMethod(this, [this, data]() {
            emit dashboardDataReady(data);
        }); })
        .detach();
}

QVariantList NetworkManager::createMockImages(int count, const QString &prefix)
{
    QVariantList list;
    for (int i = 0; i < count; ++i)
    {
        QVariantMap img;
        int id = rand() % 1000;
        // 使用 picsum 作为测试图片源
        QString url = QString("https://picsum.photos/id/%1/300/200").arg(id);
        img["url"] = url;
        img["title"] = QString("%1 Image %2").arg(prefix).arg(i + 1);
        img["date"] = "2023-01-01";
        list.append(img);
    }
    return list;
}

void NetworkManager::fetchImages(const QString &category)
{
    std::thread([this, category]()
                {
        std::this_thread::sleep_for(std::chrono::milliseconds(800));
        
        // 模拟从服务器获取列表
        QVariantList images = createMockImages(12, category.isEmpty() ? "Gallery" : category);
        
        QMetaObject::invokeMethod(this, [this, images]() {
            emit imagesReady(images);
        }); })
        .detach();
}

void NetworkManager::searchImages(const QString &keyword)
{
    std::thread([this, keyword]()
                {
        std::this_thread::sleep_for(std::chrono::milliseconds(600));
        QVariantList images = createMockImages(5, "Search: " + keyword);
        QMetaObject::invokeMethod(this, [this, images]() {
            emit searchResultReady(images);
        }); })
        .detach();
}

void NetworkManager::searchByImage(const QString &path)
{
    std::thread([this, path]()
                {
        std::this_thread::sleep_for(std::chrono::milliseconds(1500));
        // 这里实际上应该 upload 图片给服务端做 AI 分析，这里 mock 返回
        QVariantList images = createMockImages(8, "Similar");
        QMetaObject::invokeMethod(this, [this, images]() {
            emit searchResultReady(images);
        }); })
        .detach();
}

void NetworkManager::uploadImage(const QString &path, double x, double y, double w, double h)
{
    // QML 传入的 path 可能是 "file:///C:/..." 格式，需要转换为本地文件路径
    QString localPath = path;
    QUrl url(path);
    if (url.isLocalFile())
        localPath = url.toLocalFile();

    // 在新线程中执行耗时操作 (图片处理 + 网络上传)
    std::thread([this, localPath, x, y, w, h]()
                {
        CURL *curl;
        CURLcode res;
        std::string readBuffer;

        // 1. 加载本地图片
        QImage image(localPath);
        if (image.isNull()) {
             QMetaObject::invokeMethod(this, [this, localPath]() {
                emit uploadFinished(false, "Failed to load image at: " + localPath);
            });
            return;
        }

        // 2. 裁剪图片 (如果参数有效)
        // 注意：x, y, w, h 应该基于原图尺寸或经过正确缩放换算
        if (w > 0 && h > 0) {
            image = image.copy((int)x, (int)y, (int)w, (int)h);
        }

        // 3. 将图片转为 PNG 格式的内存数据 (QByteArray)
        // 这样可以避免保存临时文件，直接从内存上传
        QByteArray byteArray;
        QBuffer buffer(&byteArray);
        buffer.open(QIODevice::WriteOnly);
        image.save(&buffer, "PNG");
        
        // 4. 初始化 LibCurl 进行上传
        curl = curl_easy_init();
        if (curl)
        {
            curl_easy_setopt(curl, CURLOPT_URL, "https://httpbin.org/post");
            curl_easy_setopt(curl, CURLOPT_TIMEOUT, 30L);
            curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);

            curl_mime *mime;
            curl_mimepart *part;
            mime = curl_mime_init(curl);

            part = curl_mime_addpart(mime);
            curl_mime_name(part, "file");
            curl_mime_data(part, byteArray.constData(), byteArray.size());
            curl_mime_filename(part, "upload.png");
            curl_mime_type(part, "image/png");

            curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);
            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
            curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);

            res = curl_easy_perform(curl);
            curl_mime_free(mime);

            if (res == CURLE_OK)
            {
                QMetaObject::invokeMethod(this, [this]() {
                    emit uploadFinished(true, "Upload Successful");
                });
            }
            else
            {
                QString err = curl_easy_strerror(res);
                QMetaObject::invokeMethod(this, [this, err]() {
                    emit uploadFinished(false, "Curl Error: " + err);
                });
            }
            curl_easy_cleanup(curl);
        } })
        .detach();
}