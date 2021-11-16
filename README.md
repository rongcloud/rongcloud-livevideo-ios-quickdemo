## 前置条件

1. 注册融云开发者账号 

   [注册开发者账号](https://www.rongcloud.cn/)

2. 开通音视频服务权限 

   [开通音视频服务权限](https://doc.rongcloud.cn/livevideoroom/IOS/1.X/guides/rtc-service)

3. 申请  `BusinessToken`
   1. 此项服务会提供和AppId绑定的10名测试人员资格，点击此处 [获取BusinessToken](https://rcrtc-api.rongcloud.net/code) 
   2. 成功获取到 BusinessToken 后，替换 LVSDefine.h 中定义的 BusinessToken

4. 详细的接入流程可以参考接入文档 

   [接入文档](https://doc.rongcloud.cn/livevideoroom/IOS/1.X/guides/intro) 

## 运行demo

#### 首页

1. 点击列表进入直播间观看直播
2. 点击 Start Live 开始直播

![image](https://github.com/rongcloud/rongcloud-livevideo-ios-quickdemo/blob/master/img/IMG_0001.PNG)

#### 观众端

1. 申请上麦
2. 取消上麦申请
3. 申请上麦的列表
4. 关闭直播
5. 结束连麦

![image](https://github.com/rongcloud/rongcloud-livevideo-ios-quickdemo/blob/master/img/IMG_0006.PNG)

#### 主播端

1. 申请上麦列表
   1. 同意
   2. 拒绝
2. 邀请上麦列表
   1. 取消上麦邀请
3. 观众列表
   1. 邀请上麦
   2. 踢出房间
4. 关闭直播间

![image](https://github.com/rongcloud/rongcloud-livevideo-ios-quickdemo/blob/master/img/IMG_0004.PNG)



具体的使用可参照示例代码。

示例代码展示了更详细的api调用
