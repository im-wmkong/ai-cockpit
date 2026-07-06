#!/usr/bin/env bash
# ============================================================
# AI Cockpit —— 一键安装脚本
# 用法：./setup.sh <ai-agent-命令>
#   <ai-agent-命令>  必传：zellij 驾驶舱左栏要启动的 AI agent，如 claude / aider / opencode
#   例：./setup.sh claude
# 幂等：可重复运行；已存在的配置会先备份到 ~/.cockpit_backup_<时间戳>/
# ============================================================
set -euo pipefail

# ---------- 必传参数：AI agent 命令 ----------
usage(){
  echo "用法: $0 <ai-agent-命令>"
  echo "  必传参数：zellij 驾驶舱左栏启动的 AI agent 命令。"
  echo "  例：$0 claude    # 或 aider / opencode / 任意可执行命令"
  exit 2
}
[ $# -lt 1 ] && { echo "错误：缺少必传参数 <ai-agent-命令>"; echo; usage; }
AI_AGENT="$1"
case "$AI_AGENT" in
  -h|--help) usage ;;
  "") echo "错误：<ai-agent-命令> 不能为空"; usage ;;
esac

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BK="$HOME/.cockpit_backup_$(date +%Y%m%d_%H%M%S)"
STAMP="# >>> terminal-cockpit >>>"
STAMP_END="# <<< terminal-cockpit <<<"

c_ok(){   printf "\033[32m✔\033[0m %s\n" "$1"; }
c_info(){ printf "\033[36m•\033[0m %s\n" "$1"; }
c_warn(){ printf "\033[33m!\033[0m %s\n" "$1"; }

backup(){  # backup $1 if it exists, preserving into $BK with a flattened name
  local f="$1"
  if [ -e "$f" ]; then
    mkdir -p "$BK"
    local safe; safe="$(echo "${f/#$HOME\//}" | sed 's|/|__|g')"
    cp -R "$f" "$BK/$safe"
  fi
}

install_file(){  # install_file <src> <dst>  (backs up dst first)
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  backup "$dst"
  cp "$src" "$dst"
  c_ok "安装 ${dst/#$HOME/\~}"
}

echo "========== AI Cockpit 安装 =========="
c_info "源目录: $DIR"
c_info "备份目录（如有覆盖）: $BK"
echo

# ---------- 0) 前置：Homebrew ----------
if ! command -v brew >/dev/null 2>&1; then
  c_warn "未检测到 Homebrew，先安装它："
  echo '   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  echo "安装完 brew 后重开终端，再重新运行本脚本。"
  exit 1
fi
c_ok "Homebrew 已就绪：$(brew --version | head -1)"

# ---------- 1) 安装 brew 包 ----------
c_info "安装 Brewfile 中的包（已装的会跳过）..."
if brew bundle --file="$DIR/Brewfile"; then
  c_ok "Brewfile 安装完成"
else
  # brew bundle 返回非零：用 check 精确列出仍未满足的依赖 = 真正安装失败的包。
  # 单独放宽这一步的失败（不因 set -e 中断），后续配置安装是幂等且独立的，值得继续。
  missing="$(brew bundle check --file="$DIR/Brewfile" --verbose 2>/dev/null | grep 'needs to be installed or updated' || true)"
  if [ -n "$missing" ]; then
    c_warn "以下包安装未成功（可能已由非 brew 方式安装，如手动拖入 /Applications 的 app，或下载/编译失败）："
    echo "$missing" | sed 's/^→ /    - /'
    c_info "可手动检查后重跑本脚本；脚本将继续执行后续配置安装。"
  else
    c_ok "Brewfile 依赖均已满足（brew bundle 的非零返回可忽略）"
  fi
fi

# ---------- 2) 安装工具配置 ----------
install_file "$DIR/configs/ghostty-config"      "$HOME/.config/ghostty/config"
install_file "$DIR/configs/zellij-config.kdl"   "$HOME/.config/zellij/config.kdl"
install_file "$DIR/configs/bat-config"          "$HOME/.config/bat/config"
install_file "$DIR/configs/yazi-yazi.toml"      "$HOME/.config/yazi/yazi.toml"
install_file "$DIR/configs/yazi-theme.toml"     "$HOME/.config/yazi/theme.toml"
install_file "$DIR/configs/helix-config.toml"   "$HOME/.config/helix/config.toml"
install_file "$DIR/configs/lazygit-config.yml"  "$HOME/Library/Application Support/lazygit/config.yml"

# zellij 布局：把占位符替换成用户指定的 AI agent 命令
LAYOUT_DST="$HOME/.config/zellij/layouts/ai_main.kdl"
mkdir -p "$(dirname "$LAYOUT_DST")"
backup "$LAYOUT_DST"
sed "s|__AI_AGENT__|$AI_AGENT|g" "$DIR/configs/zellij-ai_main.kdl" > "$LAYOUT_DST"
c_ok "安装 ~/.config/zellij/layouts/ai_main.kdl（AI agent = ${AI_AGENT}）"
command -v "$AI_AGENT" >/dev/null 2>&1 \
  || c_warn "'$AI_AGENT' 当前不在 PATH，zellij 左栏启动时会报 command not found；装好后即可正常使用"

# ---------- 3) 主题资产 ----------
install_file "$DIR/assets/bat-themes/tokyonight_night.tmTheme" "$HOME/.config/bat/themes/tokyonight_night.tmTheme"
install_file "$DIR/assets/delta/tokyonight.gitconfig"          "$HOME/.config/delta/tokyonight.gitconfig"

# bat 缓存重建（让 tokyonight_night 主题生效）
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null 2>&1 && c_ok "bat 主题缓存已重建"
fi

# yazi tokyo-night flavor（用 ya pkg 重新拉取，保证版本一致）
if command -v ya >/dev/null 2>&1; then
  if [ ! -d "$HOME/.config/yazi/flavors/tokyo-night.yazi" ]; then
    ya pkg add BennyOe/tokyo-night >/dev/null 2>&1 && c_ok "yazi tokyo-night flavor 已安装" \
      || c_warn "yazi flavor 安装失败，稍后手动跑：ya pkg add BennyOe/tokyo-night"
  else
    c_ok "yazi tokyo-night flavor 已存在"
  fi
fi

# ---------- 4) git delta 配置（只追加需要的键，不动你已有的身份/URL/其它 include）----------
GITCFG="$HOME/.gitconfig"
if [ -f "$GITCFG" ] && grep -q "path = ~/.config/delta/tokyonight.gitconfig" "$GITCFG" 2>/dev/null; then
  c_ok "git delta 配置已存在，跳过"
else
  c_info "往 ~/.gitconfig 追加 delta 相关键（逐条 git config，不覆盖你的 user/email/URL）"
  git config --global core.pager delta
  git config --global interactive.diffFilter "delta --color-only"
  # --add：追加一条 include，不顶掉你可能已有的其它 [include]
  git config --global --add include.path "~/.config/delta/tokyonight.gitconfig"
  git config --global delta.navigate true
  git config --global delta.side-by-side true
  git config --global delta.line-numbers true
  git config --global delta.syntax-theme tokyonight_night
  git config --global merge.conflictStyle zdiff3
  c_ok "git delta 配置已追加"
  [ -z "$(git config --global user.name || true)" ] && \
    c_warn "别忘了设置 git 身份：git config --global user.name 'xxx'; git config --global user.email 'xxx'"
fi

# ---------- 5) 追加 zshrc 片段（幂等）----------
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"
if grep -qF "$STAMP" "$ZSHRC"; then
  c_ok "zshrc 驾驶舱片段已存在，跳过"
else
  backup "$ZSHRC"
  {
    echo ""
    echo "$STAMP"
    cat "$DIR/configs/zshrc-cockpit.snippet"
    echo "$STAMP_END"
  } >> "$ZSHRC"
  c_ok "已追加驾驶舱片段到 ~/.zshrc"
fi

echo
echo "========== 完成 =========="
c_ok "重开一个 ghostty 窗口让配置生效，然后运行 zellij 进入驾驶舱（默认布局已设为 ai_main）"
c_info "zellij 驾驶舱左栏 AI agent = ${AI_AGENT}"
c_info "手动补充项见 README.md（AI agent 本体、git 身份）"
[ -d "$BK" ] && c_info "被覆盖的旧文件已备份在：$BK"
