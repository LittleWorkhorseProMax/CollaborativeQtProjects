import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    title: "图片总览"
    background: Rectangle { color: "transparent" }
    
    Component.onCompleted: {
        networkManager.fetchImages("All")
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        Label {
            text: "图片总览"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            ComboBox {
                id: catFilter
                model: ["All", "Nature", "Architecture", "People"]
                onCurrentTextChanged: networkManager.fetchImages(currentText)
            }
            
            Button {
                text: "刷新"
                onClicked: networkManager.fetchImages(catFilter.currentText)
            }
            
            Item { Layout.fillWidth: true } // Spacer
        }

        GridView {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 220
            cellHeight: 180
            clip: true
            
            model: ListModel { id: galleryModel }
            
            delegate: Rectangle {
                id: card
                width: grid.cellWidth - 10
                height: grid.cellHeight - 10
                color: "white"
                radius: 8
                
                // Shadow (Simulated with border/color for performance if DropShadow not avail)
                border.color: "#ecf0f1"
                border.width: 1
                
                // Hover effect
                property bool hovered: false
                scale: hovered ? 1.02 : 1.0
                Behavior on scale { NumberAnimation { duration: 150 } }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: card.hovered = true
                    onExited: card.hovered = false
                }
                
                Image {
                    anchors.fill: parent
                    anchors.margins: 4
                    anchors.bottomMargin: 30
                    source: model.url
                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                    // smooth: true
                }
                
                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: model.title
                    elide: Text.ElideRight
                    width: parent.width - 20
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 12
                    color: "#2c3e50"
                }
            }
        }
    }

    Connections {
        target: networkManager
        function onImagesReady(images) {
            galleryModel.clear()
            for(var i=0; i<images.length; i++) {
                galleryModel.append(images[i])
            }
        }
    }
}
