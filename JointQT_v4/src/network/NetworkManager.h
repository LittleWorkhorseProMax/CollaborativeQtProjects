#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <functional>

class NetworkManager : public QObject
{
  Q_OBJECT
public:
  static NetworkManager &instance();

  using Callback = std::function<void(const QByteArray &data, int statusCode)>;

  void get(const QString &url, Callback callback);
  void post(const QString &url, const QByteArray &data, const QString &contentType, Callback callback);
  // Add other methods as needed (put, delete, etc.)

private:
  explicit NetworkManager(QObject *parent = nullptr);
  QNetworkAccessManager *m_manager;
};

#endif // NETWORKMANAGER_H
