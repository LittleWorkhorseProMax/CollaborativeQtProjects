import QtQuick 2.15
import QtQuick.Window 2.15
import QtWebEngine 1.8  // 引入 WebEngine 模块，版本需匹配 Qt 版本
import QtWebChannel 1.0 // 引入 WebChannel 模块
import App 1.0          // 引入我们在 main.cpp 中注册的 C++ 模块

Window {
    width: 1200
    height: 800
    visible: true
    title: "Qt Quick + WebEngine + LibCurl"

    // 实例化 C++ 类 NetworkManager
    // id: 在 QML 中引用该对象的变量名
    NetworkManager {
        id: backend
        
        // 【关键】WebChannel.id 属性
        // 这一行非常重要。它告诉 WebChannel，当这个对象被发布到网页时，
        // 在 JavaScript 端应该叫什么名字 ("networkManager")。
        // JS 使用方式: channel.objects.networkManager.fetchAPI()
        WebChannel.id: "networkManager"
        
        // 信号处理
        // 对应 C++ 中的 dataReceived 信号
        // 语法: on<SignalName> (首字母大写)
        onDataReceived: {
            console.log("QML received data: " + data)
        }
    }

    // 创建 WebChannel 通信管道
    WebChannel {
        id: channel
        // registeredObjects 列表中的对象会被注入到网页的 JS 环境中
        // 这里我们将 backend (NetworkManager实例) 注入进去
        registeredObjects: [backend]
    }

    // 浏览器视图组件
    WebEngineView {
        anchors.fill: parent   // 布局：填满整个窗口
        
        // 加载的页面 URL
        // 使用 qrc:/ 协议从资源系统中加载，这样 html 文件会被打包进 exe，无需分发散文件
        url: "qrc:/html/index.html"
        
        // 绑定 WebChannel
        // 这使得该 WebEngineView 加载的网页能够连接到我们在 QML 中定义的 channel
        webChannel: channel
        
        // 调试设置：允许右键菜单（包括“检查”工具）
        settings.localContentCanAccessRemoteUrls: true
        settings.javascriptEnabled: true
    }
}

