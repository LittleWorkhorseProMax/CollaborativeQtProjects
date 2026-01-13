import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3

Page {
    title: "图片搜索"
    background: Rectangle { color: "transparent" }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        Label {
            text: "图片搜索"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
        }
        
        TabBar {
            id: searchBar
            Layout.fillWidth: true
            TabButton { text: "关键词搜索" }
            TabButton { text: "以图搜图" }
        }
        
        StackLayout {
            currentIndex: searchBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // 关键词搜索页
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10
                    RowLayout {
                        TextField {
                            id: keywordField
                            placeholderText: "输入关键词..."
                            Layout.fillWidth: true
                            onAccepted: networkManager.searchImages(text)
                        }
                        Button {
                            text: "搜索"
                            onClicked: networkManager.searchImages(keywordField.text)
                        }
                    }
                    
                    GridView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        cellWidth: 220
                        cellHeight: 180
                        clip: true
                        model: ListModel { id: textSearchModel }
                        delegate: Rectangle {
                            width: 210
                            height: 170
                            color: "white"
                            Image {
                                anchors.fill: parent
                                anchors.margins: 4
                                anchors.bottomMargin: 30
                                source: model.url
                                fillMode: Image.PreserveAspectCrop
                            }
                            Text {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 5
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: model.title
                            }
                        }
                    }
                }
            }
            
            // 以图搜图页
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10
                    
                    Rectangle {
                        id: dropZone
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        color: dropAreaMsg.containsMouse ? "#e8f6f3" : "white"
                        border.color: dropAreaMsg.containsMouse ? "#27ae60" : "#bdc3c7"
                        border.width: 2
                        radius: 8
                        
                        Behavior on color { ColorAnimation { duration: 200 } }

                        Column {
                            anchors.centerIn: parent
                            spacing: 10
                            
                            Text {
                                text: "📂" 
                                font.pixelSize: 40
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            
                            Text {
                                text: "点击此处选择图片"
                                color: "#7f8c8d"
                                font.pixelSize: 16
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        
                        MouseArea {
                            id: dropAreaMsg
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: imageSearchDialog.open()
                        }
                    }
                    
                    Label { 
                        text: "搜索结果" 
                        font.bold: true
                        font.pixelSize: 16
                        color: "#2c3e50"
                        visible: imgSearchModel.count > 0
                    }
                    
                    GridView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        cellWidth: 220
                        cellHeight: 180
                        clip: true
                        model: ListModel { id: imgSearchModel }
                        delegate: Rectangle {
                            width: 210
                            height: 170
                            color: "white"
                            Image {
                                anchors.fill: parent
                                anchors.margins: 4
                                anchors.bottomMargin: 30
                                source: model.url
                                fillMode: Image.PreserveAspectCrop
                            }
                            Text {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 5
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: model.title
                            }
                        }
                    }
                }
            }
        }
    }
    
    FileDialog {
        id: imageSearchDialog
        title: "选择图片"
        nameFilters: [ "Image files (*.jpg *.png)" ]
        onAccepted: {
            networkManager.searchByImage(fileUrl)
        }
    }
    
    Connections {
        target: networkManager
        function onSearchResultReady(results) {
            // 根据当前 tab 填充不同的 model，或者简单复用
            var targetModel = searchBar.currentIndex === 0 ? textSearchModel : imgSearchModel
            targetModel.clear()
            for(var i=0; i<results.length; i++) {
                targetModel.append(results[i])
            }
        }
    }
}
