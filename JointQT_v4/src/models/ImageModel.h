#ifndef IMAGEMODEL_H
#define IMAGEMODEL_H

#include <QAbstractListModel>
#include <QString>
#include <QVector>
#include <QUrl>

struct ImageData
{
  int id = -1;
  QString filename;
  QUrl url;
  QUrl thumbnail;
  int width = 0;
  int height = 0;
  float rating = 0.0f;
  QStringList tags;
  QString description;

  // Explicit constructor to ensure everything is initialized
  ImageData() {}
  ImageData(int id, QString fn, QUrl u, QUrl th, int w, int h, float r, QStringList t, QString d)
      : id(id), filename(fn), url(u), thumbnail(th), width(w), height(h), rating(r), tags(t), description(d) {}
};

class ImageModel : public QAbstractListModel
{
  Q_OBJECT
  Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
  // ... existing roles ...
  enum ImageRoles
  {
    IdRole = Qt::UserRole + 1,
    FilenameRole,
    UrlRole,
    ThumbnailRole,
    WidthRole,
    HeightRole,
    RatingRole,
    TagsRole,
    DescriptionRole
  };

  explicit ImageModel(QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;

  int count() const;

  Q_INVOKABLE void loadImages();
  Q_INVOKABLE void addDummyData();

  Q_INVOKABLE QVariantMap get(int row) const;

signals:
  void countChanged();

private:
  QVector<ImageData> m_images;
};

#endif // IMAGEMODEL_H
