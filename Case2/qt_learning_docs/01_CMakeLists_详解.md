# CMakeLists.txt 详解

`CMakeLists.txt` 是 CMake 构建系统的配置文件，它描述了如何编译和链接你的 Qt 项目。

## 关键部分解释

### 1. 项目基础设置

```cmake
cmake_minimum_required(VERSION 3.16)
project(Case2 VERSION 0.1 LANGUAGES CXX)
```

- 设定了 CMake 的最低版本要求。Qt 5.15+ 通常建议使用较新版本的 CMake。
- 定义了项目名称 `Case2` 和使用的语言 `CXX` (C++)。

### 2. 工具链与 Qt 自动化

```cmake
set(CMAKE_TOOLCHAIN_FILE D:/CODE/OP/vcpkg/vcpkg/scripts/buildsystems/vcpkg.cmake)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
```

- **vcpkg**: 指定了 `vcpkg` 的工具链文件，这是一个 C++ 包管理器，方便你安装和使用第三方库（如本项目中用到的 `curl`）。
- **AUTOMOC**: 最重要。Qt 使用“元对象系统”（Meta-Object System）来支持信号与槽（Signals & Slots）。任何包含 `Q_OBJECT` 宏的类都需要被 `moc` (Meta-Object Compiler) 预处理。开启此选项让 CMake 自动为你处理。
- **AUTORCC**: 自动处理 `.qrc` 资源文件（将图片、QML 文件打包进 exe）。

### 3. 查找依赖包

```cmake
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS ...)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS ...)
find_package(CURL REQUIRED)
```

- `find_package`: CMake 指令，用于在系统中查找指定的库。
- **Core, Gui, Widgets**: Qt 的基础模块。
- **Quick, Qml**: 支持 QML 界面开发的模块。
- **WebEngine, WebEngineWidgets**: 基于 Chromium 的浏览器引擎，用于在应用中显示网页。
- **WebChannel**: 桥接技术，让 C++ 代码能直接与网页中的 JavaScript 通信。
- **Network**: Qt 自带的网络模块（本项目虽然引入了，但实际主要逻辑是用 curl 实现的）。

### 4. 定义目标与源代码

```cmake
add_executable(Case2 ${PROJECT_SOURCES})
```

- 告诉 CMake 生成一个名为 `Case2` 的可执行文件（exe）。
- `${PROJECT_SOURCES}` 包含了所有的 `.cpp`, `.h`, `.qrc` 文件。

### 5. 链接库

```cmake
target_link_libraries(Case2 PRIVATE ...)
```

-将查找到的库（Qt 的各个模块和 Curl）链接到最终的可执行文件中。

- `PRIVATE` 关键字表示这些依赖只在构建 `Case2` 时需要，不会透过接口传递给其他依赖 `Case2` 的项目（虽然这里 `Case2` 是最终产物，区分不大）。

## 学习建议

对于初学者，**AUTOMOC** 和 **find_package** 是最容易出错的地方。确保你引用的每一个 Qt 模块（如 `QT += widgets` 在 qmake 中）都在 `find_package` 的 `COMPONENTS` 列表里，并且加入到了 `target_link_libraries` 中。
