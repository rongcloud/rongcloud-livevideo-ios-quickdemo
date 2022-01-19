//
//  HostViewController.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/27.
//

#import "HostViewController.h"
#import <RCLiveVideoLib/RCLiveVideoLib.h>
#import <RongIMLibCore/RCMessage.h>
#import "LVSCreateRoomResponse.h"
#import "LVSToolBar.h"
#import "LVSUserListView.h"
#import "LVSLiveInfoView.h"
#import "LVSUser.h"
#import "LVSRoomListResponse.h"
#import "LVSRoomOthersResponse.h"
#import "LVSUpdateRoomResponse.h"

static CGFloat kToolBarHeight = 120.f;

static NSArray<NSString *> * _toolBarTitles() {
    return  @[
        @"申请上麦列表",
        @"邀请上麦列表",
        @"观众列表",
        @"PK",
        @"关闭直播间",
    ];
}

static NSArray<NSNumber *> * _toolBarTypes() {
    return  @[
        @(LVSToolBarActionTypeGetRequestList),
        @(LVSToolBarActionTypeHostInvite),
        @(LVSToolBarActionTypeGetRoomUsers),
        @(LVSToolBarActionTypePK),
        @(LVSToolBarActionTypeLeaveRoom),
    ];
}

@interface HostViewController () <RCLiveVideoDelegate,LVSToolBarDelegate,LVSToolBarDataSource,RCLiveVideoMixDelegate, RCLiveVideoPKDelegate>
@property (nonatomic, strong, nullable) LVSCreateRoomData *roomData;
@property (nonatomic, strong) LVSToolBar *toolBar;
@property (nonatomic, strong) LVSUserListView *listView;
@property (nonatomic, strong) LVSLiveInfoView *infoView;
@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLiveEngine];
    [self createRoom];
    [self buildLayout];
}


/// 配置
- (void)configLiveEngine {
    /// 根据业务需求设置视频信息：分辨率、码率和帧率等
    RCRTCVideoStreamConfig *config = [[RCRTCVideoStreamConfig alloc] init];
    config.videoSizePreset = RCRTCVideoSizePreset640x480;
    config.videoFps = RCRTCVideoFPS15;
    config.minBitrate = 350;
    config.maxBitrate = 1000;
    
    RCRTCEngine.sharedInstance.defaultVideoStream.videoConfig = config;
    
    /// 设置代理，接收视频流输出回调
    /// 此时，可以在didOutputSampleBuffer:回调方法里处理视频流，比如：美颜。
    RCLiveVideoEngine.shared.delegate = self;
    //布局代理
    RCLiveVideoEngine.shared.mixDelegate = self;
    
    RCLiveVideoEngine.shared.pkDelegate = self;
    
    //设置布局模式
    [RCLiveVideoEngine.shared setMixType:RCLiveVideoMixTypeOneToOne completion:^(RCLiveVideoCode code) {
        NSLog(@"set mix type error code %ld",code);
    }];
    
    /// 添加视频预览
    UIView *previewView = [RCLiveVideoEngine.shared previewView];
    previewView.frame = self.view.bounds;
    [self.view addSubview:previewView];
    [RCLiveVideoEngine.shared prepare];
}

#warning 此处需要调用己方服务创建房间

/// 创建房间
- (void)createRoom {
    
    NSString *imageUrl = @"https://img2.baidu.com/it/u=2842763149,821152972&fm=26&fmt=auto";
#warning 密码需要传递MD5之后的加密值, 当房间为私密时，密码值不可缺省
    NSString *passord = [@"password" lvs_md5];

    NSString *roomName = @"Live Video 123";
    //通过己方业务接口创建房间
    [LVSWebService createRoomWithName:roomName isPrivate:0 backgroundUrl:imageUrl themePictureUrl:imageUrl password:passord kv: @[] responseClass:[LVSCreateRoomResponse class] success:^(id  _Nullable responseObject) {
        if (responseObject) {
            LVSLog(@"network create room success")
            LVSCreateRoomResponse *res = (LVSCreateRoomResponse *)responseObject;
            if (res.data != nil) {
                self.roomData = res.data;
                [self updateRoom:res.data.roomId];
#warning 创建房间成功后需要调用 begin 方法开始推流
                [self begin];
                [self.infoView updateLiveInfo:res.data.roomName roomId:res.data.roomId userName:[LVSUser userName] userId:[LVSUser uid]];
                [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"create_room_success")];
            } else {
                LVSLog(@"network logic error code: %ld",(long)res.code);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ code: %ld",LVSLocalizedString(@"network_error"),res.code]];
            }

        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ code: %ld",LVSLocalizedString(@"create_room_fail"),(long)error.code]];
    }];
}

- (void)updateRoom:(NSString *)roomId {
    [LVSWebService updateCurrentRoom:roomId responseClass:[LVSUpdateRoomResponse class] success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)begin {
    LVSLog(@"start push stream");
    //开始推流
    [RCLiveVideoEngine.shared begin:self.roomData.roomId completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            LVSLog(@"live video engine push stream success");
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ code: %ld",LVSLocalizedString(@"host_push_stream"),(long)code]];
        }
    }];
}

- (void)close {
#warning 此处需要注意，主播端下播时需要通知业务方释放相应的房间，业务接口调用成功后调用 Engine finish 方法
    //调用业务接口释放直播间
    [LVSWebService deleteRoomWithRoomId:self.roomData.roomId success:^(id  _Nullable responseObject) {
        LVSLog(@"network live room close success");
//        //调用 Engine finish 结束直播
//        [RCLiveVideoEngine.shared leaveRoom:^(RCLiveVideoCode code) {
//            if (code == RCLiveVideoSuccess) {
//                LVSLog(@"engine live room close success");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//            } else {
//#warning 此处根据不同的业务需求需要自行处理直播结束异常的case
//                LVSLog(@"engine live room close fail code: %ld",(long)code);
//                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Engine %@ code: %ld",LVSLocalizedString(@"live_room_delete_fail"),(long)code]];
//            }
//        }];
    } failure:^(NSError * _Nonnull error) {
        LVSLog(@"network live room close fail");
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"NetWork %@ code: %ld",LVSLocalizedString(@"live_room_delete_fail"),(long)error.code]];
    }];
}

//业务操作
- (void)handleAudienceRequest:(NSInteger)action uid:(NSString *)uid {
    switch (action) {
            //同意用户的上麦申请
        case LVSUserListActionAgree:
            {
                [RCLiveVideoEngine.shared acceptRequest:uid completion:^(RCLiveVideoCode code) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"host agree audience live request success");
                        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_accept_success"),uid]];
                    } else {
                        LVSLog(@"host agree audience live request failed ocde: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_accept_fail"),(long)code]];
                    }
                }];
            }
            break;
            //拒绝用户的上麦申请
        case LVSUserListActionActionReject:
            {
                [RCLiveVideoEngine.shared rejectRequest:uid completion:^(RCLiveVideoCode code) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"host reject audience live request success");
                        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_reject_success"),uid]];
                    } else {
                        LVSLog(@"host reject audience live request failed ocde: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_reject_fail"),(long)code]];
                    }
                }];
            }
            break;
            //根据用户的uid将用户踢出直播间
        case LVSUserListActionActionKick:
            {
                [RCLiveVideoEngine.shared kickOutRoom:uid completion:^(RCLiveVideoCode code) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"host kick audience success");
                        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kick_audience_success"),uid]];
                    } else {
                        LVSLog(@"host kick audience failed ocde: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kick_audience_fail"),(long)code]];
                    }
                }];
            }
            break;
            //邀请用户上麦
        case LVSUserListActionActionInvite:
            {
#warning inviteLiveVideo 方法中index为麦序，根据不同的场景麦序不同，例如两人pk麦序为[0~1]、九宫格聊天室麦序为[0~8],index为您期望加入的位置，indxe = -1 时为就近麦序
                [RCLiveVideoEngine.shared inviteLiveVideo:uid atIndex:1 completion:^(RCLiveVideoCode code) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"host invite audience success");
                        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_invite_audience_success"),uid]];
                    } else {
                        LVSLog(@"host invite audience failed ocde: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_invite_audience_fail"),(long)code]];
                    }
                }];
            }
            break;
            //根据uid取消对某个用户的上麦邀请
        case LVSUserListActionActionCancelInvite:
            {
                [RCLiveVideoEngine.shared cancelInvitation:uid completion:^(RCLiveVideoCode code) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"host cancel invite success");
                        [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_invite_cancel_success")];
                    } else {
                        LVSLog(@"hhost cancel invite failed ocde: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_invite_cancel_fail"),(long)code]];
                    }
                }];
            }
            break;
        default:
            break;
    }
}

#pragma mark - RCLiveVideoDelegate

/// 房间信息已同步
- (void)roomInfoDidSync {
#warning createRoom 房间创建成功会收到回调
    LVSLog(@"HostViewController room info did sync");
}

/// 房间信息更新
/// @param key 房间信息属性
/// @param value 房间信息内容
- (void)roomInfoDidUpdate:(NSString *)key value:(NSString *)value {
    LVSLog(@"HostViewController room info did update");
}

/// @param userId 用户进入房间
/// @param count   房间用户数量
- (void)userDidEnter:(NSString *)userId withUserCount:(NSInteger)count {
    LVSLog(@"HostViewController user: %@ had enter live room userCount:%ld",userId, count);
}

/// @param userId 用户离开房间
/// @param count   房间用户数量
- (void)userDidExit:(NSString *)userId withUserCount:(NSInteger)count {
    LVSLog(@"HostViewController user: %@ had exit live room userCount:%ld",userId,count);
}

/// @param userId 用户被踢出房间
- (void)userDidKickOut:(NSString *)userId byOperator:(NSString *)operatorId {
    LVSLog(@"HostViewController user: %@ kicked from live room by: %@",userId,operatorId);
}

/// 房间连麦用户更新：用户上麦、下麦等
/// @param userIds 连麦的用户
- (void)liveVideoDidUpdate:(NSArray<NSString *> *)userIds {
    LVSLog(@"HostViewController the user on boardcast had update");
}

/// 上麦申请列表发生变化
- (void)liveVideoRequestDidChange {
    LVSLog(@"HostViewController audience request list had changed");
    [SVProgressHUD showInfoWithStatus:LVSLocalizedString(@"live_request_list_changed")];
}

/// 邀请上麦被同意
- (void)liveVideoInvitationDidAccept:(NSString *)userId {
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_accept_invite"),userId]];
}

/// 邀请上麦被拒绝
- (void)liveVideoInvitationDidReject:(NSString *)userId {
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_reject_invite"),userId]];
}


/// 直播连麦开始，通过申请、邀请等方式成功上麦后，接收回调。
- (void)liveVideoDidBegin:(RCLiveVideoCode)code {
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_start_boardcast")];
}

/// 直播连麦结束
- (void)liveVideoDidFinish:(RCLiveVideoFinishReason)reason {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@ reason: %ld",LVSLocalizedString(@"live_stop_boardcast"),reason]];
}


/// 视频输出回调，可以在此接口做视频流二次开发，例如：美颜。
/// @param sampleBuffer 视频流采样数据
- (nullable CMSampleBufferRef)didOutputSampleBuffer:(nullable CMSampleBufferRef)sampleBuffer {
    
    return sampleBuffer;
}

/// 自定义麦位视图
/// @param seat 麦位对象
/// @param frame 麦位在 previewView 中的位置
- (void)liveVideoDidLayout:(RCLiveVideoSeat *)seat withFrame:(CGRect)frame {
    
}
/// 房间已关闭
- (void)roomDidClosed {
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_end")];
}

//合流布局更新
- (void)roomMixTypeDidChange:(RCLiveVideoMixType)mixType {
    NSLog(@"mix type did change");
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
            //获取上麦请求列表
        case LVSToolBarActionTypeGetRequestList:
            {
#warning 此处 Engine 会返回上麦申请的相关用户uid，可以视情况通过接入方服务获取更详细的用户信息
                [RCLiveVideoEngine.shared getRequests:^(RCLiveVideoCode code, NSArray<NSString *> * _Nonnull users) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"host engine fetch request users success");
                        if (users && users.count > 0) {
                            LVSLog(@"host request users list is empty");
                            //使用 Engine 获取的用户ID批量获取用户信息
                            [LVSWebService fetchUserInfoListWithUids:users responseClass:[LVSRoomUserListResponse class] success:^(id  _Nullable responseObject) {
                                LVSLog(@"host network fetch users info success");
                                [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_fetch_request_list_success")];
                                LVSRoomUserListResponse *resObj = (LVSRoomUserListResponse *)responseObject;
                                [self.listView setListType:LVSUserListTypeRequest];
                                [self.listView reloadDataWithUsers:resObj.data];
                                [self.listView show];
                            } failure:^(NSError * _Nonnull error) {
                                LVSLog(@"host network fetch users info failed code: %ld",(long)error.code);
                            }];
                        } else {
                            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_request_list_empty")];
                        }
                    } else {
                        LVSLog(@"host fetch request users fail code: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_fetch_request_list_fail")];
                    }
                }];
            }
            break;
            //获取直播间用户列表
        case LVSToolBarActionTypeGetRoomUsers:
            {
                [LVSWebService roomUserListWithRoomId:self.roomData.roomId responseClass:[LVSRoomUserListResponse class] success:^(id  _Nullable responseObject) {
                    LVSLog(@"host network fetch room users list success");
                    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_fetch_user_list_success")];
                    LVSRoomUserListResponse *resObj = (LVSRoomUserListResponse *)responseObject;
                    if (resObj.data == nil || resObj.data.count == 0) {
                        [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_user_list_empty")];
                    } else {
                        [self.listView setListType:LVSUserListTypeRoomUser];
                        [self.listView reloadDataWithUsers:resObj.data];
                        [self.listView show];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_fetch_user_list_fail")];
                    LVSLog(@"host network fetch room users list failed code: %ld",(long)error.code);
                }];
            }
            break;
        case LVSToolBarActionTypePK:
            if (RCLiveVideoEngine.shared.PK) {
                [RCLiveVideoEngine.shared quitPK:^(RCLiveVideoCode code) {
                    
                }];
            } else {
                [LVSWebService fetchOthers:[LVSRoomOthersResponse class] success:^(id  _Nullable responseObject) {
                    LVSRoomOthersResponse *response = responseObject;
                    if (response.data == nil || response.data.count == 0) {
                        [SVProgressHUD showSuccessWithStatus:@"数据加载失败"];
                    } else {
                        [self invitePKRooms:response.data];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [SVProgressHUD showSuccessWithStatus:error.localizedDescription];
                }];
            }
            break;
            //关闭并推出直播间
        case LVSToolBarActionTypeLeaveRoom:
            [self close];
            break;
            //获取主播邀请的用户列表
        case LVSToolBarActionTypeHostInvite:
            {
                [RCLiveVideoEngine.shared getInvitations:^(RCLiveVideoCode code, NSArray<NSString *> * _Nonnull users) {
                    if (code == RCLiveVideoSuccess) {
                        LVSLog(@"host engine fetch invite users success");
                        if (users && users.count > 0) {
                            LVSLog(@"host request users list is empty");
                            //使用 Engine 获取的用户ID批量获取用户信息
                            [LVSWebService fetchUserInfoListWithUids:users responseClass:[LVSRoomUserListResponse class] success:^(id  _Nullable responseObject) {
                                LVSLog(@"host network fetch users info success");
                                [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_fetch_invite_list_success")];
                                LVSRoomUserListResponse *resObj = (LVSRoomUserListResponse *)responseObject;
                                [self.listView setListType:LVSUserListTypeRoomInvite];
                                [self.listView reloadDataWithUsers:resObj.data];
                                [self.listView show];
                            } failure:^(NSError * _Nonnull error) {
                                LVSLog(@"host network fetch users info failed code: %ld",(long)error.code);
                            }];
                        } else {
                            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_invite_list_empty")];
                        }
                    } else {
                        LVSLog(@"host fetch invite users fail code: %ld",(long)code);
                        [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_fetch_invite_list_fail")];
                    }
                }];
            }
            break;
        default:
            break;
    }
}

#pragma mark - PK -

- (void)invitePKRooms:(NSArray<LVSRoomListRoom *> *)rooms {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"在线" message:@"选择 PK 目标" preferredStyle:UIAlertControllerStyleActionSheet];
    for (LVSRoomListRoom *room in rooms) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:room.roomName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self invitePK:room];
        }];
        [controller addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)invitePK:(LVSRoomListRoom *)room {
    [RCLiveVideoEngine.shared sendPKInvitation:room.roomId invitee:room.userId completion:^(RCLiveVideoCode code) {
        LVSLog(@"send PK invitation %d", (int)code);
    }];
}

#pragma mark - RCLiveVideoPKDelegate -

- (void)didReceivePKInvitationFromRoom:(NSString *)inviterRoomId byUser:(NSString *)inviterUserId {
    [RCLiveVideoEngine.shared acceptPKInvitation:inviterRoomId inviter:inviterUserId completion:^(RCLiveVideoCode code) {
        LVSLog(@"accept PK %d", (int)code);
    }];
}

#pragma mark - getter

- (LVSToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[LVSToolBar alloc] init];
        _toolBar.delegate = self;
        _toolBar.dataSource = self;
    }
    return _toolBar;
}

- (LVSUserListView *)listView {
    if (_listView == nil) {
        LVSUserListView *listView = [[LVSUserListView alloc] initWithHost:YES];
        listView.frame = CGRectMake(10, kScreenHeight, kScreenWidth - 20, kScreenHeight - 300);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:listView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(24,24)];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

        maskLayer.frame =  listView.bounds;

        maskLayer.path = maskPath.CGPath;

        listView.layer.mask = maskLayer;
        WeakSelf
        [listView setHandler:^(NSString * _Nonnull uid, NSInteger action) {
            StrongSelf
            [strongSelf handleAudienceRequest:action uid:uid];
        }];
        _listView = listView;
    }
    return _listView;
}

- (LVSLiveInfoView *)infoView {
    if (_infoView == nil) {
        _infoView = [[LVSLiveInfoView alloc] init];
    }
    return _infoView;
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
