//
//  LVSWebService.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/25.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LVSRoomType) {
    LVSRoomTypeVoice = 1,
    LVSRoomTypeRadio,
    LVSRoomTypeVideo,
};

typedef void(^LVSSuccessCompletion)(id _Nullable responseObject);

typedef void(^LVSFailureCompletion)(NSError * _Nonnull error);


NS_ASSUME_NONNULL_BEGIN

@interface LVSWebService : AFHTTPSessionManager

//业务方签名 登录接口获取
@property (nonatomic, copy, readwrite) NSString *auth;

/// 获取实例
+ (instancetype)shareInstance;

/// 登录
/// @param number 电话号码
/// @param verifyCode 验证码   //测试环境验证码可以输入任意值
/// @param deviceId  设备ID UUIDString
/// @param userName 昵称
/// @param portrait 头像
/// @param success 成功回调
/// @param failure 失败回调
+ (void)loginWithPhoneNumber:(NSString *)number
                  verifyCode:(NSString *)verifyCode
                    deviceId:(NSString *)deviceId
                    userName:(nullable NSString *)userName
                    portrait:(nullable NSString *)portrait
               responseClass:(nullable Class)responseClass
                     success:(nullable LVSSuccessCompletion)success
                     failure:(nullable LVSFailureCompletion)failure;


/// 创建房间列表
/// @param name 房间名
/// @param isPrivate  是否是私密房间  0 否  1 是
/// @param backgroundUrl 背景图片
/// @param themePictureUrl 主题照片
/// @param password  私密房间密码MD5
/// @param kv  保留值，可缺省传空
/// @param success 成功回调
/// @param failure 失败回调
+ (void)createRoomWithName:(NSString *)name
                 isPrivate:(NSInteger)isPrivate
             backgroundUrl:(NSString *)backgroundUrl
           themePictureUrl:(NSString *)themePictureUrl
                  password:(NSString *)password
                        kv:(NSArray <NSDictionary *>*)kv
             responseClass:(nullable Class)responseClass
                   success:(nullable LVSSuccessCompletion)success
                   failure:(nullable LVSFailureCompletion)failure;


/// 删除房间
/// @param roomId 房间ID
/// @param success 成功回调
/// @param failure 失败回调
+ (void)deleteRoomWithRoomId:(NSString *)roomId
                     success:(nullable LVSSuccessCompletion)success
                     failure:(nullable LVSFailureCompletion)failure;


/// 房间列表
/// @param size 返回数据量
/// @param page 分页
/// @param type 房间类型 1.语聊 2.电台  3.直播
/// @param success 成功回调
/// @param failure 失败回调
+ (void)roomListWithSize:(NSInteger)size
                    page:(NSInteger)page
                    type:(LVSRoomType)type
           responseClass:(nullable Class)responseClass
                 success:(nullable LVSSuccessCompletion)success
                 failure:(nullable LVSFailureCompletion)failure;


/// 获取直播间内的用户
/// @param roomId  房间id
/// @param success 成功回调
/// @param failure 失败回调
+ (void)roomUserListWithRoomId:(NSString *)roomId
                 responseClass:(nullable Class)responseClass
                       success:(nullable LVSSuccessCompletion)success
                       failure:(nullable LVSFailureCompletion)failure;

/// 批量获取用户信息
/// @param uids  用户uid列表
/// @param success 成功回调
/// @param failure 失败回调
+ (void)fetchUserInfoListWithUids:(NSArray<NSString *>*)uids
                    responseClass:(nullable Class)responseClass
                          success:(nullable LVSSuccessCompletion)success
                          failure:(nullable LVSFailureCompletion)failure;
@end

NS_ASSUME_NONNULL_END
