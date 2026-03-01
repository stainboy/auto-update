#!/bin/bash

# 自动升级脚本
# 每天早上6点执行

LOG_FILE="$HOME/logs/auto-upgrade.log"
mkdir -p "$HOME/logs"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========== 开始自动升级 =========="

# 加载用户配置
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

export HOMEBREW_NO_INSTALL_FROM_API=1
# 使用本地仓库模式，避免 API 下载失败问题
# 加载 nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 1. Homebrew update
log "正在执行: brew update"
if brew update >> "$LOG_FILE" 2>&1; then
    log "✓ brew update 完成"
else
    log "✗ brew update 失败"
fi

# 2. Homebrew upgrade（跳过cask）
log "正在执行: brew upgrade --formula（跳过cask）"
if brew upgrade --formula >> "$LOG_FILE" 2>&1; then
    log "✓ brew upgrade --formula 完成"
else
    log "✗ brew upgrade --formula 失败"
fi

# 3. NVM 安装/更新 Node 24
log "正在执行: nvm install 24"
if nvm install 24 >> "$LOG_FILE" 2>&1; then
    log "✓ nvm install 24 完成"
else
    log "✗ nvm install 24 失败"
fi

# 4. NVM 安装/更新 Node 22
log "正在执行: nvm install 22"
if nvm install 22 >> "$LOG_FILE" 2>&1; then
    log "✓ nvm install 22 完成"
else
    log "✗ nvm install 22 失败"
fi

# 5. OpenClaw 更新
log "正在执行: openclaw update"
if openclaw update >> "$LOG_FILE" 2>&1; then
    log "✓ openclaw update 完成"
else
    log "✗ openclaw update 失败"
fi

log "========== 自动升级结束 =========="
log ""
