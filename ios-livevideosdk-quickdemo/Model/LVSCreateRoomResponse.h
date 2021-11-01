#import <Foundation/Foundation.h>

@class LVSCreateRoomResponse;
@class LVSCreateRoomData;
@class LVSCreateUser;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LVSCreateRoomResponse : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) LVSCreateRoomData *data;
@end

@interface LVSCreateRoomData : NSObject
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSString *roomId;
@property (nonatomic, copy)   NSString *roomName;
@property (nonatomic, copy)   NSString *themePictureUrl;
@property (nonatomic, copy)   NSString *backgroundUrl;
@property (nonatomic, assign) NSInteger isPrivate;
@property (nonatomic, copy)   NSString *password;
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, assign) NSInteger updateDt;
@property (nonatomic, strong) LVSCreateUser *createUser;
@property (nonatomic, assign) NSInteger roomType;
@property (nonatomic, assign) NSInteger userTotal;
@property (nonatomic, assign) BOOL isStop;
@end

@interface LVSCreateUser : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *portrait;
@end

NS_ASSUME_NONNULL_END
