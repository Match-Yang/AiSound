import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    title: qsTr("AiSound")

    Pane {
        width: parent.width
        height: 50
        anchors.top: parent.top
    }

    ConfigPage {
        width: parent.width
        height: parent.height
        x: 0
        y: 0
    }
}
