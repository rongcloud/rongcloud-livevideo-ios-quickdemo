//
//  LVSUser.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVSUser : NSObject

+ (BOOL)isLogin;

+ (NSString *)saveAuth:(NSString * _Nonnull)auth;

+ (NSString *)saveImToken:(NSString * _Nonnull)imToken;

+ (NSString *)saveUid:(NSString * _Nonnull)uid;

+ (NSString *)saveUserName:(NSString * _Nonnull)uid;

+ (NSString * _Nullable)auth;

+ (NSString * _Nullable)imToken;

+ (NSString * _Nullable)uid;

+ (NSString * _Nullable)userName;

@end

NS_ASSUME_NONNULL_END
