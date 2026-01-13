# NetworkManager 详解 (C++ 与 Web 通信核心)

这个类展示了如何构建一个后端 C++ 模块，使其既能处理复杂的底层任务（如使用 C 语言库 `libcurl`），又能与现代的前端（QML 或 Web 页面）无缝交互。

## 核心机制

### 1. `Q_OBJECT` 宏

任何需要使用 Qt 核心特性（信号与槽、属性系统、元对象反射）的类，都必须继承自 `QObject` 并在私有区域添加 `Q_OBJECT` 宏。没有它，`moc` 编译器将忽略这个类，导致信号槽无法工作。

### 2. `Q_INVOKABLE` 宏

```cpp
Q_INVOKABLE void fetchAPI();
```

默认情况下，C++ 类的成员函数对脚本语言（QML/JavaScript）是不可见的。

- 添加 `Q_INVOKABLE` 后，Qt 的元对象系统会注册该函数的签名。
- 这使得你可以在 QML 中直接调用 `backend.fetchAPI()`。
- 或者在 HTML JS 中通过 WebChannel 调用 `networkManager.fetchAPI()`。

### 3. 信号 (Signals)

```cpp
signals:
    void dataReceived(QString data);
```

- 信号用于“反向”通信：从 C++ 通知 UI 层。
- 只有函数声明，没有实现体。
- 当任务完成时（如网络请求结束），调用 `emit dataReceived(result)`。
- UI 层通过“槽”（Slot）连接到这个信号来接收数据。

### 4. 集成 libcurl

由于 Qt 自带的 `QNetworkAccessManager` 是异步的，有时为了集成遗留代码或特定需求，我们可能会用 `libcurl`。

- **WriteCallback**: `libcurl` 是 C 语言库，回调函数必须是 C 风格的函数指针。因此我们将其声明为 `static` 成员函数。
- **注意事项**: 示例中直接在 `fetchAPI` 里调用 `curl_easy_perform`，这是一个**阻塞操作**。在实际 GUI 开发中，绝对禁止在主线程（UI 线程）做耗时操作，否则界面会“卡死”。正确的做法是将耗时任务放入 `QThread` 或 `QtConcurrent::run` 中运行。

### 5. WebChannel 集成准备

通过在 `main.qml` 中设置 `WebChannel` 并注册此对象，我们可以让嵌入在 `WebEngineView` 中的网页 JS 像调用本地 JS 对象一样调用这个 C++ 类。
