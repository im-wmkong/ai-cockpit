# AI Cockpit —— 所需的 Homebrew 包
# 用法：brew bundle --file=Brewfile（由 setup.sh 自动调用）

# 核心工具链
brew "zellij"      # 终端复用器（驾驶舱）
brew "yazi"        # 文件管理器
brew "lazygit"     # git TUI
brew "git-delta"   # git diff 渲染
brew "bat"         # cat 替代（带主题；delta / yazi 预览语法高亮复用其主题）
brew "fd"          # find 替代（yazi 查找依赖）
brew "ripgrep"     # grep 替代（yazi 内容搜索依赖 rg）
brew "fzf"         # 模糊查找（yazi 过滤/跳转依赖）

# yazi 预览依赖（图片/视频/PDF/压缩包）
brew "ffmpeg"      # 视频缩略图
brew "poppler"     # PDF 预览
brew "sevenzip"    # 压缩包预览

# GUI 终端 + 字体
cask "ghostty"                        # 终端本体
cask "font-jetbrains-mono-nerd-font"  # 配置指定字体
