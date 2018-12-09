#ifndef CONFIG_SETTER_H
#define CONFIG_SETTER_H

#include <QObject>
#include <QSettings>

class ConfigSetter : public QObject
{
    Q_OBJECT
public:
    explicit ConfigSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setValue(const QString &group, const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant getValue(const QString &group, const QString &key, const QVariant &default_value);

private:
    QSettings *m_settings;
};

#endif // CONFIG_SETTER_H
