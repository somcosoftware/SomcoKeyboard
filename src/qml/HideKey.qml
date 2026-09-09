import SomcoKeyboard 1.0
import QtQuick 2.0

Key {
    objectName: inputPanelRef.objectName + "Key_Hide"
    functionKey: true
    showPreview: false
    btnBackground: "transparent"
    btnIcon: ThemeManager.currentTheme.hideKeyboardIcon
    weight: 112
    onClicked: InputContext.requestHide()
}
