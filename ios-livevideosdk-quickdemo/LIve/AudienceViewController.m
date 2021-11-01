//
//  AudienceViewController.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/27.
//

#import "AudienceViewController.h"
#import <RCLiveVideoLib/RCLiveVideoLib.h>
#import <RongIMLibCore/RCMessage.h>
#import "LVSToolBar.h"
#import "LVSUser.h"
#import "LVSLiveInfoView.h"
#import "LVSUserListView.h"

static CGFloat kToolBarHeight = 120.f;

static NSArray<NSString *> * _toolBarTitles() {
    return  @[
        @"申请上麦",
        @"取消上麦申请",
        @"申请上麦列表",
        @"关闭直播间",
        @"结束连麦",
    ];
}

static NSArray<NSNumber *> * _toolBarTypes() {
    return  @[
        @(LVSToolBarActionTypeAudienceRequest),
        @(LVSToolBarActionTypeAudienceCancelRequest),
        @(LVSToolBarActionTypeGetRequestList),
        @(LVSToolBarActionTypeLeaveRoom),
        @(LVSToolBarActionTypeLeaveFinishLive),
    ];
}

@interface AudienceViewController () <RCLiveVideoDelegate,LVSToolBarDelegate,LVSToolBarDataSource>
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, strong) LVSToolBar *toolBar;
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) LVSUserListView *listView;
@property (nonatomic, strong) LVSLiveInfoView *infoView;
@end

@implementation AudienceViewController

- (instancetype)initWithRoomId:(NSString *)roomId roomName:(NSString *)roomName; {
    if (self = [super init]) {
        self.roomId = roomId;
        self.roomName = roomName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RCLiveVideoEngine.shared.delegate = self;
    [self addPreview];
    [self joinRoom];
    [self buildLayout];
    
    [self.infoView updateLiveInfo:self.roomName roomId:self.roomId userName:[LVSUser userName] userId:[LVSUser uid]];
}

/// 加入房间
- (void)joinRoom {
    [RCLiveVideoEngine.shared joinRoom:self.roomId completion:^(RCLiveVideoErrorCode code) {
        if (code == RCLiveVideoSuccess) {
            LVSLog(@"audience join room success");
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"create_join_success")];
        } else {
            LVSLog(@"audience join room failed code: %ld",(long)code);
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"create_join_fail")];
        }
    }];
}

- (void)addPreview {
    /// 添加视频预览
    UIView *previewView = [RCLiveVideoEngine.shared previewView];
    previewView.frame = self.view.bounds;
    [self.view addSubview:previewView];
}

- (void)leaveRoom {
    [RCLiveVideoEngine.shared leaveRoom:^(RCLiveVideoErrorCode code) {
        if (code == RCLiveVideoSuccess) {
#warning 示例中房间退出失败不会返回上一个页面，接入方视情况自己处理
            LVSLog(@"audience leave room success");
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"create_leave_success")];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            LVSLog(@"audience leave room failed code: %ld",(long)code);
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"create_leave_fail")];
        }
    }];
}


- (void)showAlert {
    //收到主播的邀请消息，观众方处理请求
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LVSLocalizedString(@"live_receive_host_invite") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:LVSLocalizedString(@"reject") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //同意连麦邀请
        [RCLiveVideoEngine.shared rejectInvitation:^(RCLiveVideoErrorCode code) {
            if (code == RCLiveVideoSuccess) {
                LVSLog(@"audience reject host invication success");
            } else {
                LVSLog(@"audience reject host invication failed code: %ld",code);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_reject_invite_fail"),code]];
            }
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LVSLocalizedString(@"accept") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拒绝连麦邀请
        [RCLiveVideoEngine.shared acceptInvitation:^(RCLiveVideoErrorCode code) {
            if (code == RCLiveVideoSuccess) {
                LVSLog(@"audience accept host invication success");
            } else {
                LVSLog(@"audience accept host invication failed code: %ld",code);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_accept_invite_fail"),code]];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    self.alert = alert;
}

#pragma mark - RCLiveVideoDelegate

/// @param userId 用户被踢出房间
- (void)userDidKickOut:(NSString *)userId byOperator:(NSString *)operatorId {
    if ([userId isEqualToString:[LVSUser uid]]) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kicked_by_user"),operatorId]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}


/// 申请上麦被同意：只有申请者收到回调
- (void)liveVideoRequestDidAccept {
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_host_accept_request")];
}

/// 申请上麦被拒绝：只有申请者收到回调
- (void)liveVideoRequestDidReject {
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_host_reject_request")];
}

/// 接收到上麦邀请：只有受邀请者收到回调
- (void)liveVideoInvitationDidReceive {
    [self showAlert];
}

/// 邀请上麦已被取消：只有受邀请者收到回调
- (void)liveVideoInvitationDidCancel {
    [self.alert dismissViewControllerAnimated:YES completion:nil];
}

/// 直播连麦开始，通过申请、邀请等方式成功上麦后，接收回调。
- (void)liveVideoDidBegin:(RCLiveVideoErrorCode)code {
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_start_boardcast")];
}

/// 视频输出回调，可以在此接口做视频流二次开发，例如：美颜。
/// @param sampleBuffer 视频流采样数据
- (nullable CMSampleBufferRef)didOutputSampleBuffer:(nullable CMSampleBufferRef)sampleBuffer {
    
    return sampleBuffer;
}

/// 合流视频点击事件，点击直播用户时触发
/// 注意：
/// 请确保在布局preview时，可点击用户的视图不被遮挡。
/// 如果preview被遮挡，请使用didLiveVideoLayout自定义事件点击视图
/// @param userId 被点击的用户id
- (void)liveVideoUserDidClick:(NSString *)userId {
    
}

/// 当视频布局发生变化时，更新直播用户的位置
/// @param frameInfo 直播用户布局信息
/// 格式为：[userId: frame]，userId：用户id，frame：用户在preview的位置
- (void)liveVideoUserDidLayout:(NSDictionary<NSString *, NSValue *> *)frameInfo {
    
}

/// 房间已关闭
- (void)roomDidClosed {
    
}

#pragma mark - LVSToolBarDataSource

- (NSInteger)numberOfItems {
    return _toolBarTitles().count;
}

- (UIButton *)buttonForIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_toolBarTitles()[index] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setBackgroundColor:lvsMainColor];
    return  button;
}

#pragma mark - LVSToolBarDelegate
- (void)itemClickAtIndex:(NSInteger)index {
    LVSToolBarActionType type = _toolBarTypes()[index].integerValue;
    switch (type) {
            //申请上麦
        case LVSToolBarActionTypeAudienceRequest:
#warning requestLiveVideo 方法中index为麦序，根据不同的场景麦序不同，例如两人pk麦序为[0~1]、九宫格聊天室麦序为[0~8],index为您期望加入的位置，indxe = -1 时为就近麦序
            [RCLiveVideoEngine.shared requestLiveVideo:-1 completion:^(RCLiveVideoErrorCode code) {
                if (code == RCLiveVideoSuccess) {
                    LVSLog(@"live request post success");
                    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_request_success")];
                } else {
                    LVSLog(@"live request post fail code: %ld",(long)code);
                    [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_request_fail")];
                }
            }];
            break;
            //取消上麦申请
        case LVSToolBarActionTypeAudienceCancelRequest:
            [RCLiveVideoEngine.shared cancelRequest:^(RCLiveVideoErrorCode code) {
                if (code == RCLiveVideoSuccess) {
                    LVSLog(@"live request cancel success");
                    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_cancel_request_success")];
                } else {
                    LVSLog(@"live request cancel fail code: %ld",(long)code);
                    [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_cancel_request_fail")];
                }
            }];
            break;
            //获取当前申请上麦的用户列表
        case LVSToolBarActionTypeGetRequestList:
            {

                [RCLiveVideoEngine.shared getRequests:^(RCLiveVideoErrorCode code, NSArray<NSString *> * _Nonnull users) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"live fetch request users success");
                        if (users && users.count > 0) {
                            LVSLog(@"live request users list is empty");
                            [LVSWebService fetchUserInfoListWithUids:users responseClass:[LVSRoomUserListResponse class] success:^(id  _Nullable responseObject) {
                                LVSLog(@"live network fetch users info success");
                                [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_fetch_request_list_success")];
                                LVSRoomUserListResponse *resObj = (LVSRoomUserListResponse *)responseObject;
                                [self.listView setListType:LVSUserListTypeRequest];
                                [self.listView reloadDataWithUsers:resObj.data];
                                [self.listView show];
                            } failure:^(NSError * _Nonnull error) {
                                LVSLog(@"live network fetch users info failed code: %ld",(long)error.code);
                            }];
                        } else {
                            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_request_list_empty")];
                        }
                    } else {
                        LVSLog(@"live fetch request users fail code: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_fetch_request_list_fail")];
                    }
                }];
            }
            break;
        case LVSToolBarActionTypeLeaveFinishLive:
            {
                [RCLiveVideoEngine.shared finishLiveVideo:[LVSUser uid] completion:^(RCLiveVideoErrorCode code) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"finish live success")
                        [SVProgressHUD showSuccessWithStatus:@"结束连麦"];
                    } else {
                        LVSLog(@"finish live failed code: %ld",code);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_finish_live_fail"),code]];
                    }
                }];
            }
        case LVSToolBarActionTypeLeaveRoom:
            [self leaveRoom];
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (LVSToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[LVSToolBar alloc] init];
        _toolBar.delegate = self;
        _toolBar.dataSource = self;
        _toolBar.backgroundColor = [UIColor clearColor];
    }
    return _toolBar;
}

- (LVSLiveInfoView *)infoView {
    if (_infoView == nil) {
        _infoView = [[LVSLiveInfoView alloc] init];
    }
    return _infoView;
}

- (LVSUserListView *)listView {
    if (_listView == nil) {
        LVSUserListView *listView = [[LVSUserListView alloc] initWithHost:NO];
        listView.frame = CGRectMake(10, kScreenHeight, kScreenWidth - 20, kScreenHeight - 300);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:listView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(24,24)];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

        maskLayer.frame =  listView.bounds;

        maskLayer.path = maskPath.CGPath;

        listView.layer.mask = maskLayer;

        _listView = listView;
    }
    return _listView;
}

#pragma mark - layout subviews

- (void)buildLayout {
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(kToolBarHeight);
    }];
    
    [self.view addSubview:self.listView];
    
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64.f);
        make.leading.equalTo(self.view).offset(20.f);
        make.trailing.equalTo(self.view).offset(-20.f);
        make.height.mas_equalTo(100);
    }];
}

- (void)dealloc {
    
}
@end
