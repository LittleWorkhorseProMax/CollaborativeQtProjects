import QtQuick 2.15
import QtQuick.Controls 2.15
import "../assets"

Button {
    id: control
    text: "Button"
    
    property bool isPrimary: false
    property string iconSource: ""

    contentItem: Item {
        implicitWidth: Math.max(80, row.implicitWidth + 24) // Reduced min width and padding
        implicitHeight: 32 // Reduced height from 36
        
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 6 // Reduced spacing
            
            Image {
                visible: control.iconSource !== ""
                source: control.iconSource
                width: 14 // Reduced icon size
                height: 14
                sourceSize: Qt.size(14, 14)
                opacity: 0.8
            }
            
            Text {
                text: control.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.smallFontSize // Use smaller font
                color: control.isPrimary ? "#FFFFFF" : Theme.textColor
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    background: Rectangle {
        implicitWidth: 80
        implicitHeight: 32
        radius: 4 // Consistent smaller radius
        color: {
            if (control.pressed) return control.isPrimary ? Qt.darker(Theme.accentColor, 1.1) : Theme.pressedColor
            if (control.hovered) return control.isPrimary ? Qt.lighter(Theme.accentColor, 1.1) : Theme.hoverColor
            return control.isPrimary ? Theme.accentColor : "transparent"
        }
        border.color: control.isPrimary ? "transparent" : Theme.borderColor
        border.width: control.isPrimary ? 0 : 1
        
        Behavior on color { ColorAnimation { duration: 100 } }
    }
}
