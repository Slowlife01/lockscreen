/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 2.12 as QQC2

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kscreenlocker 1.0 as ScreenLocker

import org.kde.breeze.components

SessionManagementScreen {
    id: sessionManager

    readonly property alias mainPasswordBox: passwordBox
    property bool lockScreenUiVisible: true

    property color textColor: "#ffffff"
    property int passwordFontSize: 96
    property string defaultFont: "monospace"

    /*
     * Login has been requested with the following username and password
     * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
     */
    signal passwordResult(string password)

    function startLogin() {
        const password = passwordBox.text
        passwordResult(password);
    }

    Item {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: 1000

        TextInput {
            id: passwordBox
            height: 200 / 96 * sessionManager.passwordFontSize

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            font.pointSize: sessionManager.passwordFontSize
            font.bold: true
            font.letterSpacing: 20 / 96 * sessionManager.passwordFontSize
            font.family: sessionManager.defaultFont

            echoMode: TextInput.Password
            color: sessionManager.textColor
            selectionColor: sessionManager.textColor
            selectedTextColor: "#000000"
            clip: false

            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter

            passwordCharacter: "*"
            cursorVisible: true
            onAccepted: {
                if (text != "") {
                    passwordResult(text);
                }
            }

            // Rectangle {
            //     color: "white"
            //     anchors.fill: parent
            // }

            cursorDelegate: Rectangle {
                id: passwordInputCursor
                property string cursorColorSetting: "random"

                function getCursorColor() {
                    var setting = cursorColorSetting;
                    if (setting.length === 7 && setting[0] === "#") {
                        return setting;
                    } else if (setting === "constantRandom" || setting === "random") {
                        return generateRandomColor();
                    } else {
                        return sessionManager.textColor;
                    }
                }
                width: 18 / 96 * sessionManager.passwordFontSize
                visible: true
                onHeightChanged: height = passwordBox.height / 2
                anchors.verticalCenter: parent.verticalCenter
                color: getCursorColor()
                property color currentColor: color

                SequentialAnimation on color {
                    loops: Animation.Infinite
                    PauseAnimation {
                        duration: 100
                    }
                    ColorAnimation {
                        from: passwordInputCursor.currentColor
                        to: "transparent"
                        duration: 0
                    }
                    PauseAnimation {
                        duration: 500
                    }
                    ColorAnimation {
                        from: "transparent"
                        to: passwordInputCursor.currentColor
                        duration: 0
                    }
                    PauseAnimation {
                        duration: 400
                    }
                    running: true
                }

                function generateRandomColor() {
                    var color_ = "#";
                    for (var i = 0; i < 3; i++) {
                        var color_number = parseInt(Math.random() * 255);
                        var hex_color = color_number.toString(16);
                        if (color_number < 16) {
                            hex_color = "0" + hex_color;
                        }
                        color_ += hex_color;
                    }
                    return color_;
                }

                Connections {
                    target: root
                    function onClearPassword() {
                        passwordBox.forceActiveFocus()
                        passwordBox.text = "";
                        passwordBox.text = Qt.binding(() => PasswordSync.password);
                    }
                }

                Connections {
                    target: passwordBox
                    function onTextEdited() {
                        // Only update color on every edit when using truly random cursor color.
                        if (passwordInputCursor.cursorColorSetting === "random") {
                            passwordInputCursor.currentColor = passwordInputCursor.generateRandomColor();
                        }
                    }
                }
            }
        }


        Binding {
            target: PasswordSync
            property: "password"
            value: passwordBox.text
        }
    }
}
