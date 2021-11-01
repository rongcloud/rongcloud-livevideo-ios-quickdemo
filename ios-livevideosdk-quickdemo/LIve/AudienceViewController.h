//
//  AudienceViewController.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudienceViewController : UIViewController

@property (nonatomic, copy, nonnull, readonly) NSString *roomId;

- (instancetype)initWithRoomId:(NSString *)roomId roomName:(NSString *)roomName;

@end

NS_ASSUME_NONNULL_END
