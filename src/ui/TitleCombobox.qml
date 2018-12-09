import QtQuick 2.12
import QtQuick.Controls 2.4

Item {
    property alias title: title_label.text
    property alias currentIndex: value_combobox.currentIndex
    property alias currentText: value_combobox.currentText
    property alias model: value_combobox.model
    property alias delegate: value_combobox.delegate
    property alias combobox: value_combobox
    property alias indicator: value_combobox.indicator
    property alias contentItem: value_combobox.contentItem

    Label {
        id: title_label
        width: parent.width
        height: 30
        color:  "#3c4153"
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
    }

    ComboBox {
        id: value_combobox
        width: parent.width - 10
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
}
