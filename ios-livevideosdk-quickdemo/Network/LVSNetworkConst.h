//
//  LVSNetworkConst.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/25.
//

#import <Foundation/Foundation.h>

static NSString *const kHost = @"http://10.40.0.97:8081/";  //@"https://apiv1-rcrtc.rongcloud.cn/"

#pragma mark - network path

//登录
static NSString *const np_login = @"user/login";

//创建房间
static NSString *const np_room_creat = @"mic/room/create";

//删除房间
static NSString *const np_room_delete = @"mic/room/%@/delete";

//获取房间列表
static NSString *const np_room_list = @"mic/room/list";

//获取用户列表
static NSString *const np_room_users_list = @"mic/room/%@/members";

//获取用户信息
static NSString *const np_fetch_user_info = @"user/batch";

