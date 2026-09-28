# 红米 AX6000（128M / U-Boot）ImmortalWrt 云编译

红米 AX6000-128M U-Boot 版固件云编译配置，基于 **ImmortalWrt 24.10**（内核 6.6，源码 padavanonly/immortalwrt-mt798x-6.6），MTK 闭源无线驱动，Argon 主题，全套简体中文界面。

## 固件特性

- 默认后台地址：**http://192.168.31.1**
- **不带任何代理 / 科学上网软件**：PassWall、Nikki、OpenClash、AdGuardHome、SSR-Plus 均已在 `.config` 中显式禁用，需要时自行开启
- MTK 硬件加速（HNAT / WED）+ TurboAcc，BBR 拥塞控制，zram 内存压缩
- 可修改代码增加自己需要的插件，直接 fork 即可云编译

## 自带软件

| 软件 | 说明 |
|---|---|
| Lucky | 反向代理 / DDNS / STUN 内网穿透等多合一 |
| SmartDNS | 多上游 DNS 测速加速 |
| vlmcsd (KMS) | 局域网 Windows / Office 激活服务器 |
| WOL | 网络唤醒（etherwake） |
| UPnP | 自动端口映射（miniupnpd） |
| ttyd | 网页终端 |
| 定时重启 (autoreboot) | 计划任务自动重启 |
| wrtbwmon | 按主机实时流量监控 |
| EQoS (MTK 版) | IP 网速限制 |
| TurboAcc (MTK 版) | 网络 / NAT 硬件加速开关 |
| MTWiFi-Cfg | MTK 无线专用配置界面 |
| 包管理器 | 在线安装 / 升级 / 导出软件包 |

## 云编译

1. Fork 本仓库
2. 进入仓库 **Actions** 页面，手动触发 `OpenWrt Builder` workflow（点 Star 也会触发）
3. 编译完成后在 **Releases** 下载固件

## 自定义

- `.config`：软件包选配（编译时 `make defconfig` 会自动补全依赖）
- `diy-part2.sh`：默认 IP / 主机名等修改
- workflow 已预置 **OpenList**、**Tailscale** 的源码拉取步骤，在 `.config` 中加入对应 `CONFIG_PACKAGE_luci-app-openlist=y`、`CONFIG_PACKAGE_luci-app-tailscale=y` 即可启用
