### 使用 VSCode 与 Git 协作开发



#### 1. 配置 VSCode 

##### 1.1. ==配置GIT==支持

VSCode 内置 Git 支持。（通常自动检测已安装的 Git？）

> 实际上第一次点击最左下角的><图标，选择 `Open Remote Repository` 之后vscode会自动安装Git支持。
>
> 会出现登录到github的界面？
>
> 会多出一个 `Azure Repos` 插件。（就可以由直接打开远程仓库了）

- 检查“源代码管理选项”出现初始化仓库等几个选项。

> 我的这个选项卡打开后提示“当前没有源代码管理提供程序进行注册”，原因是我之前把vscode内置的git扩展给关了。
>
> 插件搜索 `@builtin` 找到并开启即可。

-  `Ctrl + Shift + P`打开命令面板输入 `Git` 检查其 是否存在。（如果提示安装 Git就装了重启）

- **配置 Git 用户信息**：（如果之前没给git设置过身份信息的话）

  > 打开 VSCode 内置终端，输入：（不是内置也行；这里设置之后vscode在以后推送时 会自动从git获取身份xin'xi）
  >
  > ```bash
  > git config --global user.name "你的用户名"
  > git config --global user.email "你的邮箱@example.com"
  > ```

##### 1.2. ==安装扩展==
- **GitLens**：查看代码历史、谁改了哪行、分支图等。

#### 3. 加入现有项目（克隆远程仓库，最常见协作场景）
别人已经创建了项目，你需要从远程（如 GitHub）拉取代码。

- 在 VSCode 命令面板（`Ctrl + Shift + P`）输入 `Git: Clone`。
- 输入远程仓库 URL（从 GitHub/Gitee 等复制 HTTPS 或 SSH 地址）。
- 选择本地文件夹保存。
- VSCode 会自动克隆并打开项目。
- 如果是私有仓库，会提示登录 GitHub（跟随提示授权）。

克隆后，左侧**源代码管理**视图（图标像分支）会显示项目状态。

#### 4. 新项目：初始化本地仓库并推到远程
如果你们要新建项目：

- 在本地文件夹打开项目（File → Open Folder）。
- 在源代码管理视图点击 **初始化存储库**（Initialize Repository）。
- 添加远程仓库：
  - 先在 GitHub 创建空仓库（不要初始化 README）。
  - 在 VSCode 终端输入：
    ```
    git remote add origin https://github.com/用户名/仓库名.git
    ```
  - 或在源代码管理视图点击 **发布到 GitHub**（Publish to GitHub），VSCode 会帮你创建并推送（需登录 GitHub）。

#### 5. 日常开发流程（多人协作核心）
协作原则：**经常拉取（Pull）更新，避免冲突；开发新功能用分支；用 Pull Request 合并代码**。

1. **拉取最新代码**（必须先做，防止覆盖别人修改）：
   - 在源代码管理视图，点击 **...** → Pull（或同步按钮）。

2. **创建分支开发新功能**（强烈推荐，避免直接在 main/master 上改）：
   - 源代码管理视图下方状态栏显示当前分支，点击它 → Create New Branch。
   - 输入分支名（如 feature/login）。
   - 或命令面板：`Git: Create Branch`。

3. **修改代码、暂存、提交**：
   - 修改文件后，源代码管理视图会显示变化。
   - 点击文件旁的 + 号暂存（Stage）。
   - 或点击顶部 **Stage All Changes**。
   - 在上方输入框写提交消息（描述改了什么），按 `Ctrl + Enter` 提交（Commit）。

4. **推送代码到远程**：
   - 点击 **...** → Push，或同步按钮（云箭头）。

5. **解决冲突**（多人改同一文件时常见）：
   - Pull 时如果冲突，VSCode 会高亮显示。
   - 在文件里选择 **Accept Current**（保留你的）、**Accept Incoming**（保留别人的）、或手动编辑。
   - 解决后暂存并提交。

#### 6. 多人协作：使用 Pull Request（PR，最安全方式）
直接推到 main 可能乱，用 PR 让队友审查。

- 开发完推送分支后，去 GitHub 网站创建 PR（VSCode 扩展更好）。
- 安装 **GitHub Pull Requests and Issues** 扩展后：
  - 左侧出现 Pull Requests 视图。
  - 点击 + 创建 PR，选择目标分支（通常 main）。
  - 填写标题、描述，队友可以评论、批准。
  - 批准后点击 Merge。

#### 7. 其他实用操作
- **查看历史**：源代码管理视图 → Timeline，或用 GitLens 查看每行代码谁改的。
- **切换分支**：状态栏点击分支名。
- **撤销提交**：右键提交历史 → Revert。
- **stash 临时保存**：改到一半想切换分支 → ... → Stash。
- **SSH 免密推送**（推荐，避免每次输入密码）：
  - 生成 SSH 密钥：终端 `ssh-keygen -t ed25519 -C "邮箱"`。
  - 把公钥（~/.ssh/id_ed25519.pub）添加到 GitHub 设置 → SSH keys。

