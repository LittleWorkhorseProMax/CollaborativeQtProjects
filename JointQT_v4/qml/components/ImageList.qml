import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../assets"

ListView {
    id: list
    clip: true
    focus: true
    spacing: 4
    signal imageClicked(var id, int index)

    delegate: Rectangle {
        width: list.width
        height: 100
        color: "#f9f9f9"
        border.color: "#eee"
        radius: 4

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 10

            Image {
                Layout.preferredWidth: 90
                Layout.preferredHeight: 90
                source: model.thumbnail
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                
                Label { 
                    text: model.filename 
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
            
            // Right aligned info
            RowLayout {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                spacing: 20
                
                Label { 
                    text: model.width + "x" + model.height 
                    color: "gray"
                    font.pixelSize: 12
                }
                
                Label { 
                    text: model.rating + " ★" 
                    color: "orange"
                    font.pixelSize: 12
                }

                Label {
                    text: "2.4 MB" // Mock size
                    color: "gray"
                    font.pixelSize: 12
                    preferredWidth: 60
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color = Theme.hoverColor
            onExited: parent.color = Theme.surfaceColor
            onClicked: {
                 list.imageClicked(model.id, index)
            }
        }
    }
}
