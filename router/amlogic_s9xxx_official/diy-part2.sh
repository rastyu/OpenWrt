#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic S9xxx STB
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Copyright (C) 2020 https://github.com/P3TERX/Actions-OpenWrt
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#========================================================================================================================

#echo '修改机器名称'
# sed -i 's/qnmlgb/Phicomm-N1/g' package/base-files/files/bin/config_generate

# Add additional packages
git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
git clone https://github.com/project-lede/luci-app-godproxy.git package/luci-app-godproxy
git clone https://github.com/garypang13/luci-app-bypass package/luci-app-bypass
git clone https://github.com/garypang13/smartdns-le package/smartdns-le
git clone https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/toss-a/luci-theme-atmaterial.git package/luci-theme-atmaterial
git clone https://github.com/esirplayground/luci-app-poweroff.git package/luci-app-poweroff
git clone https://github.com/Lienol/openwrt-package.git package/Lienol-package

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
sed -i 's/192.168.1.1/192.168.10.6/g' package/base-files/files/bin/config_generate

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Add branches package from Lienol/openwrt/branches/21.02/package
svn co https://github.com/Lienol/openwrt/branches/21.02/package/{lean,default-settings} package
# Remove duplicate packages
rm -rf package/lean/{luci-app-frpc,luci-app-frps,libtorrent-rasterbar} 2>/dev/null
# Add firewall rules
zzz_iptables_row=$(sed -n '/iptables/=' package/default-settings/files/zzz-default-settings | head -n 1)
zzz_iptables_tcp=$(sed -n ${zzz_iptables_row}p  package/default-settings/files/zzz-default-settings | sed 's/udp/tcp/g')
sed -i "${zzz_iptables_row}a ${zzz_iptables_tcp}" package/default-settings/files/zzz-default-settings
sed -i 's/# iptables/iptables/g' package/default-settings/files/zzz-default-settings
# Set default language and time zone
sed -i 's/luci.main.lang=zh_cn/luci.main.lang=auto/g' package/default-settings/files/zzz-default-settings
#sed -i 's/zonename=Asia\/Shanghai/zonename=Asia\/Jayapura/g' package/default-settings/files/zzz-default-settings
#sed -i 's/timezone=CST-8/timezone=CST-9/g' package/default-settings/files/zzz-default-settings
# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile
# Correct translation for Transmission
sed -i 's/发送/Transmission/g' feeds/luci/applications/luci-app-transmission/po/zh_Hans/transmission.po

# Add luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk package/openwrt-passwall
rm -rf package/openwrt-passwall/{kcptun,xray-core} 2>/dev/null

# Add luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/openwrt-openclash
pushd package/openwrt-openclash/tools/po2lmo && make && sudo make install 2>/dev/null && popd

# Add luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/{luci-app-ssr-plus,shadowsocksr-libev} package/openwrt-ssrplus
rm -rf package/openwrt-ssrplus/luci-app-ssr-plus/po/zh_Hans 2>/dev/null

# Add luci-app-rclone
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk package/openWrt-rclone

# Add luci-app-diskman
svn co https://github.com/lisaac/luci-app-diskman/trunk/applications/luci-app-diskman package/openwrt-diskman/luci-app-diskman
wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -q -P package/openwrt-diskman/parted
pushd package/openwrt-diskman/parted && mv -f Parted.Makefile Makefile 2>/dev/null && popd

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Fix nginx-util
sed -i 's/\[\[fallthrough\]\]\;/\/\* fallthrough \*\//g' feeds/packages/net/nginx-util/src/nginx-ssl-util.hpp

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings

# Default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini} 2>/dev/null
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci

# Modify some code adaptation
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile

# Add luci-theme
# svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-bootstrap-mod package/luci-theme-bootstrap-mod


# ------------------------------- Start Conversion -------------------------------
# Convert translation files zh-cn to zh_Hans
# [CTCGFW]immortalwrt
# Use it under GPLv3, please.
# Convert translation files zh-cn to zh_Hans
# The script is still in testing, welcome to report bugs.

convert_files=0
po_file="$({ find |grep -E "[a-z0-9]+\.zh\-cn.+po"; } 2>"/dev/null")"
for a in ${po_file}
do
    [ -n "$(grep "Language: zh_CN" "$a")" ] && sed -i "s/Language: zh_CN/Language: zh_Hans/g" "$a"
    po_new_file="$(echo -e "$a"|sed "s/zh-cn/zh_Hans/g")"
    mv "$a" "${po_new_file}" 2>"/dev/null"
    let convert_files++
done

po_file2="$({ find |grep "/zh-cn/" |grep "\.po"; } 2>"/dev/null")"
for b in ${po_file2}
do
    [ -n "$(grep "Language: zh_CN" "$b")" ] && sed -i "s/Language: zh_CN/Language: zh_Hans/g" "$b"
    po_new_file2="$(echo -e "$b"|sed "s/zh-cn/zh_Hans/g")"
    mv "$b" "${po_new_file2}" 2>"/dev/null"
    let convert_files++
done

lmo_file="$({ find |grep -E "[a-z0-9]+\.zh_Hans.+lmo"; } 2>"/dev/null")"
for c in ${lmo_file}
do
    lmo_new_file="$(echo -e "$c"|sed "s/zh_Hans/zh-cn/g")"
    mv "$c" "${lmo_new_file}" 2>"/dev/null"
    let convert_files++
done

lmo_file2="$({ find |grep "/zh_Hans/" |grep "\.lmo"; } 2>"/dev/null")"
for d in ${lmo_file2}
do
    lmo_new_file2="$(echo -e "$d"|sed "s/zh_Hans/zh-cn/g")"
    mv "$d" "${lmo_new_file2}" 2>"/dev/null"
    let convert_files++
done

po_dir="$({ find |grep "/zh-cn" |sed "/\.po/d" |sed "/\.lmo/d"; } 2>"/dev/null")"
for e in ${po_dir}
do
    po_new_dir="$(echo -e "$e"|sed "s/zh-cn/zh_Hans/g")"
    mv "$e" "${po_new_dir}" 2>"/dev/null"
    let convert_files++
done

makefile_file="$({ find|grep Makefile |sed "/Makefile./d"; } 2>"/dev/null")"
for f in ${makefile_file}
do
    [ -n "$(grep "zh-cn" "$f")" ] && sed -i "s/zh-cn/zh_Hans/g" "$f"
    [ -n "$(grep "zh_Hans.lmo" "$f")" ] && sed -i "s/zh_Hans.lmo/zh-cn.lmo/g" "$f"
    let convert_files++
done

echo -e "Convert translation files zh-cn to zh_Hans to complete. ${convert_files} in total."

# ------------------------------- End conversion -------------------------------
