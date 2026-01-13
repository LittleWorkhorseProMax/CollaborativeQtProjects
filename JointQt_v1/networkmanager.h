#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QRectF>
#include <curl/curl.h>

/**
 * @brief NetworkManager 类
 *
 * 核心业务控制器，负责：
 * 1. 与 QML 前端交互 (Q_INVOKABLE 方法和 Signals)
 * 2. 模拟与后端服务器的通信 (使用 LibCurl)
 * 3. 图片的本地处理 (裁剪、格式转换)
 */
class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);
    ~NetworkManager();

    // --- QML 可调用的接口 ---

    /**
     * @brief 获取仪表盘数据
     * 对应页面: PageDashboard.qml
     */
    Q_INVOKABLE void fetchDashboardData();

    /**
     * @brief 获取图片列表
     * @param category 过滤分类 (如 "Nature", "Architecture")
     * 对应页面: PageGallery.qml
     */
    Q_INVOKABLE void fetchImages(const QString &category);

    /**
     * @brief 文本关键词搜索
     * @param keyword 搜索关键词
     */
    Q_INVOKABLE void searchImages(const QString &keyword);

    /**
     * @brief 以图搜图
     * @param path 本地图片路径
     */
    Q_INVOKABLE void searchByImage(const QString &path);

    /**
     * @brief 上传图片（支持裁剪）
     * @param path 图片本地路径
     * @param x 裁剪区域 X (相对于图片像素)
     * @param y 裁剪区域 Y
     * @param w 裁剪宽度
     * @param h 裁剪高度
     *
     * 如果 w 或 h <= 0，则直接上传原图。
     */
    Q_INVOKABLE void uploadImage(const QString &path, double x, double y, double w, double h);

signals:
    // --- 信号定义 (发送结果回 UI) ---
    void dashboardDataReady(QVariantMap data);
    void imagesReady(QVariantList images);
    void searchResultReady(QVariantList images);
    void uploadFinished(bool success, QString message);

private:
    // LibCurl 的写回调，用于接收响应数据
    static size_t WriteCallback(void *contents, size_t size, size_t nmemb, std::string *userp);

    // 辅助函数：生成模拟的图片数据
    QVariantList createMockImages(int count, const QString &prefix);
};

#endif // NETWORKMANAGER_H