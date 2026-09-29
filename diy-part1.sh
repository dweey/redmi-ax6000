#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#rm -rf feeds/packages/net/v2ray-geodata
#find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
#find ./ | grep Makefile | grep mosdns | xargs rm -f
#git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
#git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# lucky 不在 immortalwrt 的 packages/luci feed（openwrt-24.10 与 master 分支均无），
# .config 中的 CONFIG_PACKAGE_luci-app-lucky=y 若包不存在会在 make defconfig 时被静默丢弃。
# 这里手动 clone 到 package/ 目录（仓库内含 luci-app-lucky 界面包 + lucky 主程序包）。
git clone --depth=1 https://github.com/sirpdboy/luci-app-lucky package/luci-app-lucky



