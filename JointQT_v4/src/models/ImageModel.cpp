#include "ImageModel.h"
#include "../network/NetworkManager.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>

ImageModel::ImageModel(QObject *parent)
    : QAbstractListModel(parent)
{
  addDummyData();
}

int ImageModel::rowCount(const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;
  return m_images.count();
}

QVariant ImageModel::data(const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  int row = index.row();
  // Using value() is safer than [] or at() as it checks bounds and returns default T() if out of bounds
  // However manually checking range here is double safety
  if (row < 0 || row >= m_images.count())
    return QVariant();

  const ImageData image = m_images.value(row);

  switch (role)
  {
  case IdRole:
    return image.id;
  case FilenameRole:
    return image.filename;
  case UrlRole:
    return image.url;
  case ThumbnailRole:
    return image.thumbnail;
  case WidthRole:
    return image.width;
  case HeightRole:
    return image.height;
  case RatingRole:
    return image.rating;
  case TagsRole:
    return image.tags;
  case DescriptionRole:
    return image.description;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> ImageModel::roleNames() const
{
  QHash<int, QByteArray> roles;
  roles[IdRole] = "id";
  roles[FilenameRole] = "filename";
  roles[UrlRole] = "url";
  roles[ThumbnailRole] = "thumbnail";
  roles[WidthRole] = "width";
  roles[HeightRole] = "height";
  roles[RatingRole] = "rating";
  roles[TagsRole] = "tags";
  roles[DescriptionRole] = "description";
  return roles;
}

int ImageModel::count() const
{
  return m_images.count();
}

QVariantMap ImageModel::get(int row) const
{
  if (row < 0 || row >= m_images.count())
    return QVariantMap();

  const ImageData image = m_images.value(row);
  QVariantMap map;
  map["id"] = image.id;
  map["filename"] = image.filename;
  map["url"] = image.url;
  map["thumbnail"] = image.thumbnail;
  map["width"] = image.width;
  map["height"] = image.height;
  map["rating"] = image.rating;
  map["tags"] = image.tags;
  map["description"] = image.description;
  return map;
}

void ImageModel::loadImages()
{
  // Example of network call (mock)
  NetworkManager::instance().get("http://localhost:8080/api/v1/images", [this](const QByteArray &data, int status)
                                 {
        if(status == 200) {
            // Parse JSON and populate m_images
            // beginResetModel() ... endResetModel()
        } });
}

void ImageModel::addDummyData()
{
  beginResetModel();
  m_images.clear();
  // Assuming local assets or placeholder URLs for demo
  m_images.append({1, "scenery1.jpg", QUrl("qrc:/qml/assets/placeholder.svg"), QUrl("qrc:/qml/assets/placeholder.svg"), 1920, 1080, 4.5, {"nature"}, "Beautiful view"});
  m_images.append({2, "cat.png", QUrl("qrc:/qml/assets/placeholder.svg"), QUrl("qrc:/qml/assets/placeholder.svg"), 800, 600, 5.0, {"animal", "cute"}, "My cat"});
  m_images.append({3, "building.jpg", QUrl("qrc:/qml/assets/placeholder.svg"), QUrl("qrc:/qml/assets/placeholder.svg"), 1024, 768, 3.5, {"city"}, "Downtown"});
  endResetModel();
  emit countChanged();
}
