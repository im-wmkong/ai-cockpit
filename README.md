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
- **现代 CLI 工具链** — bat、fd、ripgrep、fzf 一次装齐并接好。
- **一条命令、幂等、安全** — 可重复运行；覆盖前自动备份；对 `.gitconfig` / `.zshrc` 只追加不替换。

## 📦 包含的工具

| 工具 | 作用 |
|---|---|
| [ghostty](https://ghostty.org) | GPU 加速终端（含下拉快捷终端） |
| [zellij](https://zellij.dev) | 终端复用器（驾驶舱布局） |
| [yazi](https://yazi-rs.github.io) | 极速文件管理器 |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI（diff 用 delta 渲染） |
| [delta](https://github.com/dandavison/delta) | 更好看的 git diff |
| bat · fd · ripgrep · fzf | cat / find / grep / 模糊查找的现代工具 |

## 🚀 安装

**要求**：macOS + [Homebrew](https://brew.sh)（脚本会检测，没装会提示先装）。

```bash
git clone https://github.com/im-wmkong/ai-cockpit.git
cd ai-cockpit
./setup.sh <ai-agent-命令>      # 例：./setup.sh claude
```

`<ai-agent-命令>` 是**必传参数**——即驾驶舱左栏要启动的 AI agent 命令。项目不内置任何 agent，由你决定：`claude`、`aider`、`opencode` 或任意可执行命令。不确定可以先传 `zsh`，之后随时改 `~/.config/zellij/layouts/ai_main.kdl`。

装完**重开一个 ghostty 窗口**，然后运行 `zellij` 即进入驾驶舱——新窗口默认是普通 shell，不会自动进；因为 zellij 默认布局已设为 `ai_main`，直接敲 `zellij` 就是三栏驾驶舱。

## 🎛️ 装好之后

- 运行 `zellij` 即加载 `ai_main` 驾驶舱布局（已设为 zellij 默认布局，故无需带 `--layout`）。
- 想要一个干净的单窗口会话：`zellij --layout default`。
- 快捷键速查见下方 [⌨️ 快捷键](#️-快捷键)。

## ⌨️ 快捷键

macOS 下 ghostty 已设 `macos-option-as-alt`，所以下表的 `⌥`（Option）就是 zellij 的 `Alt` 修饰键。

**ghostty（终端本体）**

| 按键 | 作用 |
|---|---|
| `Ctrl ↵` | 唤出 / 隐藏下拉快捷终端（随手记命令，不打断 zellij） |

**zellij · 常用（`normal` 模式直接可用）**

| 按键 | 作用 |
|---|---|
| `⌥ h` `⌥ j` `⌥ k` `⌥ l` | 按 左/下/上/右 切换 pane 焦点（也可用方向键 `⌥ ←↓↑→`） |
| `⌥ Tab` / `⌥ ⇧ Tab` | 循环切换 pane（正向 / 反向） |
| `⌥ ↵` | 当前 pane 全屏 / 还原 |
| `⌥ n` | 新建 pane |
| `⌥ f` | 切换浮动 pane 显隐 |
| `⌥ +` / `⌥ -` | 增大 / 缩小当前 pane |
| `⌥ [` / `⌥ ]` | 上一个 / 下一个预设布局 |
| `Ctrl q` | 退出 zellij |

**zellij · 模式切换（先按进入模式，再按操作键，`Esc` / `↵` 返回 normal）**

| 按键 | 进入模式 | 该模式下典型操作 |
|---|---|---|
| `Ctrl p` | pane | `n` 新建、`x` 关闭、`f` 全屏、`d` / `r` 向下 / 向右拆分 |
| `Ctrl n` | resize | `h/j/k/l` 或 `+` / `-` 调整大小 |
| `Ctrl t` | tab | `n` 新建、`x` 关闭、`1`–`9` 跳转、`r` 重命名 |
| `Ctrl s` | scroll | `j` / `k` 滚动、`s` 进入搜索、`Ctrl c` 回到底部 |
| `Ctrl o` | session | `d` detach（挂起会话）、`w` 会话管理器 |
| `Ctrl g` | locked | 锁定全部快捷键，避免误触；再按 `Ctrl g` 解锁 |

> 完整键位以 `~/.config/zellij/config.kdl` 为准；zellij 底部状态栏也会实时提示当前模式的可用键。

## ⚙️ 自定义

- **换 AI agent**：改 `~/.config/zellij/layouts/ai_main.kdl` 左栏的 `command="..."`。
- **换配色**：各工具配置里搜 `tokyo`/`tokyonight` 替换成你喜欢的主题。
- **调整分栏**：`ai_main.kdl` 里改各 pane 的 `size="..."`。
- **改快捷键**：编辑 `~/.config/zellij/config.kdl` 的 `keybinds` 段（本配置用 `clear-defaults=true`，即键位全部自定义，照现有 `bind "..." { ... }` 写法增删即可）。
- **改下拉终端热键**：编辑 `~/.config/ghostty/config` 里的 `keybind = global:control+enter=toggle_quick_terminal`。

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

## 🙏 致谢

- Tokyo Night 配色移植自 [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)（MIT）——`assets/` 下的 bat / delta 主题及 yazi flavor 均源于此。
- 感谢上文所有工具的作者与社区。

## 📄 License

MIT
