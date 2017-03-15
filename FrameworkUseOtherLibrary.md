
主题：iOS生成framework总结几种情况及爬坑:

一.纯OC语言环境下生成framework
  1.framework中不使用其他三方库: 将自己项目需要向外界提供使用的.h文件, 添加到系统默认生成的.h文件中: #import "aaaaaa.h"，并将build Phases里Private中需要对外提供的头文件拖拽到Public中(个人理解：如果对外暴露的文件中import别的文件，那么也需要把import的文件也暴露出来)
  2.framework中使用其他三方库:与.1的方式相同(主项目与framework包含同样的三方库会报重复警告⚠️, 但是仍可正常使用)

二.纯swift语言环境生成framework
  1.framework中不使用其他三方库: 直接编辑即可
  2.framework中使用其他三方库: 未尝试过

三.Swift混编OC的三方库，生成framework

  1.如果直接把OC的三方库打包给主程序使用，同时主程序包含同样的三方库，会造成程序错误，不建议尝试. 
  2.使用cocoapods管理三方库，打包framework:
    a.cocoapods podfile配置:
        workspace 'WorkSpace'
        project 'MainApp/MainApp.xcodeproj'
        target 'MainApp' do
        use_frameworks!
        platform :ios, '8.0'
        pod 'AFNetworking', '~> 3.1.0'
        project 'MainApp/MainApp.xcodeproj'
        end
    b.系统默认生成的.h文件中import oc的三方库:
        #import "AFNetworking.h"
    c.必须在build Phases里，把Public中加入<系统默认生成的.h文件中import oc的三方库>的头文件, 加入引用关系, "+"->add other->pods->AFNetworking->....h, 然后生成framework(ps: 因为我导入的是AFNetworking.h这个文件,所以要把AFNetworking.h中所有引用的文件.h都放到public中)
    d.编译成framework，其他人只需要在主项目中用pod引入你需要的三方库即可

