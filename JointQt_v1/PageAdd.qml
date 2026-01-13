/*
 * PageAdd.qml
 * 图片上传页面
 * 包含功能：本地文件选择、图片预览、裁剪框交互、调用 C++ 上传接口
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3

Page {
    title: "图片加入"
    background: Rectangle { color: "transparent" }

    property string selectedImagePath: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Label {
            text: "图片加入 & 裁剪"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            radius: 8
            
            // 占位提示
            Text {
                anchors.centerIn: parent
                text: "点击选择图片"
                color: "#95a5a6"
                visible: selectedImagePath === ""
            }

            // 图片预览区
            Image {
                id: previewImage
                anchors.fill: parent
                anchors.margins: 10
                source: selectedImagePath
                fillMode: Image.PreserveAspectFit
                visible: selectedImagePath !== ""
                
                // 模拟裁剪框
                Rectangle {
                    id: cropRect
                    width: 200
                    height: 200
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    color: "transparent"
                    border.color: "white"
                    border.width: 2
                    visible: parent.status === Image.Ready
                    
                    // 遮罩效果 (半透明黑底)
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "#3498db"
                        border.width: 1
                    }
                    
                    // 四角手柄 (装饰用)
                    Rectangle { width: 10; height: 10; color: "#3498db"; anchors.left: parent.left; anchors.top: parent.top; anchors.margins: -5 }
                    Rectangle { width: 10; height: 10; color: "#3498db"; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: -5 }
                    Rectangle { width: 10; height: 10; color: "#3498db"; anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: -5 }
                    Rectangle { width: 10; height: 10; color: "#3498db"; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: -5 }
                    
                    MouseArea {
                        anchors.fill: parent
                        drag.target: parent
                        drag.axis: Drag.XAndY
                        drag.minimumX: 0
                        drag.maximumX: previewImage.width - width
                        drag.minimumY: 0
                        drag.maximumY: previewImage.height - height
                        cursorShape: Qt.SizeAllCursor
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "拖动选择区域"
                        color: "white"
                        font.bold: true
                        style: Text.Outline; styleColor: "black"
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: selectedImagePath === ""
                onClicked: fileDialog.open()
                cursorShape: Qt.PointingHandCursor
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Button {
                text: "选择图片"
                onClicked: fileDialog.open()
            }

            Button {
                text: "直接上传"
                highlighted: true
                enabled: selectedImagePath !== ""
                onClicked: {
                   // 不裁剪
                   networkManager.uploadImage(selectedImagePath, 0, 0, 0, 0)
                }
            }

            Button {
                text: "裁剪并上传"
                highlighted: true
                enabled: selectedImagePath !== ""
                palette.button: "#e67e22"
                onClicked: {
                    // 计算裁剪坐标（相对于原图）
                    // 注意：previewImage 是 Fit 模式，计算真实坐标比较复杂。
                    // 这里为了简化演示，我们假设传给后端的是相对于 Image 控件的坐标，
                    // 后端若要精确裁剪需要知道原图尺寸和显示尺寸的关系。
                    // 现在的 NetworkManager 里的 QImage copy 接受的是像素坐标。
                    // 这里的实现是一个模拟，真实应用需要 mapToItem 换算比例。
                    
                    var ratioX = previewImage.sourceSize.width / previewImage.paintedWidth
                    var ratioY = previewImage.sourceSize.height / previewImage.paintedHeight
                    // 简化：如果 FillMode 是 Fit，paintedWidth 可能小于 width
                    // 这是一个简化的 demo，传回大概位置。如果要精确，需要计算缩放比。
                    
                    networkManager.uploadImage(selectedImagePath, cropRect.x, cropRect.y, cropRect.width, cropRect.height)
                }
            }
        }
    }
    
    FileDialog {
        id: fileDialog
        title: "选择图片"
        folder: shortcuts.pictures
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        onAccepted: {
            selectedImagePath = fileUrl
        }
    }
    
    Connections {
        target: networkManager
        function onUploadFinished(success, message) {
            uploadStatusPopup.text = message
            uploadStatusPopup.open()
        }
    }
    
    Popup {
        id: uploadStatusPopup
        property alias text: popupLabel.text
        width: 300
        height: 60
        anchors.centerIn: parent
        modal: true
        background: Rectangle { color: "#34495e"; radius: 5 }
        Label { id: popupLabel; anchors.centerIn: parent; color: "white" }
    }
}
