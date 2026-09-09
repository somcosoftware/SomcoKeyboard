import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import QtQuick.SomcoKeyboard 1.0
import SomcoKeyboard 1.0

ApplicationWindow {
    id: window

    visible: true
    width: 1088
    minimumWidth: 550
    height: 900
    title: qsTr("Somco Keyboard Example")

    background: Rectangle {
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#79968F"
            }
            GradientStop {
                position: 1.0
                color: "#084E4B"
            }
        }
    }

    component CTextField: TextField {
        implicitWidth: 512
        implicitHeight: 68
        color: "#FFFFFF"
        font.pixelSize: 30
        font.family: "Inter"
        background: Rectangle {
            anchors.fill: parent
            color: "#0A322D"
            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: 2
                color: "#D9D9D9"
            }
        }
        Keys.onEscapePressed: {
            InputContext.requestHide()
        }
    }

    ColumnLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            margins: 80
            bottomMargin: inputPanel.height + 40
            left: parent.left
            right: parent.right
        }

        spacing: 40

        Image {
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            source: inputPanel.themeName === "defaultDark" ? "qrc:/icons/SomcoKeyboardApp/dark/logo.svg" : "qrc:/icons/SomcoKeyboardApp/light/logo.svg"
            Layout.preferredWidth: 575
            Layout.preferredHeight: 88
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 40
            Text {
                text: qsTr("Keyboard Theme")
                color: "#FFFFFF"
                font.pixelSize: 20
                font.family: "Inter"
            }

            Button {
                id: toggle
                implicitWidth: 65
                implicitHeight: 40
                checkable: true

                checked: inputPanel.themeName === "defaultDark"
                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: toggle.checked ? "#1E1E2E" : "#F5F7FA"

                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }
                    }
                }

                contentItem: Item {
                    anchors.fill: parent
                    Rectangle {
                        width: 28
                        height: 28
                        radius: width / 2
                        color: toggle.checked ? "#F1F5F9" : "#FDB813"
                        anchors.verticalCenter: parent.verticalCenter
                        x: toggle.checked ? parent.width - width - 6 : 6

                        Behavior on x {
                            NumberAnimation {
                                duration: 250
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 250
                            }
                        }
                    }
                }

                onToggled: {
                    if (checked)
                        inputPanel.themeName = "defaultDark"
                    else
                        inputPanel.themeName = "defaultLight"
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 39
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 9

                Text {
                    text: qsTr("Login ID")
                    color: "#FFFFFF"
                    font.pixelSize: 20
                    font.family: "Inter"
                }

                CTextField {
                    Layout.fillWidth: true
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 9

                Text {
                    text: qsTr("Password")
                    color: "#FFFFFF"
                    font.pixelSize: 20
                    font.family: "Inter"
                }

                CTextField {
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    echoMode: TextInput.Password
                    passwordMaskDelay: 1000
                    EnterKeyAction.enabled: text.length >= 6
                }
            }
        }
    }

    InputPanel {
        id: inputPanel

        z: 99
        y: Qt.inputMethod.visible ? (window.height - inputPanel.height) : window.height
        width: parent.width

        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        themeName: "defaultDark"
    }
}
