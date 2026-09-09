import QtQuick 2.0
import QtQuick.Layouts 1.15
import SomcoKeyboard 1.0

ColumnLayout {
    id: root

    property var inputPanel

    spacing: root.inputPanel.spacing

    GridLayout {
        columnSpacing: root.inputPanel.spacing
        rowSpacing: root.inputPanel.spacing

        Layout.fillWidth: false
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: height

        columns: 4

        Key {
            btnKey: Qt.Key_7
            text: "7"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_8
            text: "8"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_9
            text: "9"
            inputPanelRef: root.inputPanel
        }

        BackspaceKey {
            inputPanelRef: root.inputPanel
            weight: 70
        }

        Key {
            btnKey: Qt.Key_4
            text: "4"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_5
            text: "5"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_6
            text: "6"
            inputPanelRef: root.inputPanel
        }

        EnterKey {
            inputPanelRef: root.inputPanel
            Layout.rowSpan: 2
            btnDisplayedText: ""
            weight: 70
        }

        Key {
            btnKey: Qt.Key_1
            text: "1"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_2
            text: "2"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_3
            text: "3"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.locale(
                        ).decimalPoint === "," ? Qt.Key_Comma : Qt.Key_Period
            text: Qt.locale().decimalPoint === "," ? "," : "."
            alternativeKeys: Qt.locale().decimalPoint === "," ? "." : ","
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_0
            text: "0"
            inputPanelRef: root.inputPanel
        }

        HideKey {
            Layout.columnSpan: 2
            inputPanelRef: root.inputPanel
        }
    }
}
