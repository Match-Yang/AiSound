#ifndef TTS_ONLINE_H
#define TTS_ONLINE_H

#include <QObject>


#include "qtts.h"
#include "msp_cmn.h"
#include "msp_errors.h"

class TtsOnline : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appId READ getAppId WRITE setAppId NOTIFY onAppIdChanged)
    Q_PROPERTY(int rdn READ getRdn WRITE setRdn NOTIFY onRdnChanged)
    Q_PROPERTY(int volume READ getVolume WRITE setVolume NOTIFY onVolumeChanged)
    Q_PROPERTY(int pitch READ getPitch WRITE setPitch NOTIFY onPitchChanged)
    Q_PROPERTY(int speed READ getSpeed WRITE setSpeed NOTIFY onSpeedChanged)
    Q_PROPERTY(int sampleRate READ getSampleRate WRITE setSampleRate NOTIFY onSampleRateChanged)
    Q_PROPERTY(QString voiceName READ getVoiceName WRITE setVoiceName NOTIFY onVoiceNameChanged)

public:
    explicit TtsOnline(QObject *parent = nullptr);
    ~TtsOnline();
    Q_INVOKABLE void processTtsOnline(const QString &text) const;

    QString getAppId() const
    {
        return m_appId;
    }

    int getRdn() const
    {
        return m_rdn;
    }

    int getVolume() const
    {
        return m_volume;
    }

    int getPitch() const
    {
        return m_pitch;
    }

    int getSpeed() const
    {
        return m_speed;
    }

    int getSampleRate() const
    {
        return m_sampleRate;
    }

    QString getVoiceName() const
    {
        return m_voiceName;
    }

signals:
    void onProcessTtsOnlineFinish(const QString &text, int error_code);

    void onAppIdChanged(QString appId);

    void onRdnChanged(int rdn);

    void onVolumeChanged(int volume);

    void onPitchChanged(int pitch);

    void onSpeedChanged(int speed);

    void onSampleRateChanged(int sampleRate);

    void onVoiceNameChanged(QString voiceName);

public slots:
    void setAppId(QString appId)
    {
        if (m_appId == appId)
            return;

        m_appId = appId;
        emit onAppIdChanged(m_appId);
        tryLogin();
    }
    /**
     * @brief setRdn
     * 合成音频数字发音，支持参数，
     * 0 数值优先,
     * 1 完全数值,
     * 2 完全字符串，
     * 3 字符串优先，
     * 默认值：0
     * @param rdn
     */
    void setRdn(int rdn)
    {
        if (m_rdn == rdn)
            return;

        m_rdn = rdn;
        emit onRdnChanged(m_rdn);
    }
    /**
     * @brief setVolume
     * 合成音频的音量，
     * 取值范围：[0,100]，数值越大音量越大。
     * 默认值：50
     * @param volume
     */
    void setVolume(int volume)
    {
        if (m_volume == volume)
            return;

        m_volume = volume;
        emit onVolumeChanged(m_volume);
    }
    /**
     * @brief setPitch
     * 合成音频的音调，
     * 取值范围：[0,100]，数值越大音调越高。
     * 默认值：50
     * @param pitch
     */
    void setPitch(int pitch)
    {
        if (m_pitch == pitch)
            return;

        m_pitch = pitch;
        emit onPitchChanged(m_pitch);
    }
    /**
     * @brief setSpeed
     * 合成音频对应的语速，
     * 取值范围：[0,100]，数值越大语速越快。
     * 默认值：50
     * @param speed
     */
    void setSpeed(int speed)
    {
        if (m_speed == speed)
            return;

        m_speed = speed;
        emit onSpeedChanged(m_speed);
    }
    /**
     * @brief setSampleRate
     * 合成音频采样率，支持参数，16000，8000，默认为16000
     * @param sampleRate
     */
    void setSampleRate(int sampleRate)
    {
        if (m_sampleRate == sampleRate)
            return;

        m_sampleRate = sampleRate;
        emit onSampleRateChanged(m_sampleRate);
    }
    /**
     * @brief setVoiceName
     * 不同的发音人代表了不同的音色，
     * 如男声、女声、童声等，详细请参照《发音人列表》
     * @param voiceName
     */
    void setVoiceName(QString voiceName)
    {
        if (m_voiceName == voiceName)
            return;

        m_voiceName = voiceName;
        emit onVoiceNameChanged(m_voiceName);
    }

private:
    const QString getLoginParams() const;
    const QString getSessionBeginParams() const;
    int textToSpeech(const QString &text) const;
    /**
     * @brief tryLogin
     * Try to login when appid is changed
     */
    void tryLogin();

private:
    QString m_appId;

    int m_rdn;

    int m_volume;

    int m_pitch;

    int m_speed;

    int m_sampleRate;
    QString m_voiceName;
};

#endif // TTS_ONLINE_H
