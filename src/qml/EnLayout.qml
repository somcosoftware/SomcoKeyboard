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
            alternativeKeys: "êëèé"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_R
            text: "r"
            alternativeKeys: "ŕř"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_T
            text: "t"
            alternativeKeys: "ţŧť"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_Y
            text: "y"
            alternativeKeys: "ÿýŷ"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_U
            text: "u"
            alternativeKeys: "űūũûüùú"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_I
            text: "i"
            alternativeKeys: "îïīĩìí"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_O
            text: "o"
            alternativeKeys: "œøõôöòó"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_P
            text: "p"
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
            alternativeKeys: "äåãâàá"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_S
            text: "s"
            alternativeKeys: "šşś"
            inputPanelRef: root.inputPanel
        }

        Key {
            btnKey: Qt.Key_D
            text: "d"
            alternativeKeys: "đď"
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
            alternativeKeys: "ġģĝğ"
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
            alternativeKeys: "ĺŀłļľ"
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
            btnKey: Qt.Key_Z
            text: "z"
            alternativeKeys: "žż"
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
            alternativeKeys: "çċčć"
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
            alternativeKeys: "ņńň"
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
