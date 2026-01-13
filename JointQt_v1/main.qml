/*
 * main.qml
 *这是应用程序的主窗口文件。
 *使用 StackLayout 实现多页面切换导航结构。
 */
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import App 1.0

Window {
    width: 1200
    height: 800
    visible: true
    title: "Qt Picture Cloud"
    
    // 全局字体设置 (示例：如果需要加载自定义字体)
    FontLoader { id: localFont; source: "" } 

    // C++ 后端实例
    // 该对象在 main.cpp 中注册，提供了所有网络和数据逻辑
    NetworkManager {
        id: networkManager
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // --- 侧边导航栏区域 ---
        Rectangle {
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: "#2c3e50"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 0
                
                // 1. App 标题区
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "QT PICTURE"
                        color: "white"
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "Segoe UI"
                    }
                }

                // 2. 菜单列表
                ListView {
                    id: menuList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    // 定义菜单项数据
                    model: ListModel {
                        ListElement { name: "图片加入"; icon: "➕"; pageIndex: 0 }
                        ListElement { name: "图片总览"; icon: "🖼️"; pageIndex: 1 }
                        ListElement { name: "图片搜索"; icon: "🔍"; pageIndex: 2 }
                        ListElement { name: "数据后台"; icon: "📊"; pageIndex: 3 }
                    }

                    delegate: Rectangle {
                        width: menuList.width
                        height: 60
                        color: ListView.isCurrentItem ? "#34495e" : "transparent"
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: if (!parent.ListView.isCurrentItem) parent.color = "#34495e"
                            onExited: if (!parent.ListView.isCurrentItem) parent.color = "transparent"
                            onClicked: {
                                menuList.currentIndex = index
                                viewStack.currentIndex = pageIndex
                            }
                        }

                        // Icon placeholder
                        Text {
                             id: iconText
                             anchors.verticalCenter: parent.verticalCenter
                             anchors.left: parent.left
                             anchors.leftMargin: 20
                             text: model.icon
                             color: "white"
                             font.pixelSize: 20
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: iconText.right
                            anchors.leftMargin: 15
                            text: name
                            color: "white"
                            font.pixelSize: 16
                            // font.family: "Microsoft YaHei" // Use system default if not available
                        }
                        
                        // 左侧指示条
                        Rectangle {
                            width: 4
                            height: parent.height
                            color: "#3498db"
                            visible: parent.ListView.isCurrentItem
                        }
                    }
                }
            }
        }

        // 内容区
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#ecf0f1"

            StackLayout {
                id: viewStack
                anchors.fill: parent
                anchors.margins: 20
                currentIndex: 0
                
                PageAdd { }
                PageGallery { }
                PageSearch { }
                PageDashboard { }
            }
        }
    }
}
