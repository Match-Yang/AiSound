import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Pane {
    ListView {
        id: sound_item_list
        model: sound_model
        verticalLayoutDirection: ListView.BottomToTop
        width: input_area.width
        height: parent.height - input_area.height
        anchors.topMargin: 10
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: input_area.top
        anchors.bottomMargin: 10
        spacing: 10
        delegate: SoundItem {
            text: sourceText
        }

        ListModel {
            id: sound_model
        }
    }

    Pane {
        id: input_area
        Material.elevation: 6
        width: parent.width * 0.95
        height: 55
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        TextInput {
            clip: true
            anchors.fill: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            onAccepted: {
                if (text !== "") {
                    sound_model.insert(0, {sourceText: text})
                    text = ""
                }
            }
        }
    }
}
