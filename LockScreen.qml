/*
    SPDX-FileCopyrightText: 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.5
import org.kde.plasma.private.sessions 2.0
import org.kde.breeze.components

Item {
    id: root
    property bool debug: false
    property string notification
    signal clearPassword()
    signal notificationRepeated()

    // These are magical properties that kscreenlocker looks for
    property bool viewVisible: false
    property bool suspendToRamSupported: false
    property bool suspendToDiskSupported: false

    // These are magical signals that kscreenlocker looks for
    signal suspendToDisk()
    signal suspendToRam()

    implicitWidth: 640
    implicitHeight: 480

    Rectangle {
        color: "black"
        anchors.fill: parent

        Rectangle {
            id: backgroundBorder
            anchors.fill: parent
            z: 4
            radius: 0
            border.color: "#ff3117"
            border.width: 0
            color: "transparent"
            Behavior on border.width {
                SequentialAnimation {
                    id: animateBorder
                    running: false
                    loops: Animation.Infinite
                    NumberAnimation { from: 5; to: 10; duration: 700 }
                    NumberAnimation { from: 10; to: 5;  duration: 400 }
                }
            }
        }
    }

    LockScreenUi {
        anchors.fill: parent
        borderItem: backgroundBorder
        borderAnimation: animateBorder
    }
}
