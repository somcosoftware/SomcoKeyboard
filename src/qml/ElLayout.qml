import QtQuick 2.0
import QtQuick.Layouts 1.15

ColumnLayout {
    id: root
    property var inputPanel

    spacing: root.inputPanel.spacing

    RowLayout {
        spacing: root.inputPanel.spacing

        Key {
            text: "ς"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ε"
            alternativeKeys: "έ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ρ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "τ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ψ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "υ"
            alternativeKeys: "ύϋΰ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "θ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ι"
            alternativeKeys: "ίϊΐ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ο"
            alternativeKeys: "ό"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "π"
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
            text: "α"
            alternativeKeys: "ά"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "σ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "δ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "φ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "γ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "η"
            alternativeKeys: "ή"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ξ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "κ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "λ"
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
            text: "ζ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "χ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ψ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ω"
            alternativeKeys: "ώ"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "β"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "ν"
            inputPanelRef: root.inputPanel
        }

        Key {
            text: "μ"
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
            alternativeKeys: "!.;?"
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
