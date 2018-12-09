#include "config_setter.h"
#include <QDebug>

ConfigSetter::ConfigSetter(QObject *parent) : QObject(parent)
{
    m_settings = new QSettings("Siriuso", "AiSound", this);
    qInfo() << "Settings file path: " << m_settings->fileName();
}

void ConfigSetter::setValue(const QString &group, const QString &key, const QVariant &value)
{
    m_settings->beginGroup(group);
    m_settings->setValue(key, value);
    m_settings->endGroup();
}

QVariant ConfigSetter::getValue(const QString &group, const QString &key, const QVariant &default_value)
{
    m_settings->beginGroup(group);
    auto value = m_settings->value(key, default_value);
    m_settings->endGroup();
    return value;
}
