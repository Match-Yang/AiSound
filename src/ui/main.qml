import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    x: 0
    y: 0
    title: qsTr("AiSound")


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        VoicePage {
//            width: parent.width
//            height: 50
//            anchors.top: parent.top

        }

        ConfigPage {
            id: config_page
//            width: parent.width
//            height: parent.height
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("生成")
        }
        TabButton {
            text: qsTr("设置")
        }
    }
}
