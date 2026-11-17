import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SomcoKeyboard 1.0

Button {
    id: key
    objectName: (inputPanelRef ? inputPanelRef.objectName : "") + (btnDisplayedText ? btnDisplayedText : text)

    property real weight: 70
    property string btnDisplayedText: key.text

    property int btnKey: Qt.Key_unknown
    property color btnBackground: ThemeManager.currentTheme.btnBackgroundColor
    property string btnIcon: ""
    property size btnIconSize: Qt.size(35, 35)
    property var alternativeKeys: []
    property var inputPanelRef
    property alias repeatable: key.autoRepeat
    property bool showPreview: true
    property bool functionKey: false

    focusPolicy: Qt.NoFocus
    Layout.minimumWidth: key.implicitWidth
    Layout.minimumHeight: key.implicitHeight
    Layout.preferredWidth: weight
    Layout.fillWidth: true
    Layout.fillHeight: true
    onPressed: {
        if (key.inputPanelRef !== null && key.showPreview)
            key.inputPanelRef.showKeyPopup(key)
    }
    onPressedChanged: {
        if (key.pressed) {
            key.opacity = 0.7
            if (key.alternativeKeys.length > 0)
                longPressTimer.running = true
        } else {
            key.opacity = 1
            longPressTimer.running = false
        }
    }
    onReleased: {
        if (!functionKey) {
            InputEngine.virtualKeyClick(btnKey, InputEngine.uppercase ? text.toUpperCase() : text, InputEngine.uppercase ? Qt.ShiftModifier : 0)
            var autoCapUp = false
            if (InputEngine.autoCapitalize && !InputContext.isPasswordField()) {
                var surrounding = InputContext.surroundingText()
                autoCapUp = surrounding.length === 0 || /[.!?] $/.test(surrounding)
            }
            if (InputEngine.shiftState != InputEngine.CapsLock)
                InputEngine.shiftState = autoCapUp ? InputEngine.ShiftOn : InputEngine.ShiftOff
        }
    }

    Timer {
        id: longPressTimer

        interval: 800
        repeat: false
        running: false
        onTriggered: {
            key.enabled = false
            key.inputPanelRef.showAlternativesKeyPopup(key)
            key.enabled = true
        }
    }

    background: Rectangle {
        color: key.btnBackground
        radius: 8
    }

    contentItem: Item {
        anchors.fill: parent
        RowLayout {
            spacing: 16
            anchors.centerIn: parent

            Text {
                id: textItem
                text: key.btnDisplayedText
                color: ThemeManager.currentTheme.btnTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font {
                    family: ThemeManager.currentTheme.btnTextFontFamily
                    weight: Font.Normal
                    pixelSize: ThemeManager.currentTheme.btnTextFontSize
                    capitalization: InputEngine.uppercase ? Font.AllUppercase : Font.MixedCase
                }
                visible: {
                    if (key.btnDisplayedText === "")
                        return false
                    var iconVisible = (key.btnIcon !== "")
                    var iconWidth = iconVisible ? key.btnIconSize.width : 0
                    var requiredWidth = textItem.paintedWidth + 16 + iconWidth

                    return key.width > requiredWidth || !iconVisible
                }
            }

            Image {
                source: key.btnIcon
                visible: key.btnIcon !== ""
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: key.btnIconSize.width
                Layout.preferredHeight: key.btnIconSize.height
            }
        }
    }
}
