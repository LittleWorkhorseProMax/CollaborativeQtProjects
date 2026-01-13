#include "NetworkManager.h"
#include <QNetworkRequest>
#include <QDebug>

#ifdef USE_LIBCURL
#include <curl/curl.h>
// Placeholder for libcurl implementation
#endif

NetworkManager &NetworkManager::instance()
{
  static NetworkManager instance;
  return instance;
}

NetworkManager::NetworkManager(QObject *parent) : QObject(parent)
{
  m_manager = new QNetworkAccessManager(this);
}

void NetworkManager::get(const QString &url, Callback callback)
{
  // Hybrid implementation: if USE_LIBCURL is defined, use it. Otherwise fall back to Qt.
  // For this environment, we primarily rely on Qt to ensure functionality without vcpkg setup.

  QNetworkRequest request((QUrl(url)));
  QNetworkReply *reply = m_manager->get(request);

  connect(reply, &QNetworkReply::finished, this, [reply, callback]()
          {
        if (reply->error() == QNetworkReply::NoError) {
            callback(reply->readAll(), reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt());
        } else {
            qWarning() << "Network Error:" << reply->errorString();
            callback(QByteArray(), reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt());
        }
        reply->deleteLater(); });
}

void NetworkManager::post(const QString &url, const QByteArray &data, const QString &contentType, Callback callback)
{
  QNetworkRequest request((QUrl(url)));
  request.setHeader(QNetworkRequest::ContentTypeHeader, contentType);

  QNetworkReply *reply = m_manager->post(request, data);

  connect(reply, &QNetworkReply::finished, this, [reply, callback]()
          {
        if (reply->error() == QNetworkReply::NoError) {
            callback(reply->readAll(), reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt());
        } else {
            qWarning() << "Network Error:" << reply->errorString();
            callback(QByteArray(), 0);
        }
        reply->deleteLater(); });
}
