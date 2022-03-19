<a href="https://github.com/rastyu/s905x3-openwrt/releases/tag/x86_64" title="x86_64"><img src="https://img.shields.io/badge/openwrt-x86_64-7FFF00"></a>
<a href="https://github.com/rastyu/s905x3-openwrt/releases/tag/AX6" title="AX6"><img src="https://img.shields.io/badge/openwrt-AX6-7FFF00"></a>
<a href="https://github.com/rastyu/s905x3-openwrt/releases/tag/armv8_mini" title="HK1固件 Releases"><img src="https://img.shields.io/badge/openwrt-HK1固件-7FFF00"></a>
<a href="https://github.com/rastyu/s905x3-openwrt/releases/tag/ARMv8_ROOTFS" title="HK1底包 Releases"><img src="https://img.shields.io/badge/openwrt-HK1底包-7FFF00"></a>
## 个人定制编译amlogic-s905x3-openwrt固件仓库

# 第6条
#  
- 单独拉取特定的插件或者文件，比如单独拉取插件包的luci-app-clash

      svn co https://github.com/281677160/openwrt-package/trunk/luci-app-clash package/luci-app-clash
      
- 这个关系就跟上面差不多了，就不多说了，重点要说的是这个链接是有改变的，怎么改变法呢？整个链接真正的链接看下面的，这个原始链接怎么来呢?比如你在别人的仓库看到某个插件，再点开那个插件的文件夹，然后在浏览器复制完整链接就是了。如果有分支的，你想要分支的插件，就先选择了分支再打开插件文件夹然后在复制链接就可以了。

      https://github.com/281677160/openwrt-package/tree/master/luci-app-clash  <--- 在浏览器上复制出来的真正链接
      
      https://github.com/281677160/openwrt-package/trunk/luci-app-clash        <--- 用的时候修改过的链接，认真对比一下就懂了
      
- 大家看清楚没有？链接里面是带有分支名称的，还有一个tree，就是这个了 tree/master 把这里替换成 trunk 就可以了，主仓库就这样拉取，如果要拉取分支的呢？也简单的，把tree改成branches就行，比如
     
      https://github.com/281677160/openwrt-package/tree/19.07/luci-app-eqos   <--- 在浏览器上复制出来的真正链接
      
      https://github.com/281677160/openwrt-package/branches/19.07/luci-app-eqos   <--- 用的时候修改过的链接

      svn co https://github.com/281677160/openwrt-package/branches/19.07/luci-app-eqos package/luci-app-eqos  <--- 完整拉取链接

## 本地Ubuntu一键编译脚本,全程无脑操作,只要梯子质量过关就好了

- ### 说明：
- github已筑墙,所以国内用户编译全程都需要梯子,请准备好梯子,使用大陆白名单或全局模式
- 请使用 Ubuntu 18.04 LTS 或 Ubuntu 20.04 LTS
- 使用非root用户登录您的ubuntu系统,执行以下代码即可:

- 首次编译:
```
wget -O compile.sh https://raw.githubusercontent.com/281677160/common/main/compile.sh && chmod +x compile.sh && bash compile.sh
```

- 再次编译:
```
bash openwrt/recompile.sh
```

---

问：进入一键本地编译系统后叫我选择编译源码，我该任何选择？<br />
答：我[这里](https://github.com/danshui-git/shuoming/blob/master/%E7%AE%80%E5%8D%95%E4%BB%8B%E7%BB%8D%E6%96%B0%E8%84%9A%E6%9C%AC.md)作了简单介绍，当然本地编译是不支持自建文件夹来增加机型的，云编译你们拉取了我仓库后可以随便自建。<br />
#

问：设置openwrt的IP地址是什么意思？<br />
答：这个地址就是用来登录你openwrt用的，需要什么IP是根据你个人需要，固件编译完成，你安装好固件后，在浏览器输入此IP就可以登录openwrt了，默认帐号是root，默认密码为空。<br />
#

问：询问我是否需要选择机型和增删插件，是什么意思？<br />
答：在我设置里面每个源码默认编译都是x86-64的机型固件，不适合所有人的，这个就是进入设置界面，如果你设置需要就输入‘大小写的Y都可以，按回车确认’，等脚本运行到此步骤就自动弹出窗口，如果不需要就直接按回车就跳过了，《[youtube大神的固件配置视频教程](https://www.youtube.com/watch?v=jEE_J6-4E3Y)》视频跟不上源码的节奏的，你也不能按视频操作，就看看在那里修改机型，那里增加减少插件，增加主题就好了。
#

问：询问我是否把定时更新插件编译进固件，是什么意思？<br />
答：这个在本地编译增加就是个娱乐的，因为我云编译程序是会自动把固件传送到指定位置，安装好固件后就能检测了，本地编译想用的话，只能编译好又手动传到指定位置，就给闲的蛋痛的人玩的，怎么在本地编译又能自动传github的指定位置，这个我不会啊，有懂的可以把代码贡献一下的，谢谢！
#

问：再次编译的时候询问我是否更换源码，是什么意思？<br />
答：就字面上的意思，比如你首次编译的时候选择的是Lede_source源码，你玩腻了，想换其他源码编译就可以换呗。
#

问：再次编译的时间需要那么长呢？人家都几分钟，几十分钟就可以，我还是要3-4个小时？<br />
答：因为我这是跟云编译一样操作，每次编译都是下载最新源码跟插件的，这样比较不容易出现错误，我测试了几十次二次编译，很容易出现build_dir和staging_dir错误，要清除了这些文件再编译才成功，清除了这些其实就是又回到了首次编译的操作，一样要3-4个小时来编译，还不如每次都重新拉取源码跟插件了，只保存你的配置不变，还有DL文件夹，其他都删除了。
#

## Acknowledgments
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [Lienol/openwrt](https://github.com/Lienol/openwrt)
- [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit)
- [tuanqing/mknop](https://github.com/tuanqing/mknop)
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [ophub/amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt)

git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/vernesong/OpenClash.git package/OpenClash
git clone https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot
git clone https://github.com/riverscn/openwrt-iptvhelper.git package/openwrt-iptvhelper
git clone https://github.com/esirplayground/luci-app-poweroff.git package/luci-app-poweroff  
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone https://github.com/thinktip/luci-theme-neobird.git package/luci-theme-neobird
git clone https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
