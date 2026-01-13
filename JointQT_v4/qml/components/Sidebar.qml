import QtQuick 2.15
import QtQuick.Controls 2.15
import "../assets"

import QtQuick 2.15
import QtQuick.Controls 2.15
import "../assets"

Rectangle {
    id: root
    width: collapsed ? 64 : 220
    color: "#FFFFFF"
    
    // 当前选中的页面标识
    property string currentTab: "gallery"
    property bool collapsed: false
    
    // 信号：请求切换页面 (tabId, qmlPath, title)
    signal pageRequested(string tabId, string pageUrl, string title)

    Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

    // Right border
    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: Theme.borderColor
    }

    Column {
        anchors.fill: parent
        spacing: 0

        // App Logo / Header Area
        Item {
            width: parent.width
            height: 64
            
            // Expanded Title
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                spacing: 12
                visible: !root.collapsed
                opacity: root.collapsed ? 0 : 1
                Behavior on opacity { NumberAnimation { duration: 150 } }
                
                Text {
                    text: "JointQT"
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Theme.accentColor
                }
            }
             
             // Toggle Button (Visible always, position shifts)
             Button {
                anchors.right: parent.right
                anchors.rightMargin: root.collapsed ? (parent.width - width)/2 : 8
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                
                icon.source: "qrc:/qml/assets/menu.svg"
                icon.width: 20
                icon.height: 20
                icon.color: Theme.secondaryTextColor
                
                background: Rectangle {
                    color: parent.hovered ? Theme.hoverColor : "transparent"
                    radius: 4
                }
                
                onClicked: root.collapsed = !root.collapsed
                
                ToolTip.visible: hovered
                ToolTip.text: root.collapsed ? "展开侧边栏" : "收起侧边栏"
                ToolTip.delay: 500
            }
        }

        // Navigation Items
        Column {
            width: parent.width
            spacing: 2
            topPadding: 8

            NavButton {
                text: "图库"
                iconSource: "qrc:/qml/assets/gallery.svg"
                tabId: "gallery"
                isActive: root.currentTab === "gallery"
                isCollapsed: root.collapsed
                onClicked: root.pageRequested("gallery", "qrc:/qml/pages/GalleryPage.qml", "图库")
            }
            
            NavButton {
                text: "图集"
                iconSource: "qrc:/qml/assets/collection.svg"
                tabId: "collections"
                isActive: root.currentTab === "collections"
                isCollapsed: root.collapsed
                onClicked: root.pageRequested("collections", "qrc:/qml/pages/CollectionsPage.qml", "图集")
            }
            
            // Separator with Label
            Item {
                width: parent.width
                height: 32
                visible: !root.collapsed
                
                Text {
                    text: "管理"
                    font.family: Theme.fontFamily
                    font.pixelSize: 12
                    color: Theme.secondaryTextColor
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                }
            }
             // Spacer for collapsed mode
            Item { width: parent.width; height: 16; visible: root.collapsed }

            NavButton {
                text: "上传"
                iconSource: "qrc:/qml/assets/upload.svg"
                tabId: "upload"
                isActive: root.currentTab === "upload"
                isCollapsed: root.collapsed
                onClicked: root.pageRequested("upload", "qrc:/qml/pages/UploadPage.qml", "上传图片")
            } 
            
            NavButton {
                text: "回收站"
                iconSource: "qrc:/qml/assets/trash.svg"
                tabId: "trash"
                isActive: root.currentTab === "trash"
                isCollapsed: root.collapsed
                onClicked: root.pageRequested("trash", "qrc:/qml/pages/TrashPage.qml", "回收站")
            }

            NavButton {
                text: "后台管理"
                iconSource: "qrc:/qml/assets/settings.svg"
                tabId: "admin"
                isActive: root.currentTab === "admin"
                isCollapsed: root.collapsed
                onClicked: root.pageRequested("admin", "qrc:/qml/pages/AdminPage.qml", "后台管理")
            }
        }
    }
    
    component NavButton: AbstractButton {
        id: navBtn
        property bool isActive: false
        property bool isCollapsed: false
        property string tabId: ""
        property string iconSource: ""
        
        width: parent.width
        height: 44
        
        contentItem: Item {
            // Icon layout
            Item {
                id: iconContainer
                width: 44
                height: 44
                anchors.left: parent.left
                // Center if collapsed, regular left alignment if expanded? 
                // Using left anchor for both allows consistent positioning relative to left edge
                
                Image {
                    anchors.centerIn: parent
                    source: navBtn.iconSource
                    width: 20
                    height: 20
                    sourceSize: Qt.size(20, 20)
                    fillMode: Image.PreserveAspectFit
                    opacity: navBtn.isActive ? 1.0 : 0.6
                    mipmap: true // Smooth scaling
                }
            }

            // Text Label
            Text {
                anchors.left: iconContainer.right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: navBtn.text
                font.family: Theme.fontFamily
                // font.pixelSize: 14 // Default
                font.pixelSize: 13.5
                font.weight: navBtn.isActive ? Font.DemiBold : Font.Normal
                color: navBtn.isActive ? Theme.accentColor : Theme.textColor
                visible: !navBtn.isCollapsed
                opacity: navBtn.isCollapsed ? 0 : 1
                Behavior on opacity { NumberAnimation { duration: 100 } }
                elide: Text.ElideRight
            }
        }
        
        background: Rectangle {
            color: navBtn.isActive ? Qt.lighter(Theme.accentColor, 1.95) : (navBtn.hovered ? Theme.hoverColor : "transparent")
            
            // Left Accent Bar
            Rectangle {
                width: 3
                height: 24
                color: Theme.accentColor
                visible: navBtn.isActive
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                radius: 1.5
            }
        }
        
        ToolTip.visible: hovered && isCollapsed
        ToolTip.text: text
        ToolTip.delay: 200
    }
}
