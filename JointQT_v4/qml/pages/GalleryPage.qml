import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import JointQT 1.0
import "../components"
import "../assets"

Page {
    id: root
    background: Rectangle { color: Theme.surfaceColor }

    property bool isGridView: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header Section
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: "所有照片"
                font.family: Theme.fontFamily
                font.pixelSize: 20 // Reduced font size
                font.weight: Font.Bold
                color: Theme.textColor
                Layout.fillWidth: true
            }

            // Using smaller implicit sizes from updated CButton
            CButton {
                text: "网格"
                isPrimary: root.isGridView
                onClicked: root.isGridView = true
            }
            
            CButton {
                text: "列表"
                isPrimary: !root.isGridView
                onClicked: root.isGridView = false
            }
        }

        // View Switcher (Loader)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Loader {
                id: viewLoader
                anchors.fill: parent
                sourceComponent: root.isGridView ? gridComponent : listComponent
                
                NumberAnimation on opacity {
                    from: 0; to: 1; duration: 200
                }
            }
        }
    }

    Component {
        id: gridComponent
        ImageGrid {
            model: AppManager.imageModel
            onImageClicked: {
                // Use StackView.view attached property which works inside items managed by StackView
                StackView.view.push("qrc:/qml/pages/DetailPage.qml", {imageId: id, modelIndex: index})
            }
        }
    }

    Component {
        id: listComponent
        ImageList {
            model: AppManager.imageModel
            onImageClicked: {
                StackView.view.push("qrc:/qml/pages/DetailPage.qml", {imageId: id, modelIndex: index})
            }
        }
    }
}
