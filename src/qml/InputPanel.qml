import QtQuick 2.0
import QtQml 2.0

import SomcoKeyboard 1.0

Item {
    id: root

    readonly property bool active: Qt.inputMethod.visible

    property var availableLanguageLayouts: ["En", "Pl", "Uk"]
    property string languageLayout: "En"
    property int spacing: 16
    property int margins: 16

    property list<KeyboardTheme> themes
    property string themeName

    /*! \internal */
    property bool autoCapitalize: false

    readonly property bool __isRootItem: root.parent !== null && root.parent.parent === null

    function showKeyPopup(keyButton) {
        keyPopup.popup(keyButton)
    }

    function hideKeyPopup() {
        keyPopup.visible = false
    }

    function showAlternativesKeyPopup(keyButton) {
        alternativesKeyPopup.open(keyButton)
    }

    objectName: "inputPanel"
    width: parent.width
    height: 340
    onYChanged: InputEngine.setKeyboardRectangle(Qt.rect(x, y, width, height))
    onActiveChanged: {
        if (alternativesKeyPopup.visible && !active)
            alternativesKeyPopup.visible = false
    }
    onLanguageLayoutChanged: _.loadLettersLayout()
    onThemeNameChanged: ThemeManager.setTheme(themeName)

    Component.onCompleted: {
        InputContext.registerInputPanel(root)

        if (availableLanguageLayouts.length == 0)
            availableLanguageLayouts = ["En"]

        if (root.themes.length == 0) {
            ThemeManager.addTheme(lightTheme)
            ThemeManager.addTheme(darkTheme)
        } else {
            for (var i = 0; i < root.themes.length; ++i)
                ThemeManager.addTheme(root.themes[i])
        }
        if (root.themeName === "")
            root.themeName = root.themes.length > 0 ? root.themes[0].themeName : lightTheme.themeName
        ThemeManager.setTheme(root.themeName)

        InputEngine.availableLanguageLayouts = availableLanguageLayouts
        InputEngine.languageLayout = languageLayout
        InputEngine.autoCapitalize = autoCapitalize

        _.loadLettersLayout()
    }

    KeyboardTheme {
        id: lightTheme
        themeName: "defaultLight"

        overlayBackgroundColor: "#D4E3EE"
        backgroundColor: "#C2D4EA"
        btnBackgroundColor: "#DEECFB"
        btnSpecialBackgroundColor: "#ADC3DB"
        btnEnterBackgroundColor: "#1DCA9B"
        btnTextColor: "#000000"
        btnTextFontFamily: "Inter"
        btnTextFontSize: 21

        backspaceIcon: "qrc:/icons/SomcoKeyboard/light/keyboard_backspace.svg"
        enterIcon: "qrc:/icons/SomcoKeyboard/light/keyboard_return.svg"
        shiftOnIcon: "qrc:/icons/SomcoKeyboard/light/shift_on.svg"
        shiftOffIcon: "qrc:/icons/SomcoKeyboard/light/shift_off.svg"
        capsLockIcon: "qrc:/icons/SomcoKeyboard/light/caps_lock.svg"
        hideKeyboardIcon: "qrc:/icons/SomcoKeyboard/light/keyboard_hide.svg"
        languageIcon: "qrc:/icons/SomcoKeyboard/light/language.svg"
        spaceIcon: "qrc:/icons/SomcoKeyboard/light/keyboard_space.svg"
    }

    KeyboardTheme {
        id: darkTheme
        themeName: "defaultDark"

        overlayBackgroundColor: "#000000"
        backgroundColor: "#000000"
        btnBackgroundColor: "#2A3139"
        btnSpecialBackgroundColor: "#4B545E"
        btnEnterBackgroundColor: "#1DCA9B"
        btnTextColor: "#FFFFFF"
        btnTextFontFamily: "Inter"
        btnTextFontSize: 21

        backspaceIcon: "qrc:/icons/SomcoKeyboard/dark/keyboard_backspace.svg"
        enterIcon: "qrc:/icons/SomcoKeyboard/dark/keyboard_return.svg"
        shiftOnIcon: "qrc:/icons/SomcoKeyboard/dark/shift_on.svg"
        shiftOffIcon: "qrc:/icons/SomcoKeyboard/dark/shift_off.svg"
        capsLockIcon: "qrc:/icons/SomcoKeyboard/dark/caps_lock.svg"
        hideKeyboardIcon: "qrc:/icons/SomcoKeyboard/dark/keyboard_hide.svg"
        languageIcon: "qrc:/icons/SomcoKeyboard/dark/language.svg"
        spaceIcon: "qrc:/icons/SomcoKeyboard/dark/keyboard_space.svg"
    }

    KeyPopup {
        id: keyPopup
        inputPanel: root
        keyboardRect: keyboardRect

        visible: false
        z: 100
    }

    AlternativeKeysPopup {
        id: alternativesKeyPopup
        inputPanel: root
        keyboardRect: keyboardRect

        visible: false
        z: 100
    }

    Rectangle {
        anchors.fill: parent
        visible: alternativesKeyPopup.visible
        z: alternativesKeyPopup.z - 1
        color: "#80000000"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                alternativesKeyPopup.visible = false
            }
        }
    }

    Rectangle {
        id: keyboardRect

        anchors.fill: parent
        color: ThemeManager.currentTheme.overlayBackgroundColor

        Rectangle {
            anchors {
                fill: parent
                margins: root.margins
            }
            color: ThemeManager.currentTheme.backgroundColor
            radius: 12

            Loader {
                id: layoutLoader

                // lang description only needed for layouts that share a file
                property string langDescription
                // space identifier for the correct translation of the word "space"
                property string spaceIdentifier

                anchors {
                    fill: parent
                    margins: root.margins
                }
            }
        }
    }

    Connections {
        function refreshLayouts() {
            if (alternativesKeyPopup.visible)
                alternativesKeyPopup.visible = false

            if (InputEngine.symbolMode)
                layoutLoader.setSource("SymbolLayout.qml", {
                                           "inputPanel": root
                                       })
            else if (InputEngine.inputMode === InputEngine.DigitsOnly)
                layoutLoader.setSource("DigitsLayout.qml", {
                                           "inputPanel": root
                                       })
            else
                _.loadLettersLayout()
        }

        function onInputModeChanged() {
            refreshLayouts()
        }

        function onIsSymbolModeChanged() {
            refreshLayouts()
        }

        function onLanguageLayoutChanged() {
            root.languageLayout = InputEngine.languageLayout
            _.loadLettersLayout()
        }

        target: InputEngine
    }

    Binding {
        target: ThemeManager
        property: "availableThemes"
        value: root.themes
    }

    QtObject {
        id: _

        function loadLettersLayout() {
            var source = InputEngine.fileOfLayout(languageLayout)
            if (source === "") {
                InputEngine.languageLayout = "En"
                return
            }

            var description = InputEngine.descriptionOfLayout(languageLayout)
            var spaceIdentifier = InputEngine.spaceIdentifierOfLayout(languageLayout)
            if (description !== "" && source !== "") {
                layoutLoader.langDescription = description
                layoutLoader.spaceIdentifier = spaceIdentifier
                layoutLoader.setSource(source + ".qml", {
                                           "inputPanel": root
                                       })
            } else {
                layoutLoader.langDescription = "English"
                layoutLoader.spaceIdentifier = "space"
                layoutLoader.setSource("EnLayout.qml", {
                                           "inputPanel": root
                                       })
            }
        }
    }
}
