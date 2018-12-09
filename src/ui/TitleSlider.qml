import QtQuick 2.0
import QtQuick.Controls 2.4

Item {

    property alias from: value_slider.from
    property alias to: value_slider.to
    property alias value: value_slider.value
    property alias title: title_label.text

    Label {
        id: title_label
        width: parent.width
        height: 30
        color:  "#3c4153"
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
    }

    Slider {
        id: value_slider
        width: parent.width
        height: 30
        anchors.bottom: parent.bottom
    }

    Label {
        width: 100
        height: 20
        color: "#8b8e97"
        text: value_slider.from
        anchors.leftMargin: 5
        anchors.left: parent.left
        anchors.bottom: value_slider.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignLeft
    }


    Label {
        width: 100
        height: 20
        color: "#8b8e97"
        text: Math.round(value_slider.value)
        anchors.horizontalCenter: value_slider.horizontalCenter
        anchors.bottom: value_slider.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
    }

    Label {
        width: 100
        height: 20
        color: "#8b8e97"
        text: value_slider.to
        anchors.rightMargin: 5
        anchors.right: parent.right
        anchors.bottom: value_slider.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignRight
    }
}
