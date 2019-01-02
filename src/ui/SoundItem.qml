import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Pane {
    id: root
    Material.elevation: 6
//    horizontalPadding: 3
//    verticalPadding: 3
    height: 40
    width: {
        if (text.length < 10) {
            return parent.width * 0.3
        } else if (text.length < 20) {
            return parent.width * 0.5
        } else if (text.length < 30) {
            return parent.width * 0.6
        } else if (text.length < 50) {
            return parent.width * 0.7
        } else {
            return parent.width * 0.85
        }
    }

    states: [
        State {
            name: "processing"
            PropertyChanges { target: pillarCanvas; color: "#CFD2D5" }
            PropertyChanges { target: pillarRepainTimer; running: true }
        },
        State {
            name: "ready"
            PropertyChanges { target: pillarCanvas; color: "#1D74F6" }
            PropertyChanges { target: pillarRepainTimer; running: false }
        },
        State {
            name: "playing"
            PropertyChanges { target: pillarCanvas; color: "#1D74F6" }
            PropertyChanges { target: pillarRepainTimer; running: true }
        },
        State {
            name: "error"
            PropertyChanges { target: pillarCanvas; color: "#DF3E7B" }
            PropertyChanges { target: pillarRepainTimer; running: false }
        }
    ]

    readonly property real _pillarSize: 4
    property var _pillarList: []
    property var _pillarListDirection: []
    property string text: ""

    onTextChanged: {
        if (text != "") {
            root.state = "processing"
            ttsOnline.processTtsOnline(text)
        }
    }

    onWidthChanged: {
        _pillarListDirection = []
        var pillarCount = width / _pillarSize / 2
        var list = []
        for (var i = 0; i < pillarCount; i ++) {
            list.push(Math.random())
            _pillarListDirection.push(true)
        }
        _pillarList = list
        pillarCanvas.update()
    }

    Connections {
        target: ttsOnline
        onOnProcessTtsOnlineFinish: {
            if (text !== root.text) {
                return
            }

            console.log("Process finished", text, error_code)
            if (error_code === 0) {
                root.state = "ready"
            } else {
                root.state = "error"
            }
            pillarCanvas.requestPaint()
        }
    }

    Canvas {
        id: pillarCanvas
        anchors.fill: parent
        height: parent.height
        width: parent.width
        property string color: "#CFD2D5"
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, pillarCanvas.width, pillarCanvas.height);
            ctx.strokeStyle = pillarCanvas.color
            ctx.lineWidth = _pillarSize
            ctx.lineCap = "round"
            for (var i = 0; i < _pillarList.length; i ++) {
                var x = i * _pillarSize * 2;
                var h = pillarCanvas.height * _pillarList[i];
                var top = (pillarCanvas.height - h) / 2;
                var bottom = h + top;

                ctx.beginPath();
                ctx.lineTo(x, top);
                ctx.lineTo(x, bottom);
                ctx.stroke();
                ctx.closePath();
            }
        }
    }

    Timer {
        id: pillarRepainTimer

        onTriggered: {
            for (var i = 0; i < _pillarList.length; i ++) {
                var value = _pillarList[i];
                if (_pillarListDirection[i]) {
                    value += 0.05;
                    if (value >= 1.0) {
                        _pillarListDirection[i] = false
                    }
                } else {
                    value -= 0.05;
                    if (value <= 0) {
                        _pillarListDirection[i] = true
                    }
                }

                _pillarList[i] = value
            }
            pillarCanvas.requestPaint()
        }

        running: true
        repeat: true
        interval: 50
    }
}
