#include "tts_online.h"

#include <QDebug>
#include <QFile>
#include <QThread>

namespace {

struct WavePcmHdr {
    char            riff[4];                // = "RIFF"
    int             size_8;                 // = FileSize - 8
    char            wave[4];                // = "WAVE"
    char            fmt[4];                 // = "fmt "
    int             fmt_size;               // = 下一个结构体的大小 : 16

    short int       format_tag;             // = PCM : 1
    short int       channels;               // = 通道数 : 1
    int             samples_per_sec;        // = 采样率 : 8000 | 6000 | 11025 | 16000
    int             avg_bytes_per_sec;      // = 每秒字节数 : samples_per_sec * bits_per_sample / 8
    short int       block_align;            // = 每采样点字节数 : wBitsPerSample / 8
    short int       bits_per_sample;        // = 量化比特数: 8 | 16

    char            data[4];                // = "data";
    int             data_size;              // = 纯数据长度 : FileSize - 44
};

const WavePcmHdr kDefaultWavHdr = {
    { 'R', 'I', 'F', 'F' },
    0,
    {'W', 'A', 'V', 'E'},
    {'f', 'm', 't', ' '},
    16,
    1,
    1,
    16000,
    32000,
    2,
    16,
    {'d', 'a', 't', 'a'},
    0
};

} // namespace

TtsOnline::TtsOnline(QObject *parent) : QObject(parent)
{
    setAppId("5c0c936a");
    setRdn(2);
    setVolume(50);
    setPitch(50);
    setSpeed(50);
    setSampleRate(16000);
    setVoiceName("xiaoyan");
    processTtsOnline("添加wav音频头，使用采样率为16000");
}

TtsOnline::~TtsOnline()
{
    MSPLogout(); //退出登录
}

void TtsOnline::processTtsOnline(const QString &text) const
{
    qDebug() << textToSpeech(text);
}

const QString TtsOnline::getLoginParams() const
{
    return QString("appid = %1, work_dir = .").arg(m_appId);
}

const QString TtsOnline::getSessionBeginParams() const
{
    return QString("voice_name = %1, text_encoding = utf8, sample_rate = %2, speed = %3, volume = %4, pitch = %5, rdn = %6")
            .arg(m_voiceName).arg(m_sampleRate).arg(m_speed).arg(m_volume).arg(m_pitch).arg(m_rdn);
}

int TtsOnline::textToSpeech(const QString &text) const
{
    int          ret          = -1;
    const char*  sessionID    = nullptr;
    unsigned int audio_len    = 0;
    WavePcmHdr wav_hdr      = kDefaultWavHdr;
    int          synth_status = MSP_TTS_FLAG_STILL_HAVE_DATA;

    if (text.isEmpty()) {
        qWarning() << "Text is empty!";
        return ret;
    }

    // TODO use specify path
    QFile file(QString("/tmp/%1.wav").arg(text));
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Open file to write failed: " << file.errorString();
        return ret;
    }
    /* 开始合成 */
    sessionID = QTTSSessionBegin(getSessionBeginParams().toUtf8().constData(), &ret);
    if (MSP_SUCCESS != ret) {
        qWarning() << "QTTSSessionBegin failed, error code: " << ret;
        file.close();
        return ret;
    }
    ret = QTTSTextPut(sessionID, text.toUtf8().constData(), static_cast<unsigned int>(strlen(text.toUtf8().constData())), nullptr);
    if (MSP_SUCCESS != ret) {
        qWarning() << "QTTSTextPut failed, error code: " << ret;
        QTTSSessionEnd(sessionID, "TextPutError");
        file.close();
        return ret;
    }
    file.write(reinterpret_cast<char*>(&wav_hdr), sizeof (wav_hdr));//添加wav音频头，使用采样率为16000
    while (true) {
        /* 获取合成音频 */
        const void* data = QTTSAudioGet(sessionID, &audio_len, &synth_status, &ret);
        if (MSP_SUCCESS != ret)
            break;
        if (nullptr != data) {
            file.write(reinterpret_cast<const char *>(data), audio_len);
            wav_hdr.data_size += audio_len; //计算data_size大小
        }
        if (MSP_TTS_FLAG_DATA_END == synth_status)
            break;
        QThread::usleep(15 * 1000);//防止频繁占用CPU
    }
    if (MSP_SUCCESS != ret) {
        qWarning() << "QTTSAudioGet failed, error code: " << ret;
        QTTSSessionEnd(sessionID, "AudioGetError");
        file.close();
        return ret;
    }
    /* 修正wav文件头数据的大小 */
    wav_hdr.size_8 += wav_hdr.data_size + static_cast<int>((sizeof(wav_hdr) - 8)) ;

    /* 将修正过的数据写回文件头部,音频文件为wav格式 */
    file.seek(4);
    file.write(reinterpret_cast<char *>(&wav_hdr.size_8), sizeof (wav_hdr.size_8)); //写入size_8的值
    file.seek(40);//将文件指针偏移到存储data_size值的位置
    file.write(reinterpret_cast<char *>(&wav_hdr.data_size), sizeof (wav_hdr.data_size)); //写入data_size的值
    file.close();
    // 合成完毕
    ret = QTTSSessionEnd(sessionID, "Normal");
    if (MSP_SUCCESS != ret) {
        qWarning() << "QTTSSessionEnd failed, error code: " << ret;
    }

    return ret;
}

void TtsOnline::tryLogin()
{
    if (m_appId.isEmpty()) {
        return;
    }
    MSPLogout(); //退出登录
    int ret = MSPLogin(nullptr, nullptr, getLoginParams().toUtf8().constData());
    if (ret != MSP_SUCCESS) {
        qWarning() << "Login failed: " << ret;
    }
}
