# AI Cockpit · 终端 AI 编码驾驶舱

一套开箱即用、Tokyo Night 统一配色的终端环境，专为 **AI 辅助编码** 打造。

打开终端即进入一个三栏「驾驶舱」布局：左侧是你的 AI agent，右上是文件树，右下是实时 Git diff——写代码、看 AI 改了什么、管版本，一屏搞定。

```
┌───────────────────────────┬─────────────────┐
│                           │   📁 Files      │
│                           │   (yazi 文件树)  │
│      🤖 AI Agent          ├─────────────────┤
│      (claude / aider …)   │   🌿 Git Diff   │
│                           │   (lazygit)     │
└───────────────────────────┴─────────────────┘
```

## ✨ 特性

- **AI 驾驶舱布局** — zellij 单窗口三栏：AI agent（70%）+ yazi 文件树 + lazygit 实时 diff。
- **AI agent 可插拔** — 用哪个 agent 由你在安装时指定（claude / aider / opencode / 任意命令），项目不锁定。
- **统一 Tokyo Night 配色** — ghostty、zellij、bat、delta、lazygit、yazi 全部同一套暗色主题。
- **现代 CLI 工具链** — eza、bat、fd、ripgrep、fzf、zoxide、atuin 一次装齐并接好。
- **一条命令、幂等、安全** — 可重复运行；覆盖前自动备份；对 `.gitconfig` / `.zshrc` 只追加不替换。

## 📦 包含的工具

| 工具 | 作用 |
|---|---|
| [ghostty](https://ghostty.org) | GPU 加速终端（含下拉快捷终端） |
| [zellij](https://zellij.dev) | 终端复用器（驾驶舱布局） |
| [yazi](https://yazi-rs.github.io) | 极速文件管理器 |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI（diff 用 delta 渲染） |
| [delta](https://github.com/dandavison/delta) | 更好看的 git diff |
| [atuin](https://atuin.sh) | 可搜索的 shell 历史 |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | 智能目录跳转 |
| [starship](https://starship.rs) | 跨 shell 提示符 |
| bat · eza · fd · ripgrep · fzf | cat / ls / find / grep 的现代替代 |
| [VS Code](https://code.visualstudio.com) | yazi 里回车打开文本/代码文件时调用 `code` |

## 🚀 安装

**要求**：macOS + [Homebrew](https://brew.sh)（脚本会检测，没装会提示先装）。

```bash
git clone <this-repo-url>
cd <repo-dir>
./setup.sh <ai-agent-命令>      # 例：./setup.sh claude
```

`<ai-agent-命令>` 是**必传参数**——即驾驶舱左栏要启动的 AI agent 命令。项目不内置任何 agent，由你决定：`claude`、`aider`、`opencode` 或任意可执行命令。不确定可以先传 `zsh`，之后随时改 `~/.config/zellij/layouts/ai_main.kdl`。

装完**重开一个 ghostty 窗口**即可进入驾驶舱。

## 🎛️ 装好之后

- 终端启动即加载 `ai_main` 驾驶舱布局（zellij 默认布局已设为它）。
- 想要一个干净的单窗口会话：`zellij --layout default`。
- 几个高频快捷键（zellij，`⌥` = Option）：
  - `⌥ ↵` 当前 pane 全屏 / 还原
  - `⌥ Tab` / `⌥ ⇧ Tab` 循环切换 pane
  - `⌥ h/j/k/l` 按方向切 pane
- ghostty `⌘ \`` 唤出/隐藏下拉快捷终端。

## ⚙️ 自定义

- **换 AI agent**：改 `~/.config/zellij/layouts/ai_main.kdl` 左栏的 `command="..."`。
- **换配色**：各工具配置里搜 `tokyo`/`tokyonight` 替换成你喜欢的主题。
- **调整分栏**：`ai_main.kdl` 里改各 pane 的 `size="..."`。

## 🧩 前置依赖（脚本不代装，需自备）

| 项 | 说明 |
|---|---|
| **AI agent 本体** | 你传给 `setup.sh` 的命令需自身可用。未安装时驾驶舱左栏会提示 `command not found`，装好即恢复。 |
| **git 身份** | 脚本只配置 delta 相关键，不会设置你的 `user.name` / `user.email`；首次用 git 请自行设置。 |

## 🛟 设计原则

- **幂等**：可反复运行，不会重复写入。
- **可回滚**：任何被覆盖的既有文件先备份到 `~/.cockpit_backup_<时间戳>/`。
- **不侵入**：`.gitconfig` 用 `git config --add` 追加、`.zshrc` 用带标记的片段追加——都**只增不改**，你原有内容原样保留。

## ❓ 常见问题

- **驾驶舱左栏 `command not found`**：AI agent 命令还没装，或名字不对。装好即可，或改 `ai_main.kdl` 左栏 `command`（如临时改成 `zsh`）。
- **图标显示成方块**：字体未生效。确认 ghostty 使用 JetBrainsMono Nerd Font（Brewfile 已含该字体）。
- **`z` 跳转不准**：zoxide 需要用一段时间积累目录访问记录，属正常现象。
- **atuin 历史为空**：首次安装是干净的历史库，可选 `atuin login && atuin sync` 走官方同步。

## 🙏 致谢

- Tokyo Night 配色移植自 [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)（MIT）——`assets/` 下的 bat / delta 主题及 yazi flavor 均源于此。
- 感谢上文所有工具的作者与社区。

## 📄 License

MIT
