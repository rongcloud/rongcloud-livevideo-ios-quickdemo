<h1 align="center"> 直播秀QuickDemo  </h>

<p align="center">
<img src="https://img.shields.io/cocoapods/v/RCLiveVideoLib.svg?style=flat" style="max-width: 100%;">
<img src="https://img.shields.io/cocoapods/p/RCLiveVideoLib.svg?style=flat" style="max-width: 100%;">
<img src="https://img.shields.io/cocoapods/l/RRCLiveVideoLib.svg?style=flat" style="max-width: 100%;">
</p>

## 简介

直播秀QuickDemo, 是融云针对视频直播场景设计的 SDK(RCLiveVideoLib),快速开箱使用示例。融合 RongIMLib 和 RongRTCLib 实现视频直播场景，将复杂逻辑（订阅和发布流、上下麦、连麦布局等）进行了封装，初步展示。

## 环境要求
 * Xcode：确保与苹果官方同步更新
 * CocoaPods：1.10.0 及以上 [^脚注1]
 * iOS：11.0 及以上

## 目录结构
![](https://tva1.sinaimg.cn/large/e6c9d24ely1h1aoffh2zjj21dc0u0n0b.jpg)

tip: 完整脑图请查看-> [^脚注2]

## QuickDemo快速启动

1. 为了方便您快速运行quickdemo，我们为您预置了融云 appkey 和 对应的测试服务器url，您不需要自己部署测试服务器即可运行。
2. 申请  `BusinessToken`   
   1. BusinessToken 主要是防止滥用 quickdemo 里的测试appKey，我们为接口做了限制，一个 BusinessToken 最多可以支持10个用户注册，20天使用时长。点击此处 [获取BusinessToken](https://rcrtc-api.rongcloud.net/code)
   2. 过期后您的注册用户会自动移除，想继续使用 quickdemo 需要您重新申请 BusinessToken
   3. 成功获取到 BusinessToken 后，替换 LVSDefine.h 中定义的 BusinessToken

      1. `cmd + shift + o` (快速定位)[^脚注3] ,弹出窗口输入`LVSDefine` 回车;即可快速定位 LVSDefine.h 文件
      2.  替换成功获取的BusinessToken宏定义
           
            ```objc
                static NSString *const LVSLoginSuccessNotification = @"LVSLoginSuccessNotificationIdentifier";
                
                //融云官网申请的 app key
                #define lvsAppKey  @"pvxdm17jpw7ar"
                
                //请前往 https://rcrtc-api.rongcloud.net/code 获取 BusinessToken
                #define BusinessToken  <#BusinessToken#> //这里替换成功获取到 BusinessToken
            ```
        3. 截图示意:
           ![](https://tva1.sinaimg.cn/large/e6c9d24ely1h1agh6lkgsj20wk07xgmm.jpg)
 1. `Cmd+R` 即可模拟器运行
 2. 输入手机号,点击登录;即可快捷登录;进入直播秀列表房间,直接进如房间,或者`Start live`,开始直播。(苹果模拟器不支持摄像头,建议用真机调试直播)
 3. Enjoy yourself 😊

> 示例代码展示了更详细的api调用

## 其他

如有任何疑问请提交 issue

[^脚注1]:集成视频直播 SDK 打包增量大概 6 M（包含依赖库 IM 和 RTC）;
 RCLiveVideoLib 依赖IMLib和RTCLib ,依赖版本如下
    * IMLib , '~> 5.1.7'
    * RTCLib, '~> 5.1.16.1'
    * RongRTCPlayer  #必须和 RTCLib 保持一致


[^脚注2]:livevideosdk-quickdemo主目录思维导图-相关链接: [https://rongcloud.yuque.com/docs/share/38847795-dde2-4034-a621-0cede4de3144?# 《livevideosdk-quickdemo主目录脑图》](https://rongcloud.yuque.com/docs/share/38847795-dde2-4034-a621-0cede4de3144?# 《livevideosdk-quickdemo主目录脑图》)

[^脚注3]:快捷键:Comand + Shift + O (字母O)