# QML 界面结构文档

项目采用纯 QML (Qt Quick) 构建界面，使用了 `QtQuick.Controls 2` 模块。

## 1. main.qml (主窗口)

- **布局**: 使用 `RowLayout` 分为左右两部分。
  - **左侧 (250px)**: 侧边导航栏。自定义了暗色背景 (`#2c3e50`) 和列表项高亮效果。
  - **右侧**: 内容区域，使用 `StackLayout` 管理多页面切换。
- **导航逻辑**: `ListView` 的点击事件修改 `StackLayout` 的 `currentIndex`，实现页面无缝切换。

## 2. PageAdd.qml (图片加入)

- **功能**: 图片选择与上传。
- **交互**:
  - 使用 `FileDialog` 选择本地图片。
  - 加载图片后，显示一个**可拖动的矩形框** (`Rectangle` + `MouseArea` drag) 模拟裁剪区域。
  - 点击“裁剪并上传”时，将裁剪框相对于图片的坐标传给后端。

## 3. PageGallery.qml (图片总览)

- **布局**: 使用 `GridView` 展示图片网格。
- **功能**: 顶部包含下拉筛选框 (`ComboBox`)。
- **数据流**: 页面加载完成 (`Component.onCompleted`) 或筛选改变时，调用 `networkManager.fetchImages`。

## 4. PageSearch.qml (图片搜索)

- **结构**: 使用 `TabBar` + `StackLayout` 在“关键词搜索”和“以图搜图”之间切换。
- **以图搜图**: 包含一个虚线边框的拖拽/点击区域（UI 模拟），点击后选择图片并调用 `searchByImage`。

## 5. PageDashboard.qml (数据后台)

- **布局**: 使用 `Flow` 布局自动排列统计卡片。
- **数据**: 展示从后端获取的服务器状态、存储使用量等模拟数据。
