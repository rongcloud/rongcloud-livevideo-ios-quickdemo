//
//  LVSDefine.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/26.
//

static NSString *const LVSLoginSuccessNotification = @"LVSLoginSuccessNotificationIdentifier";

//融云官网申请的 app key
#define lvsAppKey  @"pvxdm17jpw7ar"

//请前往 https://rcrtc-api.rongcloud.net/code 获取 BusinessToken
#define BusinessToken  <#BusinessToken#>

//主色调
#define lvsMainColor [UIColor colorFromHexString:@"#0099ff"]

//log
#define LVSLog(fmt, ...) NSLog((@"LVS:" fmt), ##__VA_ARGS__);

//LocalizedString
#define LVSLocalizedString(x) \
[[NSBundle mainBundle] localizedStringForKey:x value:@"" table:nil]


#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//weak strong

#define WeakSelf     __weak typeof(self) weakSelf = self;

#define StrongSelf     __strong typeof(weakSelf) strongSelf = weakSelf;
