import QtQuick 2.9
import QtQuick.Controls 2.2
import Qt.labs.platform 1.0

Item {
    id: root
    readonly property string titleColor: "#3c4153"
    readonly property string onlineTtsGroup: "kOnlineTtsGroup"

    ScrollView {
        width: parent.width - 100
        height: parent.height
        clip: true

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOff
        }

        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            width: root.width - 100
            height: childrenRect.height
            spacing: 20
//            anchors.top: parent.top
//            anchors.topMargin: 40

            Item {
                // for spacing
                width: parent.width
                height: 10
            }
            Label {
                id: title_label
                text: qsTr("Settings the params for tts.")
                font.pixelSize: 20
                color: titleColor
            }

            Item {
                // for spacing
                height: 1
                width: parent.width
            }

            TitleInputField {
                title: "AppId"
                buttonText: "登录"
                width: parent.width
                height: 70

                function updateAppId() {
                    if (text === "") {
                        return;
                    }

                    configSetter.setValue(onlineTtsGroup, "appId", text)
                    ttsOnline.appId = text
                }

                onAccepted: updateAppId()
                onClicked: updateAppId()
                text: configSetter.getValue(onlineTtsGroup, "appId", "")

                Component.onCompleted: ttsOnline.appId = text
            }

            TitleInputField {
                id: tif
                title: "存储目录"
                buttonText: "选择"
                width: parent.width
                height: 70

                function updateStorageDir() {
                    if (text === "") {
                        return;
                    }

                    configSetter.setValue(onlineTtsGroup, "storageDir", text)
                    ttsOnline.storagePath = text
                }

                onAccepted: updateStorageDir()
                onClicked: fileDialog.open()
                text: configSetter.getValue(onlineTtsGroup, "storageDir", "")
                Component.onCompleted: ttsOnline.storagePath = text

                FolderDialog {
                    id: fileDialog
                    onAccepted: {
                        var path = folder.toString().replace("file://", "")
                        configSetter.setValue(onlineTtsGroup, "storageDir", path)
                        ttsOnline.storagePath = path
                        tif.text = path
                    }

                    folder: StandardPaths.writableLocation(StandardPaths.HomeLocation)
                }
            }

            TitleCombobox {
                id: name_cb
                property var nameList: [
                    {"name":"小燕", "language": "普通话", "voiceType": "青年女声", "voiceValue":"xiaoyan"},
                    {"name":"燕平", "language": "普通话", "voiceType": "青年女声", "voiceValue":"yanping"},
                    {"name":"晓峰", "language": "普通话", "voiceType": "青年男声", "voiceValue":"xiaofeng"},
                    {"name":"晓婧", "language": "普通话", "voiceType": "青年女声", "voiceValue":"jinger"},
                    {"name":"唐老鸭", "language": "普通话", "voiceType": "卡通", "voiceValue":"donaldduck"},
                    {"name":"许小宝", "language": "普通话", "voiceType": "童声", "voiceValue":"babyxu"},
                    {"name":"楠楠", "language": "普通话", "voiceType": "童声", "voiceValue":"nannan"},
                    {"name":"晓梦", "language": "普通话", "voiceType": "青年女声", "voiceValue":"xiaomeng"},
                    {"name":"晓琳", "language": "台湾普通话", "voiceType": "青年女声", "voiceValue":"xiaolin"},
                    {"name":"晓倩", "language": "东北话", "voiceType": "青年女声", "voiceValue":"xiaoqian"},
                    {"name":"晓蓉", "language": "四川话", "voiceType": "青年女声", "voiceValue":"xiaorong"},
                    {"name":"小坤", "language": "河南话", "voiceType": "青年男声", "voiceValue":"xiaokun"},
                    {"name":"小强", "language": "湖南话", "voiceType": "青年男声", "voiceValue":"xiaoqiang"},
                    {"name":"晓美", "language": "粤语", "voiceType": "青年女声", "voiceValue":"xiaomei"},
                    {"name":"大龙", "language": "粤语", "voiceType": "青年男声", "voiceValue":"dalong"},
                    {"name":"Catherine", "language": "美式纯英文", "voiceType": "青年女声", "voiceValue":"catherine"},
                    {"name":"John", "language": "美式纯英文", "voiceType": "青年男声", "voiceValue":"john"}
                ]

                title: "发音人"
                width: parent.width
                height: 80
                model: nameList
                delegate: ItemDelegate {
                    width: name_cb.combobox.width
                    contentItem: Text {
                        text: modelData.name + " " +  modelData.language + " " + modelData.voiceType
                        color: titleColor
                        font: name_cb.combobox.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: name_cb.combobox.highlightedIndex === index
                    onClicked: {
                        name_cb.currentIndex = index
                    }
                }

                indicator: Canvas {
                    id: canvas
                    x: name_cb.combobox.width - width - name_cb.combobox.rightPadding
                    y: name_cb.combobox.topPadding + (name_cb.combobox.availableHeight - height) / 2
                    width: 12
                    height: 5
                    contextType: "2d"

                    Connections {
                        target: name_cb.combobox
                        onPressedChanged: canvas.requestPaint()
                    }

                    onPaint: {
                        context.reset();
                        context.moveTo(0, 0);
                        context.lineTo(width, 0);
                        context.lineTo(width / 2, height);
                        context.closePath();
                        context.fillStyle = titleColor;
                        context.fill();
                    }
                }

                contentItem: Text {
                    leftPadding: 10
                    rightPadding: name_cb.combobox.indicator.width + name_cb.combobox.spacing

                    text: name_cb.combobox.displayText
                    font: name_cb.combobox.font
                    color: titleColor
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onCurrentIndexChanged: {
                    ttsOnline.voiceName = nameList[currentIndex].voiceValue
                    configSetter.setValue(onlineTtsGroup, "voiceNameIndex", currentIndex)
                    name_cb.combobox.displayText = nameList[currentIndex].name + " " +  nameList[currentIndex].language + " " + nameList[currentIndex].voiceType
                }
                currentIndex: configSetter.getValue(onlineTtsGroup, "voiceNameIndex", 0)
            }

            TitleCombobox {
                title: "合成音频数字发音"
                width: parent.width
                height: 80
                model: ["数值优先", "完全数值", "完全字符串", "字符串优先"]
                onCurrentIndexChanged: {
                    ttsOnline.rdn = currentIndex
                    configSetter.setValue(onlineTtsGroup, "rdnIndex", currentIndex)
                }
                currentIndex: configSetter.getValue(onlineTtsGroup, "rdnIndex", 0)
            }

            TitleSlider {
                title: "合成音频音量"
                width: parent.width
                height: 80
                from: 0
                to: 100
                onValueChanged: {
                    ttsOnline.volume = Math.round(value)
                    configSetter.setValue(onlineTtsGroup, "volume", ttsOnline.volume)
                }
                value: configSetter.getValue(onlineTtsGroup, "volume", 50)
            }

            TitleSlider {
                title: "合成音频音调"
                width: parent.width
                height: 80
                from: 0
                to: 100
                onValueChanged: {
                    ttsOnline.pitch = Math.round(value)
                    configSetter.setValue(onlineTtsGroup, "pitch", ttsOnline.pitch)
                }
                value: configSetter.getValue(onlineTtsGroup, "pitch", 50)
            }

            TitleSlider {
                title: "合成音频对应语速"
                width: parent.width
                height: 80
                from: 0
                to: 100
                onValueChanged: {
                    ttsOnline.speed = Math.round(value)
                    configSetter.setValue(onlineTtsGroup, "speed", ttsOnline.speed)
                }
                value: configSetter.getValue(onlineTtsGroup, "speed", 50)
            }

            TitleCombobox {
                title: "合成音频采样率"
                width: parent.width
                height: 80
                model: sampleRateList
                property var sampleRateList: ["16000", "8000"]
                onCurrentIndexChanged: {
                    ttsOnline.sampleRate = sampleRateList[currentIndex]
                    configSetter.setValue(onlineTtsGroup, "sampleRateIndex", currentIndex)
                }
                currentIndex: configSetter.getValue(onlineTtsGroup, "sampleRateIndex", 0)
            }
        }

    }
}
