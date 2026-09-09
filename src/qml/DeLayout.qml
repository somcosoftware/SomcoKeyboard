import QtQuick 2.0
import QtQuick.Layouts 1.15

ColumnLayout {
    id: root

    property var inputPanel

    spacing: root.inputPanel.spacing

    RowLayout {
        spacing: root.inputPanel.spacing
        Key {
            btnKey: Qt.Key_Q
            text: "q"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_W
            text: "w"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_E
            text: "e"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_R
            text: "r"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_T
            text: "t"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Z
            text: "z"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_U
            text: "u"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_I
            text: "i"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_O
            text: "o"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_P
            text: "p"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Udiaeresis
            text: "ü"
            inputPanelRef: root.inputPanel
        }

        BackspaceKey {
            inputPanelRef: root.inputPanel
        }
    }

    RowLayout {
        spacing: root.inputPanel.spacing
        Key {
            objectName: "" // invisible key to align the row
            enabled: false
            weight: 19
            functionKey: true
            showPreview: false
            btnBackground: "transparent"
        }

        Key {
            btnKey: Qt.Key_A
            text: "a"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_S
            text: "s"
            alternativeKeys: "ß"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_D
            text: "d"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_F
            text: "f"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_G
            text: "g"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_H
            text: "h"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_J
            text: "j"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_K
            text: "k"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_L
            text: "l"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Odiaeresis
            text: "ö"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Adiaeresis
            text: "ä"
            inputPanelRef: root.inputPanel
        }

        EnterKey {
            inputPanelRef: root.inputPanel
        }
    }

    RowLayout {
        spacing: root.inputPanel.spacing

        ShiftKey {
            objectName: root.inputPanel.objectName + "Key_Shift_Left"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Y
            text: "y"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_X
            text: "x"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_C
            text: "c"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_V
            text: "v"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_B
            text: "b"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_N
            text: "n"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_M
            text: "m"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Comma
            text: ","
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Period
            text: "."
            inputPanelRef: root.inputPanel
        }

        ShiftKey {
            objectName: root.inputPanel.objectName + "Key_Shift_Right"
            inputPanelRef: root.inputPanel
        }
    }

    RowLayout {
        spacing: root.inputPanel.spacing

        LanguageKey {
            inputPanelRef: root.inputPanel
        }

        SpaceKey {
            inputPanelRef: root.inputPanel
        }

        SymbolKey {
            inputPanelRef: root.inputPanel
        }

        HideKey {
            inputPanelRef: root.inputPanel
        }
    }
}
