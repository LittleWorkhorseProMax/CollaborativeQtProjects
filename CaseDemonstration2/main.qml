import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    Rectangle{
        id: aaa
        width: 100
        height: 100
        color: "red"
    }
    Rectangle{
        width: 100
        height: 100
        color: aaa.color
        x: 200     //往右边偏移200个像素
    }
}
