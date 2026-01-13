import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    title: "数据后台"
    background: Rectangle { color: "transparent" }
    
    Component.onCompleted: networkManager.fetchDashboardData()

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Label {
            text: "数据后台"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
        }
        
        Button {
            text: "刷新数据"
            onClicked: networkManager.fetchDashboardData()
        }

        Flow {
            Layout.fillWidth: true
            spacing: 20
            
            Repeater {
                model: ListModel { id: dashModel }
                
                Rectangle {
                    width: 250
                    height: 150
                    color: "white"
                    radius: 8
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 10
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: model.value
                            font.pixelSize: 36
                            font.bold: true
                            color: "#27ae60"
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: model.title
                            font.pixelSize: 14
                            color: "#7f8c8d"
                        }
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true } 
    }
    
    Connections {
        target: networkManager
        function onDashboardDataReady(data) {
            dashModel.clear()
            dashModel.append({ title: "总图片数", value: data["totalImages"] })
            dashModel.append({ title: "服务器状态", value: data["serverStatus"] })
            dashModel.append({ title: "今日上传", value: data["uploadCount"] })
            dashModel.append({ title: "存储使用", value: data["storageUsed"] })
        }
    }
}
