# CMakeLists.txt 构建配置文档

该文件是项目的构建定义文件，使用 CMake 管理。

## 关键配置解析

### 1. 项目基本信息

```cmake
cmake_minimum_required(VERSION 3.16)
project(Example VERSION 0.1 LANGUAGES CXX)
```

定义了项目名称 `Example` 和使用的语言 `C++`。

### 2. Qt 环境设置

```cmake
set(QT_DIR D:/software/Qt/5.15.2/msvc2019_64)
# ...
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Gui Qml Network)
```

项目兼容 Qt5 和 Qt6。关键依赖模块：

- **Core/Gui**: 基础模块。
- **Qml/Quick**: 用于 QML 界面渲染。
- **QuickControls2**: 现代化的 UI 控件库。
- **Network**: Qt 网络模块（虽然主要逻辑使用了 LibCurl，但 Qt Network 也被引入）。

### 3. LibCurl 集成

```cmake
find_package(CURL REQUIRED)
target_include_directories(Example PRIVATE ${CURL_INCLUDE_DIRS})
target_link_libraries(Example PRIVATE ... ${CURL_LIBRARIES})
```

使用 `find_package` 查找系统中的 Curl 库，并链接到项目中。LibCurl 用于处理复杂的 HTTP 请求（如文件上传）。

### 4. 目标定义

```cmake
qt_add_executable(Example ...)
```

根据 Qt 版本不同，使用 `qt_add_executable` (Qt6) 或 `add_executable` (Qt5) 生成可执行文件。

### 5. 资源文件

`qml.qrc` 被包含在源文件中，这确保了 QML 文件被编译进二进制文件中，方便发布。
