# main.cpp 详解

`main.cpp` 是程序的入口点，主要负责初始化 Qt 环境、WebEngine 引擎，并将 C++ 类暴露给 QML。

## 关键技术点

### 1. QApplication vs QGuiApplication

通常纯 QML 应用使用 `QGuiApplication`。但是，**QtWebEngine** 模块依赖于 Qt Widgets 模块的部分功能，因此必须使用 `QApplication`。

```cpp
QApplication app(argc, argv);
```

### 2. Qt WebEngine 初始化

```cpp
QtWebEngine::initialize();
qputenv("QTWEBENGINE_REMOTE_DEBUGGING", "9222");
```

- `initialize()`: 必须在 QApplication 创建前（或紧随其后）调用，用于初始化 Chromium 内核。
- **远程调试**: 设置环境变量 `QTWEBENGINE_REMOTE_DEBUGGING` 允许你在 Chrome 浏览器中访问 `localhost:9222` 来调试你 App 里的网页。这对混合开发非常有用，因为你能在外部浏览器里看到 Console 输出和网络请求。

### 3. C++ 与 QML 交互：`qmlRegisterType`

```cpp
qmlRegisterType<NetworkManager>("App", 1, 0, "NetworkManager");
```

这是将 C++ 类暴露给 QML 的核心方法之一。

- **作用**: 它定义了一个新的 QML 类型 `NetworkManager`。
- **使用**: 在 QML 文件中，你可以先 `import App 1.0`，然后像使用 `Rectangle` 一样使用 `NetworkManager {}`。
- **生命周期**: 每次在 QML 中写一个 `NetworkManager {}`，C++ 就会 `new` 一个 `NetworkManager` 对象。

**对比 ContextProperty**:
代码中注释掉的 `setContextProperty` 是另一种方式。

- `setContextProperty`: 注入一个已经存在的对象实例到 QML 全局。适合单例（如全局配置）。
- `qmlRegisterType`: 注册类，由 QML 控制实例化。适合组件化开发。

### 4. 加载 QML

```cpp
QQmlApplicationEngine engine;
engine.load(url);
```

`QQmlApplicationEngine` 是加载和管理 QML 文件的核心类。它将 `.qml` 文件解析并构建对象树。
