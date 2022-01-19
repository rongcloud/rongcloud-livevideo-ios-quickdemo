//
//  LVSToolBar.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/28.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LVSToolBarActionType) {
    LVSToolBarActionTypeAudienceRequest = 1,
    LVSToolBarActionTypeAudienceCancelRequest,
    LVSToolBarActionTypeHostInvite,
    LVSToolBarActionTypeHostCancelInvite,
    LVSToolBarActionTypeGetRoomUsers,
    LVSToolBarActionTypeGetRequestList,
    LVSToolBarActionTypePK,
    LVSToolBarActionTypeLeaveRoom,
    LVSToolBarActionTypeLeaveFinishLive,
};

@protocol LVSToolBarDataSource <NSObject>

@required
- (NSInteger)numberOfItems;
- (UIButton *)buttonForIndex:(NSInteger)index;

@end

@protocol LVSToolBarDelegate <NSObject>

@required
- (void)itemClickAtIndex:(NSInteger)index;
@end

@interface LVSToolBar : UIView
@property (nonatomic, weak) id<LVSToolBarDataSource> dataSource;
@property (nonatomic, weak) id<LVSToolBarDelegate> delegate;
@end

