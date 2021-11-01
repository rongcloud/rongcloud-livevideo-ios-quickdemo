//
//  HomeTableViewCell.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const HomeTableViewCellIdentifier;

@interface HomeTableViewCell : UITableViewCell
- (void)updateRoomName:(NSString *)roomName roomId:(NSString *)roomId;
@end

NS_ASSUME_NONNULL_END
