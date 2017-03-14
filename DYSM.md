
Bugly 友盟上手动上传符号表，确定崩溃位置

1. 出错堆栈信息找到 App UUID: B9BBD7D86F133A53A8A441FB596B5676 (如Bugly在其他信息中)
2. 进入目录 Xcode-window-organizer-archieves-发布的应用-showInFinder-xxxx.xcarchive-显示包内容
3. dwarfdump --uuid xxxx.app.dSYM 查看uuid是否包含1，如果包含可以继续，否则选择正确的包
4. 继续点击 显示包内容-contents-Resources-DWARF-xxxxxx
5. 把找到的文件打包成zip上传Bugly等平台符号表
