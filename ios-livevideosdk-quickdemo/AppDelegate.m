//
//  AppDelegate.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/26.
//

#import "AppDelegate.h"
#import "RongIMLib/RCIMClient.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "LVSUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomeViewController *rootVC = [[HomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:lvsMainColor] forBarMetrics:UIBarMetricsDefault];
    nav.extendedLayoutIncludesOpaqueBars = YES;
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    LVSWebService.shareInstance.auth = [LVSUser auth];
    [self initIMClient];
    return YES;
}

#pragma  mark - init imclient

- (void)initIMClient {
#warning 需要使用自己的appkey进行替换
    [[RCIMClient sharedRCIMClient] initWithAppKey:lvsAppKey];
    if ([LVSUser isLogin]) {
        [[RCIMClient sharedRCIMClient] connectWithToken:[LVSUser imToken] timeLimit:5
        dbOpened:^(RCDBErrorCode code) {
            LVSLog(@"db open code: %ld",(long)code);
        } success:^(NSString *userId) {
            //连接成功
            LVSLog(@"im connected success");
        } error:^(RCConnectErrorCode status) {
            if (status == RC_CONN_TOKEN_INCORRECT) {
                //token 非法，从 APP 服务获取新 token，并重连
                //检查客户端和服务端配置的key是否一致
                LVSLog(@"im connected token incorrect");
            } else if(status == RC_CONNECT_TIMEOUT) {
                //连接超时，弹出提示，可以引导用户等待网络正常的时候再次点击进行连接
                LVSLog(@"im connected time out");
            } else {
                //无法连接 IM 服务器，请根据相应的错误码作出对应处理
                LVSLog(@"im connected failed code: %ld",(long)status);
            }
        }];
    }
}

@end
