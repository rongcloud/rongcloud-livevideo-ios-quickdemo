//
//  LiveInfoView.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVSLiveInfoView : UIView
- (void)updateLiveInfo:(NSString *)roomName roomId:(NSString *)roomId userName:(NSString *)userName userId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
