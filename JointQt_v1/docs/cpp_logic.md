# C++ 核心逻辑文档

## main.cpp

程序的入口点。

### 主要职责

1.  **QApplication 初始化**: 初始化 Qt GUI 应用。
2.  **设置样式**: `QQuickStyle::setStyle("Material");` 启用了 Material Design 风格，提升 UI 质感。
3.  **依赖注入**: 使用 `qmlRegisterType` 将 `NetworkManager` 类注册为 QML 可用的类型 `App.NetworkManager`。
4.  **加载 QML**: 加载 `main.qml` 并启动事件循环。

---

## networkmanager.h / .cpp

核心业务逻辑控制器，负责与“服务器”进行通信。

### 类设计

继承自 `QObject`，使用了 `Q_INVOKABLE` 宏使得方法可以被 QML 直接调用。

### 关键方法

#### 1. `void fetchDashboardData()`

- **功能**: 获取仪表盘统计数据。
- **实现**: 开启新线程模拟网络请求延迟，构造 `QVariantMap` 数据并通过 `dashboardDataReady` 信号发送回主线程。

#### 2. `void fetchImages(const QString &category)`

- **功能**: 根据分类获取图片列表。
- **实现**: 模拟网络请求，返回包含图片 URL 和标题的列表。为了演示效果，使用了 `https://picsum.photos` 随机图片服务。

#### 3. `void searchImages(const QString &keyword)`

- **功能**: 关键词搜索。
- **实现**: 模拟搜索结果返回。

#### 4. `void uploadImage(const QString &path, ...)`

- **功能**: 图片上传与裁剪。
- **技术点**:
  - 使用 `QImage` 加载本地图片。
  - 如果指定了 `x, y, w, h` 参数，则调用 `currImage.copy()` 进行裁剪。
  - 使用 `QBuffer` 将图片转为 PNG 格式的内存字节流。
  - **LibCurl**: 使用 `curl_mime` 构建 `multipart/form-data` 请求，模拟将图片文件上传到 `https://httpbin.org/post`。

### 线程安全

所有耗时操作（API 请求、图片处理）均在 `std::thread` 中执行，避免阻塞 UI 主线程。操作完成后，使用 `QMetaObject::invokeMethod` 将结果通过信号回调到主线程。
