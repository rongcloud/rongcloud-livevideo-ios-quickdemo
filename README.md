## 前置条件

1. 为了方便您快速运行quickdemo，我们为您预置了融云 appkey 和 对应的测试服务器url，您不需要自己部署测试服务器即可运行。
2. 申请  `BusinessToken`   
   1. BusinessToken 主要是防止滥用 quickdemo 里的测试appKey，我们为接口做了限制，一个 BusinessToken 最多可以支持10个用户注册，20天使用时长。点击此处 [获取BusinessToken](https://rcrtc-api.rongcloud.net/code)
   2. 过期后您的注册用户会自动移除，想继续使用 quickdemo 需要您重新申请 BusinessToken
   3. 成功获取到 BusinessToken 后，替换 LVSDefine.h 中定义的 BusinessToken

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
