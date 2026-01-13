import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../assets"
import "../components"

Page {
    background: Rectangle { color: Theme.surfaceColor }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16
        
        Image {
            source: "qrc:/qml/assets/placeholder.svg"
            Layout.preferredWidth: 200
            Layout.preferredHeight: 150
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            opacity: 0.5
        }
        
        Label {
            text: "已创建的图集"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "固定图集将显示在此处"
            color: Theme.secondaryTextColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
