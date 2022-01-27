//
//  LoginViewController.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/26.
//

#import "LoginViewController.h"
#import "LVSLoginResponse.h"
#import "LVSUser.h"
#import "RongIMLib/RCIMClient.h"

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *phoneNumberInputField;
@property (nonatomic, strong) UIButton *loginButton;
@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildLayout];
}

#pragma mark getter

- (UITextField *)phoneNumberInputField {
    if (_phoneNumberInputField == nil) {
        _phoneNumberInputField = [[UITextField alloc] init];
        _phoneNumberInputField.placeholder = LVSLocalizedString(@"login_phone_num_input_placeholder");
        _phoneNumberInputField.backgroundColor = [lvsMainColor colorWithAlphaComponent:0.5];
        _phoneNumberInputField.layer.masksToBounds = YES;
        _phoneNumberInputField.layer.cornerRadius = 4;
        _phoneNumberInputField.layer.borderColor = lvsMainColor.CGColor;
        _phoneNumberInputField.layer.borderWidth = 1.0;
        _phoneNumberInputField.keyboardType = UIKeyboardTypePhonePad;
    }
    return  _phoneNumberInputField;
}


- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:LVSLocalizedString(@"login_button_title") forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.backgroundColor = lvsMainColor;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 4;
        
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

#pragma mark - layout subviews

- (void)buildLayout {
    [self.view addSubview:self.phoneNumberInputField];
    [self.phoneNumberInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(200);
        make.leading.equalTo(self.view.mas_leading).offset(100);
        make.trailing.equalTo(self.view.mas_trailing).offset(-100);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumberInputField.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(80, 44));
        make.centerX.equalTo(self.phoneNumberInputField);
    }];
}


#pragma  mark - actions

- (void)loginButtonClick:(UIButton *)button {
    
    [SVProgressHUD show];
    
    button.enabled = NO;
    
#warning 此处为业务代码，接入方需要从自己的服务器获取到对应的登录信息
    
    LVSLog(@"start login");
    WeakSelf
    //登录
    [LVSWebService loginWithPhoneNumber:self.phoneNumberInputField.text
                             verifyCode:@"123456" deviceId:_deviceID()
                               userName:nil
                               portrait:nil
                          responseClass:[LVSLoginResponse class]
                                success:^(id  _Nullable responseObject) {
        button.enabled = YES;
        LVSLoginResponse *res = (LVSLoginResponse *)responseObject;
        [LVSUser saveAuth:res.data.authorization];
        [LVSUser saveImToken:res.data.imToken];
        [LVSUser saveUid:res.data.userId];
        [LVSUser saveUserName:res.data.userName];
        LVSWebService.shareInstance.auth = res.data.authorization;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LVSLoginSuccessNotification object:nil];
        
        LVSLog(@"network login success");
        
#warning 获取到相应的登录信息后，RCIMClient 调用 connectWithToken 方法建立链接,
        
        [[RCIMClient sharedRCIMClient] connectWithToken:[LVSUser imToken]  timeLimit:5
        dbOpened:^(RCDBErrorCode code) {
            //消息数据库打开，可以进入到主页面
            if (code == RCDBOpenSuccess) {
                LVSLog(@"login success,db open success");
            } else {
                LVSLog(@"login success, db open failed");
            }
        } success:^(NSString *userId) {
            //连接成功
            StrongSelf
            LVSLog(@"IMClient connect success");
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"login_success_msg")];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            });
            
        } error:^(RCConnectErrorCode status) {
            if (status == RC_CONN_TOKEN_INCORRECT) {
                //token 非法，从 APP 服务获取新 token，并重连
                LVSLog(@"need refresh im token");
            } else if(status == RC_CONNECT_TIMEOUT) {
                //连接超时，弹出提示，可以引导用户等待网络正常的时候再次点击进行连接
                [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"network_time_out")];
            } else {
                //无法连接 IM 服务器，请根据相应的错误码作出对应处理
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ code: %ld",LVSLocalizedString(@"network_error"),(long)status]];
            }
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ code: %ld",LVSLocalizedString(@"login_fail_msg"),(long)status]];
        }];
    }
                                failure:^(NSError * _Nonnull error) {
        button.enabled = YES;
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ code: %ld",LVSLocalizedString(@"network_error"),(long)error.code]];
    }];
    
}

- (void)dealloc {
    
}
@end
