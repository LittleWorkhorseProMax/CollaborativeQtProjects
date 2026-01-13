import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3 as StandardDialogs
import "qml/pages"
import "qml/components"
import "qml/assets"

ApplicationWindow {
    id: window
    width: 1000  // Initial size reduced
    height: 700
    visible: true
    title: qsTr("JointQT 图片管理系统")
    color: Theme.surfaceColor

    // 当前页面标识，用于 Sidebar 高亮
    property string currentTab: "gallery"

    StandardDialogs.FileDialog {
        id: imageSearchFileDialog
        title: "选择通过图片搜索的文件"
        nameFilters: [ "Image files (*.jpg *.png *.jpeg)" ]
        onAccepted: {
            console.log("Image search file selected: " + imageSearchFileDialog.fileUrl)
            imageSearchDialog.close()
            // Logic to perform reverse image search
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Sidebar {
            Layout.fillHeight: true
            // Layout.preferredWidth: 200 // Let Sidebar control its own width via implicit width or binding
            Layout.preferredWidth: sidebar.width
            id: sidebar
            currentTab: window.currentTab
            onPageRequested: (tabId, pageUrl, title) => {
                window.currentTab = tabId
                stackView.replace(pageUrl)
            }
        }

        ColumnLayout {
            // ...
            // Top Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50 // Further reduced height
                color: Theme.backgroundColor
                z: 10 

                // Bottom border manually
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Theme.borderColor
                    opacity: 0.5 // Lighter border
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    anchors.topMargin: 8
                    anchors.bottomMargin: 8
                    spacing: 12

                    // Search area
                    RowLayout {
                        Layout.fillWidth: true
                        visible: window.currentTab === "gallery" || window.currentTab === "collections"
                        spacing: 8
                        
                        // Search Type Selector
                        ComboBox {
                            Layout.preferredWidth: 90 // Smaller combo
                            Layout.preferredHeight: 30
                            model: ["描述", "文件名"]
                            currentIndex: 0
                            font.pixelSize: 12
                        }

                        // Search Field
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            color: Theme.surfaceColor
                            radius: 4
                            border.color: searchField.activeFocus ? Theme.accentColor : Theme.borderColor

                            TextInput {
                                id: searchField
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                clip: true
                                verticalAlignment: Text.AlignVCenter
                                font.family: Theme.fontFamily
                                selectionColor: Theme.accentColor
                                selectByMouse: true
                                font.pixelSize: 13
                                
                                Text {
                                    text: "选择搜索内容"
                                    color: Theme.secondaryTextColor
                                    visible: !searchField.text && !searchField.activeFocus
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pixelSize: 13
                                }
                            }
                        }
                    }

                    // Spacer if search is hidden
                    Item { 
                        Layout.fillWidth: true 
                        visible: !(window.currentTab === "gallery" || window.currentTab === "collections")
                    }

                    // Right side controls
                     Button {
                        id: imgSearchBtn
                        visible: window.currentTab === "gallery" || window.currentTab === "collections"
                        icon.source: "qrc:/qml/assets/camera.svg"
                        icon.color: Theme.textColor 
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        background: Rectangle {
                            color: imgSearchBtn.hovered ? Theme.hoverColor : "transparent"
                            radius: 4
                            border.color: Theme.borderColor
                            border.width: 1
                        }
                        ToolTip.visible: hovered
                        ToolTip.text: "以图搜图"
                        onClicked: imageSearchDialog.open()
                    }

                    CButton {
                        text: "筛选"
                        iconSource: "qrc:/qml/assets/filter.svg" // Added Filter Icon
                        visible: window.currentTab === "gallery" || window.currentTab === "collections"
                        isPrimary: filterDrawer.opened
                        onClicked: {
                            if (filterDrawer.opened) 
                                filterDrawer.close()
                            else 
                                filterDrawer.open() 
                        }
                    }
                }
            }

            // Main Content Area with Drawer
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true // Ensure content doesn't bleed

                StackView {
                    id: stackView
                    anchors.fill: parent
                    initialItem: "qrc:/qml/pages/GalleryPage.qml"
                    
                    pushEnter: Transition { PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
                    pushExit: Transition { PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 } }
                    replaceEnter: Transition { PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
                    replaceExit: Transition { PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 } }
                }

                // 筛选侧滑菜单
                Drawer {
                    id: filterDrawer
                    width: 250
                    height: parent.height
                    edge: Qt.RightEdge
                    interactive: true
                    modal: false // Allow interaction with other parts? Or true if you want to block
                    dim: false   // Don't dim the content
                    
                    background: Rectangle {
                        color: Theme.backgroundColor
                        border.color: Theme.borderColor
                        // Left border manual
                        Rectangle { anchors.left: parent.left; width: 1; height: parent.height; color: Theme.borderColor }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 20

                        Label { 
                            text: "高级筛选"
                            font.family: Theme.fontFamily
                            font.pixelSize: 16 // Reduced size
                            font.bold: true 
                            color: Theme.textColor
                        }

                        ColumnLayout {
                            spacing: 8
                            Label { text: "标签"; font.bold: true; color: Theme.textColor }
                            CheckBox { text: "标签1" }
                            CheckBox { text: "标签2" }
                            CheckBox { text: "标签3" }
                        }

                        ColumnLayout {
                            spacing: 8
                            Label { text: "评级"; font.bold: true; color: Theme.textColor }
                            Slider { 
                                from: 0; to: 5; stepSize: 1 
                                Layout.fillWidth: true
                            }
                        }
                        
                        Item { Layout.fillHeight: true } 
                        
                        CButton {
                            text: "应用筛选"
                            isPrimary: true
                            Layout.fillWidth: true
                            onClicked: filterDrawer.close()
                        }
                    }
                }
            }
        }
    }

    // 以图搜图对话框
    Dialog {
        id: imageSearchDialog
        title: "以图搜图"
        width: 360 // Reduced size
        height: 260
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Cancel

        ColumnLayout {
            anchors.fill: parent
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.surfaceColor
                // border.dashPattern removed
                border.color: Theme.secondaryTextColor
                radius: 6

                Label {
                    anchors.centerIn: parent
                    text: "拖入图片 或 点击上传"
                    color: Theme.secondaryTextColor
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        imageSearchFileDialog.open()
                    }
                }
            }

            CButton {
                text: "选择文件"
                isPrimary: true
                Layout.alignment: Qt.AlignRight
                onClicked: imageSearchFileDialog.open()
            }
        }
    }
}
