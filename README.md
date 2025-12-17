# Notice
Forked from [repo](https://github.com/LiYulin-s/org.kde.plasma.ypm-lyrics)

由于VutronMusic一直没有KDE插件于是怒学一天qml来fork一个项目适配kde奈何kde寥寥无几的开发资料使我寸步难行最终拼尽全力还是战胜了配置窗口

配置窗口的代码参考了[这里](https://github.com/zsiothsu/org.kde.plasma.yesplaymusic-lyrics)


## Installation:

手动安装：

```bash
git clone https://github.com/cmachsocket/org.kde.plasma.vutronmusic-lyrics.git
cd qtodo
make install # use 'make clean' to uninstall
```
or you can copy the folder to `~/.local/share/plasma/plasmoids/` manually.

通过AUR安装：

```bash
yay -S plasma6-applets-vutronmusic-lyrics
```

## update:

2025-12-16 : 添加了最大窗口大小和固定窗口大小的选项，并修复了歌词在前奏的时候仍然显示上一句歌词的问题。没有第二行的时候第一行居中。现在可以通过make命令来管理插件的安装和卸载。
2025-12-17 : 现已加入AUR