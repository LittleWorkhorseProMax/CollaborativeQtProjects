# 前端交互详解 (HTML/JS)

为了实现从 HTML 页面调用 C++ 函数，Qt 提供了一套名为 `QWebChannel` 的机制。这需要前端 JavaScript 和后端 C++/QML 配合。

## 核心文件：`qwebchannel.js`

HTML 页面中必须引入 `<script src="qwebchannel.js"></script>`。这是一个 Qt 官方提供的 JS 库，用于在浏览器端建立通信协议。

## 初始化流程

### 1. `qt.webChannelTransport`

当页面在 Qt 的 `WebEngineView` 中加载，并且 `WebEngineView` 绑定了 `webChannel` 属性时，Qt 内部会向页面的 `window` 对象注入一个名为 `qt` 的全局对象，其中包含了 `webChannelTransport`。这是底层的通信管道。

### 2. 建立连接

```javascript
new QWebChannel(qt.webChannelTransport, function (channel) {
  // 回调函数：连接成功时执行
  // channel.objects 包含了所有后端暴露的对象
  backend = channel.objects.networkManager;
});
```

- JS 代码创建一个 `QWebChannel` 对象，传入 transport。
- 回调函数中的 `channel.objects` 映射了 QML 中 `WebChannel` 组件的 `registeredObjects` 列表。
- `networkManager` 这个名字对应了 QML 中设置的 `WebChannel.id`。

## 通信方式

### 1. JS 调用 C++ (方法调用)

一旦获取了 `backend` 对象，你就可以直接调用其成员函数，就像调用本地 JS 函数一样：

```javascript
backend.fetchAPI();
```

前提是 C++ 类中的该函数必须标记为 `Q_INVOKABLE`。

### 2. C++ 通知 JS (信号连接)

C++ 的信号在 JS 端表现为具有 `connect` 方法的对象：

```javascript
backend.dataReceived.connect(function (msg) {
  console.log("收到数据: " + msg);
});
```

当 C++ 端执行 `emit dataReceived("Hello")` 时，JS 端的回调函数就会被触发。

## 总结

整个调用链如下：

1. **用户**点击 HTML 按钮 -> 调用 JS `fetchData()`。
2. **JS** 调用 `backend.fetchAPI()` -> 通过 WebChannel 发送消息给 Qt。
3. **Qt/C++** 执行 `NetworkManager::fetchAPI()` -> 使用 `libcurl` 发起网络请求。
4. **C++** 请求完成 -> `emit dataReceived(response)`。
5. **Qt** 通过 WebChannel 将信号转发给 JS。
6. **JS** 的 `connect` 回调被触发 -> 更新 DOM 显示数据。
