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

## Release 产出文件说明

每次构建会自动上传 `bin/targets/` 目录下的全部产物，共 16 个左右，**刷机只需要 `...-squashfs-sysupgrade.bin` 一个**：

| 文件 | 用途 |
|---|---|
| `...-squashfs-sysupgrade.bin` | **主固件**：日常刷机 / LuCI 升级 / `sysupgrade -n` |
| `...-initramfs-factory.ubi`、`...-initramfs-recovery.ubi` | 内存救援镜像（不落盘直接启动），救砖备用 |
| `mt7981/7986/7988-ram-*-bl2.bin` | 各平台 BL2 引导片段（按全系 SoC × DDR 类型生成），进阶救砖自组装引导用；红米 AX6000 只涉及 mt7986，且固件内已内置 |
| `config.buildinfo` / `feeds.buildinfo` / `version.buildinfo` | 本次编译配置与版本快照 |
| `...manifest` | 固件内全部软件包 + 版本清单 |
| `profiles.json` / `sha256sums` | 设备描述（Image Builder / sysupgrade 工具用）/ 校验和 |
| Source code (zip / tar.gz) | GitHub 自带源码包，非编译产物 |

## 构建注意点（踩坑记录）

1. **tmate SSH 调试步骤必须保持注释**：workflow 中的 `Start SSH via tmate` 会原地死等人工 SSH 连接，没人连接就挂到 6 小时被强制取消（编译根本不会开始）。仅排查编译报错时临时放开。
2. **GitHub 免费单任务上限 6 小时**：无法调大。本 workflow 已开启工具链缓存（cachewrtbuild）+ ccache，首次全量编译较慢，之后命中缓存约 2 小时内完成。若首次超时不要慌，缓存已落盘，**直接再触发一次**即可。
3. **只编译一个设备**：`.config` 已精简为仅 `xiaomi_redmi-router-ax6000-ubootmod`。多设备一起编会显著增加编译时间，没必要不要加回来。
4. **Release 权限**：workflow 使用内置 `GITHUB_TOKEN` 并已声明 `permissions: contents: write`，fork 后**无需**手动配置任何 Secret（原仓库的 `GITHUBB_TOKEN` 不会随 fork 继承，已弃用）。
5. **取固件的另一条路**：即使 Release 发布失败，固件也总能在 Actions 运行页面底部的 **Artifacts**（`OpenWrt_firmware_xxx.zip`）下载到。
6. **日志中的无害警告**：`WARNING: Applying padding ... usign SHA-512 bug` 为 ImmortalWrt 已知问题，不影响产物，忽略即可。
7. **安装第三方包/二进制的架构选择**：红米 AX6000（MT7986，4× Cortex-A53）是 **64 位 ARM**，选 `aarch64` / `arm64`（OpenWrt 包架构为 `aarch64_cortex-a53`）；**不要选 ARMv7（32 位）**。
8. **`Install feeds` 阶段的 WARNING 无害**：`Makefile 'xxx' has a dependency on 'yyy', which does not exist` 是 feeds 安装中途的元数据扫描警告（可选依赖、装完即存在），步骤绿勾即可无视。只有 `ERROR:` 或步骤红叉才需要排查。

