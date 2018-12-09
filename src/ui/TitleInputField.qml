import QtQuick 2.12
import QtQuick.Controls 2.4

Item {
    property alias title: title_label.text
    property alias text: value_text.text

    Label {
        id: title_label
        width: parent.width
        height: 30
        color:  "#3c4153"
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
    }

    TextField {
        id: value_text
        width: parent.width - 10
        height: 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

}
