set(DCMAKE_TOOLCHAIN_FILE D:/CODE/OP/vcpkg/vcpkg/scripts/buildsystems/vcpkg.cmake)
cmake_minimum_required(VERSION 3.16)

project(JointQT_v4 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(QT_DIR D:/software/Qt/5.15.2/msvc2019_64)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Network Widgets QuickControls2)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Network Widgets QuickControls2)

find_package(CURL REQUIRED)

# if(CURL_FOUND)
#     message(STATUS "CURL found: ${CURL_INCLUDE_DIRS}")
# else()
#     message(WARNING "CURL not found. Please install via vcpkg: vcpkg install curl")
# endif()

# Source files
set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        src/network/NetworkManager.h
        src/network/NetworkManager.cpp
        src/models/ImageModel.h
        src/models/ImageModel.cpp
        src/managers/AppManager.h
        src/managers/AppManager.cpp
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(JointQT_v4
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(JointQT_v4 SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(JointQT_v4
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(JointQT_v4
  PRIVATE 
  Qt${QT_VERSION_MAJOR}::Core 
  Qt${QT_VERSION_MAJOR}::Quick
  Qt${QT_VERSION_MAJOR}::Network
  Qt${QT_VERSION_MAJOR}::Widgets
  Qt${QT_VERSION_MAJOR}::QuickControls2
)

if(CURL_FOUND)
    target_link_libraries(JointQT_v4 PRIVATE CURL::libcurl)
    target_compile_definitions(JointQT_v4 PRIVATE USE_LIBCURL)
endif()

if(${QT_VERSION} VERSION_LESS 6.1.0)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.JointQT_v4)
endif()
set_target_properties(JointQT_v4 PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS JointQT_v4
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(JointQT_v4)
    qt_finalize_executable(JointQT_v4)
endif()
