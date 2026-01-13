#设置CMake需要的最低版本，QT5.15通常需要较新的CMake
cmake_minimum_required(VERSION 3.16)

# 定义项目名称、版本和语言（CXX表示C++）
project(Case2 VERSION 0.1 LANGUAGES CXX)

# 设置vcpkg工具链文件路径，用于管理第三方库（如curl）
set(CMAKE_TOOLCHAIN_FILE D:/CODE/OP/vcpkg/vcpkg/scripts/buildsystems/vcpkg.cmake)

# 打开Qt的自动处理机制：
# AUTOMOC: 自动处理使用Q_OBJECT宏的类，生成moc_xxx.cpp
# AUTOUIC: 自动处理.ui文件，生成ui_xxx.h（本项目主要用QML，可能用不到，但保留无妨）
# AUTORCC: 自动处理.qrc资源文件，生成qrc_xxx.cpp
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# 设置Qt安装目录，确保CMake能找到Qt库
set(QT_DIR D:/software/Qt/5.15.2/msvc2019_64)

# 设置C++标准为C++17，并强制要求编译器支持
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 查找Qt库及其组件
# REQUIRED表示如果找不到这些组件，配置过程将失败
# Core: 核心非GUI功能
# Quick: QML运行环境
# Gui: GUI基础
# Qml: QML引擎
# WebEngine/WebEngineWidgets: 嵌入式浏览器引擎
# Network: 网络模块（Qt自带）
# WebChannel: 用于C++与网页JS通信
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Gui Qml WebEngine WebEngineWidgets Network WebChannel)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Gui Qml WebEngine WebEngineWidgets Network WebChannel)

# 查找第三方库Curl，项目中使用它来进行网络请求
find_package(CURL REQUIRED)

# 定义项目的所有源文件
set(PROJECT_SOURCES
        main.cpp
        qml.qrc              # 资源文件，包含QML和HTML等资源
        networkmanager.h     # 网络管理类的头文件
        networkmanager.cpp   # 网络管理类的实现文件
)

# 针对Qt6和Qt5的不同构建处理
if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(Case2
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        # Android平台通常构建为共享库
        add_library(Case2 SHARED
            ${PROJECT_SOURCES}
        )
    else()
        # 桌面平台构建为可执行文件
        add_executable(Case2
          ${PROJECT_SOURCES}
        )
    endif()
endif()

# 将Curl的头文件包含目录添加到目标中
target_include_directories(Case2 PRIVATE ${CURL_INCLUDE_DIRS})

# 链接所需的库文件
target_link_libraries(Case2
    PRIVATE
    ${CURL_LIBRARY}      # Curl库
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::WebEngine
    Qt${QT_VERSION_MAJOR}::WebEngineWidgets
    Qt${QT_VERSION_MAJOR}::Network
    Qt${QT_VERSION_MAJOR}::WebChannel
    ${CURL_LIBRARIES}    # Curl依赖
  )

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
if(${QT_VERSION} VERSION_LESS 6.1.0)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.Case2.Case2)
endif()
set_target_properties(Case2 PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS Case2
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(Case2)
    qt_finalize_executable(Case2)
endif()
