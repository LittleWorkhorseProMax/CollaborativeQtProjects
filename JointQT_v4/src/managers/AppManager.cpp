#include "AppManager.h"

AppManager::AppManager(QObject *parent) : QObject(parent)
{
  m_imageModel = new ImageModel(this);
}

ImageModel *AppManager::imageModel() const
{
  return m_imageModel;
}
