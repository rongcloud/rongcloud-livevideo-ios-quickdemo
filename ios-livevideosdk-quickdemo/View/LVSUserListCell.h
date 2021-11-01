//
//  LVSUserListCell.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/28.
//

#import <UIKit/UIKit.h>

extern NSString *const LVSUserListCellIdentifier;

typedef NS_ENUM(NSUInteger, LVSUserListCellStyle) {
    LVSUserListCellStyleDefault = 1,
    LVSUserListCellStyleKick,
    LVSUserListCellStyleRequest,
    LVSUserListCellStyleCancelInvite,
};

typedef NS_ENUM(NSUInteger, LVSUserListCellAction) {
    LVSUserListCellActionAgree = 1,
    LVSUserListCellActionReject,
    LVSUserListCellActionInvite,
    LVSUserListCellActionCancelInvite,
    LVSUserListCellActionKick,
};


typedef void(^LVSUserListCellHandler)(LVSUserListCellAction action);

NS_ASSUME_NONNULL_BEGIN

@interface LVSUserListCell : UITableViewCell
@property (nonatomic, assign)LVSUserListCellStyle cellStyle;
@property (nonatomic, copy)LVSUserListCellHandler handler;


- (void)updateRoomName:(NSString *)roomName roomId:(NSString *)roomId;

@end

NS_ASSUME_NONNULL_END
