import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id: root
    property alias title: title_label.text
    property alias text: value_text.text
    property alias buttonText: button.text

    signal accepted()
    signal clicked()

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
        width: parent.width - 10 - button.width
        height: 40
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        onAccepted: root.accepted()
    }

    Button {
        id: button
        width: 70
        height: 45
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onClicked: root.clicked()
    }
}
