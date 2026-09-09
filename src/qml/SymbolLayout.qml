import QtQuick 2.0
import QtQuick.Layouts 1.15
import SomcoKeyboard 1.0

Item {
    id: root
    property var inputPanel
    property bool secondPage

    onVisibleChanged: {
        if (!visible)
            secondPage = false
    }

    ColumnLayout {
        id: page1

        anchors.fill: parent
        visible: !root.secondPage
        spacing: root.inputPanel.spacing

        RowLayout {
            spacing: root.inputPanel.spacing

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

            Key {
                btnKey: Qt.Key_0
                text: "0"
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
                btnKey: Qt.Key_At
                text: "@"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_NumberSign
                text: "#"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Percent
                text: "%"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Ampersand
                text: "&"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Asterisk
                text: "*"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Minus
                text: "-"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Plus
                text: "+"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_ParenLeft
                text: "("
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_ParenRight
                text: ")"
                inputPanelRef: root.inputPanel
            }

            EnterKey {
                inputPanelRef: root.inputPanel
            }
        }

        RowLayout {
            spacing: root.inputPanel.spacing
            Key {
                weight: 112
                btnDisplayedText: "1/2"
                showPreview: false
                functionKey: true
                onClicked: root.secondPage = !root.secondPage
            }

            Key {
                btnKey: Qt.Key_Exclam
                text: "!"
                alternativeKeys: "¡"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_QuoteDbl
                text: '"'
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Less
                text: "<"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Greater
                text: ">"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Apostrophe
                text: "'"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Colon
                text: ":"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Semicolon
                text: ";"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Slash
                text: "/"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Question
                text: "?"
                alternativeKeys: "¿"
                inputPanelRef: root.inputPanel
            }

            Key {
                weight: 112
                btnDisplayedText: "1/2"
                showPreview: false
                functionKey: true
                onClicked: root.secondPage = !root.secondPage
            }
        }

        RowLayout {
            spacing: root.inputPanel.spacing

            Key {
                weight: 112
                functionKey: true
                showPreview: false
                btnBackground: "transparent"
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

    ColumnLayout {
        id: page2

        anchors.fill: parent
        visible: root.secondPage
        spacing: root.inputPanel.spacing

        RowLayout {
            spacing: root.inputPanel.spacing

            Key {
                btnKey: Qt.Key_AsciiTilde
                text: "~"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Agrave
                text: "`"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Bar
                text: "|"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_periodcentered
                text: "·"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 8730
                text: "√"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_division
                text: "÷"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_multiply
                text: "×"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_onehalf
                text: "½"
                alternativeKeys: "¼⅓¾⅞"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_BraceLeft
                text: "{"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_BraceRight
                text: "}"
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
                btnKey: Qt.Key_Dollar
                text: "$"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 8364
                text: "€"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 194
                text: "£"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 162
                text: "¢"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 165
                text: "¥"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Equal
                text: "="
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_section
                text: "§"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_BracketLeft
                text: "["
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_BracketRight
                text: "]"
                inputPanelRef: root.inputPanel
            }

            EnterKey {
                inputPanelRef: root.inputPanel
            }
        }

        RowLayout {
            spacing: root.inputPanel.spacing

            Key {
                weight: 112
                btnDisplayedText: "2/2"
                showPreview: false
                functionKey: true
                onClicked: root.secondPage = !root.secondPage
            }

            Key {
                btnKey: Qt.Key_Underscore
                text: "_"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 8482
                text: '™'
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 174
                text: '®'
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_guillemotleft
                text: '«'
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_guillemotright
                text: '»'
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 8220
                text: '“'
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: 8221
                text: '”'
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_Backslash
                text: "\\"
                inputPanelRef: root.inputPanel
            }

            Key {
                btnKey: Qt.Key_AsciiCircum
                text: "^"
                inputPanelRef: root.inputPanel
            }

            Key {
                weight: 112
                btnDisplayedText: "2/2"
                showPreview: false
                functionKey: true
                onClicked: root.secondPage = !root.secondPage
            }
        }

        RowLayout {
            spacing: root.inputPanel.spacing

            Key {
                enabled: false
                weight: 112
                functionKey: true
                showPreview: false
                btnBackground: "transparent"
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
}
