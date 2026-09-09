import QtQuick 2.0
import QtQuick.Layouts 1.15
import SomcoKeyboard 1.0

Item {
    id: root

    required property var inputPanel
    required property var keyboardRect

    property var alternativeKeys: []

    function open(keybutton) {
        alternativeKeys = keybutton.alternativeKeys
        width = (keybutton.width) * (alternativeKeys.length) + inputPanel.margins
                * 2 + ((alternativeKeys.length - 1) * inputPanel.spacing)
        height = keybutton.height + inputPanel.margins * 2
        var KeyButtonGlobalLeft = keybutton.mapToItem(inputPanel, 0, 0).x
        var KeyButtonGlobalTop = keybutton.mapToItem(inputPanel, 0, 0).y
        var PopupGlobalLeft = KeyButtonGlobalLeft - (width - keybutton.width) / 2
        var PopupGlobalTop = KeyButtonGlobalTop - height - keyboardRect.height / 40 * 1.5
        var PopupLeft = root.parent.mapFromItem(inputPanel, PopupGlobalLeft, PopupGlobalTop).x
        y = root.parent.mapFromItem(inputPanel, PopupGlobalLeft, PopupGlobalTop).y
        if (PopupGlobalLeft < 0)
            x = 0
        else if ((PopupGlobalLeft + width) > inputPanel.width)
            x = PopupLeft - (PopupGlobalLeft + width - inputPanel.width)
        else
            x = PopupLeft
        loadAlternativesKey()
        visible = true
    }

    function loadAlternativesKey() {
        listModel.clear()
        for (var i = 0; i < alternativeKeys.length; i++) {
            listModel.append({ "btnText": InputEngine.uppercase ? alternativeKeys[i].toUpperCase() : alternativeKeys[i] })
        }
    }

    visible: false

    ListModel {
        id: listModel
    }

    Rectangle {
        radius: 8
        color: ThemeManager.currentTheme.backgroundColor
        anchors.fill: parent

        RowLayout {
            spacing: root.inputPanel.spacing

            anchors {
                fill: parent
                margins: root.inputPanel.margins
            }

            Repeater {
                model: listModel

                Key {
                    required property var model

                    text: model.btnText
                    showPreview: false
                    weight: width
                    onClicked: root.visible = false
                }
            }
        }
    }
}
