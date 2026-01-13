# main.qml 详解

`main.qml` 是用户界面的描述文件。在这个项目中，它不仅是 UI 的容器，更是连接 C++ 后端和 HTML 前端的桥梁。

## 关键组件

### 1. 模块导入

```qml
import QtWebEngine 1.8
import QtWebChannel 1.0
import App 1.0
```

- `QtWebEngine`: 提供了嵌入式浏览器组件。
- `QtWebChannel`: 提供了通信管道机制。
- `App 1.0`: 这是我们在 `main.cpp` 中通过 `qmlRegisterType` 注册的模块命名空间。没有这行，QML 就无法识别 `NetworkManager` 组件。

### 2. NetworkManager 实例化

```qml
NetworkManager {
    id: backend
    WebChannel.id: "networkManager" // 核心绑定
}
```

- 这里我们创建了一个 `NetworkManager` 的实例。
- **`WebChannel.id`**: 这是一个附加属性（Attached Property）。它并不属于 `NetworkManager` 类本身，而是由 WebChannel 模块动态添加的。它定义了该对象在 JavaScript 世界中的变量名。当网页连接上 WebChannel 后，可以通过 `channel.objects.networkManager` 访问这个对象。

### 3. WebChannel 管道

```qml
WebChannel {
    id: channel
    registeredObjects: [backend]
}
```

- `WebChannel` 是一个不可见的逻辑组件。
- `registeredObjects` 数组列出了所有要暴露给 HTML 页面的 QML/C++ 对象。在这里，我们将 `backend` 对象暴露了出去。

### 4. WebEngineView

```qml
WebEngineView {
    url: "qrc:/html/index.html"
    webChannel: channel
}
```

- 这是浏览器视图本身，类似于 Android 的 WebView。
- **`webChannel` 属性**: 这一步完成了最终的连接。它告诉浏览器组件：“除了加载网页，还要建立一个数据通道，通道的另一端是 C++ 层的 `channel` 对象”。
- 网页加载后，会自动注入一个名为 `qt.webChannelTransport` 的 JS 对象（需配合 `qwebchannel.js` 使用），从而建立连接。
