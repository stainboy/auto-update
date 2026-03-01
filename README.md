# Daily Update

每天早上6点自动升级开发环境的定时任务系统。

## 功能

- **Homebrew**: 更新 formula 索引并升级所有 formula（跳过需要 sudo 的 cask）
- **NVM**: 安装/更新 Node.js 22 和 24

## 安装

```bash
# 1. 创建日志目录
mkdir -p ~/logs
mkdir -p ~/scripts

# 2. 创建软链接（脚本已经在 ~/scripts/ 下创建链接）
ln -sf $PWD/auto-upgrade.sh ~/scripts/auto-upgrade.sh

# 3. 复制 plist 到 LaunchAgents
cp com.user.auto-upgrade.plist ~/Library/LaunchAgents/

# 4. 加载定时任务
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.auto-upgrade.plist
```

## 使用

```bash
# 立即手动运行
~/scripts/auto-upgrade.sh

# 查看定时任务状态
launchctl print gui/$(id -u) | grep com.user.auto-upgrade

# 停止定时任务
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.user.auto-upgrade.plist

# 重新启动定时任务
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.auto-upgrade.plist
```

## 日志

- 主日志: `~/logs/auto-upgrade.log`
- 守护进程日志: `~/logs/auto-upgrade-daemon.log`
- 错误日志: `~/logs/auto-upgrade-error.log`

## 文件说明

- `auto-upgrade.sh` - 自动升级脚本
- `com.user.auto-upgrade.plist` - macOS launchd 配置文件
- `README.md` - 本文档

## 技术说明

使用 macOS 的 `launchd` 系统服务管理定时任务，替代传统的 `cron`。
使用新的 `launchctl bootstrap/bootout` 命令管理任务（load/unload 已废弃）。
