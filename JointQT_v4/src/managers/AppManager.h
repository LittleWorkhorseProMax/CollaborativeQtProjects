#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>
#include "../models/ImageModel.h"

class AppManager : public QObject
{
  Q_OBJECT
  Q_PROPERTY(ImageModel *imageModel READ imageModel CONSTANT)

public:
  explicit AppManager(QObject *parent = nullptr);
  ImageModel *imageModel() const;

private:
  ImageModel *m_imageModel;
};

#endif // APPMANAGER_H
