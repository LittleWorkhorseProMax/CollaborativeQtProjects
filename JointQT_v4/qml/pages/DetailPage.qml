import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../assets"
import "../components"

Page {
    id: root
    background: Rectangle { color: Theme.backgroundColor }
    
    property int modelIndex: -1
    property var imageId: null

    // Data Properties
    property string imageUrl: "qrc:/qml/assets/placeholder.svg" 
    property string filename: "Detail View.jpg"
    property string fileSize: "2.4 MB" // Mock
    property string dimensions: "1920 x 1080"
    property string date: "2023-10-27" // Mock
    property int ratingValue: 5
    property string description: ""
    property var tags: []

    onModelIndexChanged: {
        loadData()
    }

    Component.onCompleted: {
        loadData()
    }

    function loadData() {
        if (modelIndex >= 0) {
            var data = AppManager.imageModel.get(modelIndex)
            if (data) {
                filename = data.filename || ""
                imageUrl = data.url ? "file:///" + data.url : "qrc:/qml/assets/placeholder.svg" // Handle URL format
                dimensions = (data.width || 0) + " x " + (data.height || 0)
                ratingValue = data.rating ? Math.round(data.rating) : 0
                description = data.description || ""
                tags = data.tags || []
                // Mock others
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 左侧：大图浏览区
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#000000" // 黑色背景沉浸式
            
            Image {
                anchors.fill: parent
                anchors.margins: 20
                source: root.imageUrl
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
        }

        // 右侧：信息与操作区
        Rectangle {
            Layout.preferredWidth: 320
            Layout.fillHeight: true
            color: Theme.surfaceColor
            border.width: 1
            border.color: Theme.borderColor
            border.side: Border.Left // QML Rectangle doesn't support side, need manual border
            
            Rectangle { 
                width: 1; height: parent.height; color: Theme.borderColor; anchors.left: parent.left 
            }

            ScrollView {
                anchors.fill: parent
                anchors.topMargin: 20
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                contentWidth: availableWidth

                ColumnLayout {
                    width: parent.width
                    spacing: 24

                    // 顶部操作栏
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        CButton { text: "编辑"; Layout.fillWidth: true }
                        CButton { text: "删除"; // isPrimary: false; color override needed for red, keeping simple 
                        }
                    }

                    // 基本信息块
                    ColumnLayout {
                        width: parent.width
                        spacing: 8
                        Label { text: "基本信息"; font.bold: true; color: Theme.textColor }
                        
                        DetailItem { label: "文件名"; value: root.filename }
                        DetailItem { label: "大小"; value: root.fileSize }
                        DetailItem { label: "尺寸"; value: root.dimensions }
                        DetailItem { label: "日期"; value: root.date }
                    }

                    // 评分
                    ColumnLayout {
                        width: parent.width
                        spacing: 8
                        Label { text: "评分"; font.bold: true; color: Theme.textColor }
                        RowLayout {
                             // Simple Star Rating
                             Repeater {
                                 model: 5
                                 Text {
                                     text: "★"
                                     font.pixelSize: 20
                                     color: index < root.ratingValue ? "#F59E0B" : "#D1D5DB"
                                 }
                             }
                        }
                    }
                    
                    // 描述
                    ColumnLayout {
                        width: parent.width
                        spacing: 8
                        Label { text: "描述"; font.bold: true; color: Theme.textColor }
                        TextArea {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 100
                            placeholderText: "添加描述..."
                            background: Rectangle {
                                color: Theme.backgroundColor
                                border.color: Theme.borderColor
                                radius: 4
                            }
                        }
                    }

                    // 标签
                    ColumnLayout {
                        width: parent.width
                        spacing: 8
                        Label { text: "标签"; font.bold: true; color: Theme.textColor }
                        Flow {
                            Layout.fillWidth: true
                            spacing: 8
                            Repeater {
                                model: ["风景", "自然", "2023"]
                                Rectangle {
                                    width: tagText.implicitWidth + 16
                                    height: 24
                                    color: Theme.hoverColor
                                    radius: 12
                                    Text {
                                        id: tagText
                                        anchors.centerIn: parent
                                        text: modelData
                                        font.pixelSize: 12
                                        color: Theme.secondaryTextColor
                                    }
                                }
                            }
                            // Add button
                            Rectangle {
                                width: 24; height: 24; radius: 12
                                border.color: Theme.borderColor
                                Text { anchors.centerIn: parent; text: "+" }
                            }
                        }
                    }
                }
            }
        }
    }
    
    component DetailItem : RowLayout {
        property string label
        property string value
        spacing: 10
        Label { 
            text: label
            color: Theme.secondaryTextColor
            Layout.preferredWidth: 60
            font.pixelSize: Theme.smallFontSize
        }
        Label { 
            text: value
            color: Theme.textColor
            Layout.fillWidth: true
            elide: Text.ElideRight
            font.pixelSize: Theme.bodyFontSize 
        }
    }
}
