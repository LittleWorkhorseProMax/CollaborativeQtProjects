import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3 // Use standard FileDialog
import "../components"
import "../assets"

Page {
    title: "Upload Images"
    background: Rectangle { color: Theme.surfaceColor }

    FileDialog {
        id: fileDialog
        title: "选择图片"
        folder: shortcuts.pictures
        nameFilters: [ "Image files (*.jpg *.png *.jpeg)", "All files (*)" ]
        selectMultiple: true
        onAccepted: {
            console.log("Selected files: " + fileDialog.fileUrls)
            // Add logic to process files
        }
    }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        
        Label {
            text: "上传新图片"
            font.family: Theme.fontFamily
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            width: 500
            height: 300
            color: Theme.backgroundColor
            // border.dashPattern not supported natively on Rectangle without Context 2D, keeping simple
            border.color: Theme.accentColor
            border.width: 1
            radius: 8
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 12
                
                Image {
                    source: "qrc:/qml/assets/placeholder.svg"
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 64
                    Layout.alignment: Qt.AlignHCenter
                    opacity: 0.5
                }
                
                Label {
                    text: "拖拽图片到此处 或 点击选择"
                    font.family: Theme.fontFamily
                    color: Theme.secondaryTextColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = Theme.hoverColor
                onExited: parent.color = Theme.backgroundColor
                onClicked: fileDialog.open()
            }
        }
        
        CButton {
            text: "开始上传"
            isPrimary: true
            Layout.alignment: Qt.AlignHCenter
            onClicked: fileDialog.open()
        }
    }
}
