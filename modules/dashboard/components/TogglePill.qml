import QtQuick
import QtQuick.Controls
import "../../../services"
import "../../../config"

Item {
    id: root

    signal clicked()
    property string icon: ""
    property bool active: false
    property bool busy: false
    property bool enabledState: true
    property string badgeText: ""
    property string tooltip: ""

    opacity: enabledState ? 1.0 : 0.42

    ToolTip.visible: pillArea.containsMouse && tooltip !== ""
    ToolTip.text: tooltip
    ToolTip.delay: 450

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: root.active ? ThemeService.primary : ThemeService.surfaceBright
        opacity: pillArea.containsMouse ? 1.0 : 0.96
    }

    Text {
        anchors.centerIn: parent
        text: root.icon
        font.family: ThemeService.iconFont
        font.pixelSize: 17
        color: root.active ? ThemeService.background : ThemeService.foreground

        SequentialAnimation on opacity {
            running: root.busy
            loops: Animation.Infinite
            NumberAnimation { to: 0.35; duration: 360 }
            NumberAnimation { to: 1.0; duration: 360 }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 3
        anchors.topMargin: 3
        width: 14
        height: 14
        radius: 7
        visible: root.badgeText !== ""
        color: ThemeService.background
        border.width: 1
        border.color: ThemeService.primary

        Text {
            anchors.centerIn: parent
            text: root.badgeText
            color: ThemeService.primary
            font.family: ThemeService.fontName
            font.pixelSize: 8
            font.weight: Font.Bold
        }
    }

    MouseArea {
        id: pillArea
        anchors.fill: parent
        enabled: root.enabledState && !root.busy
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
