//
//  LVSUser.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/26.
//

#import "LVSUser.h"
#import "LVSUserConst.h"

@implementation LVSUser

+ (BOOL)isLogin {
    return [self imToken] != nil && [self imToken].length > 0;
}

+ (NSString *)saveAuth:(NSString *)auth {
    return [self _saveValue:auth forKey:kUserAuthKey];;
}

+ (NSString *)saveImToken:(NSString *)imToken {
    return [self _saveValue:imToken forKey:kUserImTokenKey];
}

+ (NSString *)saveUid:(NSString *)uid {
    return [self _saveValue:uid forKey:kUserUidKey];
}

+ (NSString *)saveUserName:(NSString *)userName {
    return (NSString *)[self _saveValue:userName forKey:kUserUserNameKey];
}

+ (NSString *)auth {
    return [self _valueForKey:kUserAuthKey];
}

+ (NSString *)imToken {
    return [self _valueForKey:kUserImTokenKey];
}

+ (NSString *)uid {
    return [self _valueForKey:kUserUidKey];
}

+ (NSString *)userName {
    return [self _valueForKey:kUserUserNameKey];
}

+ (id)_saveValue:(NSString *)value forKey:(NSString *)key {
    if (value == nil || key == nil || value.length == 0 || key.length == 0) {
        NSAssert(NO, @"LVSUser: value and key must be nonnull");
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:value forKey:key];
    [userDefault synchronize];
    return  value;
}

+ (id)_valueForKey:(NSString *)key {
    if (key == nil || key.length == 0) {
        NSAssert(NO, @"LVSUser: key must be nonnull");
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id value = [userDefault valueForKey:key];
    return value;
}



@end
