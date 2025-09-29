# Notice
Forked from [repo](https://github.com/LiYulin-s/org.kde.plasma.ypm-lyrics)

由于VutronMusic一直没有KDE插件于是怒学一天qml来fork一个项目适配kde奈何kde寥寥无几的开发资料使我寸步难行最终拼尽全力还是无法战胜配置窗口

在main.qml中修改相关配置：

- trans:是否启用翻译歌词；

- update_time: 歌词更新间隔(ms)；

- seek: 歌词延迟(ms)，可以为负数；

希望有大佬接手项目（自己可能还要学一段时间才能完成配置窗口的编写）

# Installation
```sh
$ git clone https://github.com/cmachsocket/org.kde.plasma.vutronmusic-lyrics.git
$ cd org.kde.plasma.ypm-lyrics.git
$ kpackagetool6 -t Plasma/Applet -i .
```
