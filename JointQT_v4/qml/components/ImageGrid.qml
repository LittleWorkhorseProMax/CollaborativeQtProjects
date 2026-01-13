import QtQuick 2.15
import QtQuick.Controls 2.15
import "../assets"

GridView {
    id: grid
    cellWidth: 160
    cellHeight: 200
    clip: true
    focus: true
    signal imageClicked(var id, int index)

    delegate: Item {
        width: grid.cellWidth
        height: grid.cellHeight
        
        Rectangle {
            anchors.fill: parent
            anchors.margins: 5
            color: "#e0e0e0"
            border.color: "#ccc"

            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: model.thumbnail
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 30
                color: "#aa000000"
                Label {
                    anchors.centerIn: parent
                    text: model.filename
                    color: "white"
                    elide: Text.ElideRight
                    width: parent.width - 10
                }
            }
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = Theme.hoverColor
                onExited: parent.color = Theme.surfaceColor
                onClicked: {
                    grid.imageClicked(model.id, index)
                }
            }
        }
    }
}
