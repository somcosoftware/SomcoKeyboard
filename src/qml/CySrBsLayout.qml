import QtQuick 2.0
import QtQuick.Layouts 1.15

ColumnLayout {
    id: root

    property var inputPanel

    spacing: root.inputPanel.spacing

    RowLayout {
        spacing: root.inputPanel.spacing

        Key {
            text: "љ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "Њ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "е"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "р"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "т"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "з"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "у"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "и"
            alternativeKeys: "ίϊΐ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "о"
            alternativeKeys: "ό"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "п"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ш"
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
            text: "а"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "с"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "д"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ф"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "г"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "х"
            alternativeKeys: "ή"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ј"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "к"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "л"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ч"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ћ"
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
            text: "џ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ц"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "в"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "б"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "н"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "м"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ђ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ж"
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
