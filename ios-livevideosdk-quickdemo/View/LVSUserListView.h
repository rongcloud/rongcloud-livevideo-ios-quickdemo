//
//  LVSUserListView.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "LVSRoomUserListResponse.h"

typedef NS_ENUM(NSUInteger, LVSUserListType) {
    LVSUserListTypeRequest = 1,
    LVSUserListTypeRoomInvite,
    LVSUserListTypeRoomUser,
};

typedef NS_ENUM(NSUInteger, LVSUserListAction) {
    LVSUserListActionAgree = 1,
    LVSUserListActionActionReject,
    LVSUserListActionActionInvite,
    LVSUserListActionActionCancelInvite,
    LVSUserListActionActionKick,
};


typedef void(^LVSUserListHandler)(NSString *_Nonnull uid,NSInteger action);

NS_ASSUME_NONNULL_BEGIN

@interface LVSUserListView : UIView
@property (nonatomic, assign, readonly, getter=isHost) BOOL host;
@property (nonatomic, copy) LVSUserListHandler handler;
@property (nonatomic, assign) LVSUserListType listType;

- (instancetype)initWithHost:(BOOL)host;
- (void)reloadDataWithUsers:(NSArray <LVSRoomUser *>*)users;
- (void)show;
- (void)dismiss;


@end

NS_ASSUME_NONNULL_END
