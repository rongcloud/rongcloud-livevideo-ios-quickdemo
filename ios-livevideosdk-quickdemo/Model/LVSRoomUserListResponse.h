#import <Foundation/Foundation.h>

@class LVSRoomUserListResponse;
@class LVSRoomUser;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LVSRoomUserListResponse : NSObject
@property (nonatomic, nullable, strong) NSNumber *code;
@property (nonatomic, nullable, copy)   NSString *msg;
@property (nonatomic, nullable, copy)   NSArray<LVSRoomUser *> *data;
@end

@interface LVSRoomUser : NSObject
@property (nonatomic, nullable, copy) NSString *userId;
@property (nonatomic, nullable, copy) NSString *userName;
@property (nonatomic, nullable, copy) NSString *portrait;
@end

NS_ASSUME_NONNULL_END
