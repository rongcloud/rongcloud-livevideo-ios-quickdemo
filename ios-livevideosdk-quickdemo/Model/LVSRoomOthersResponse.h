//
//  LVSRoomOthersResponse.h
//  ios-livevideosdk-quickdemo
//
//  Created by shaoshuai on 2022/1/19.
//

#import <Foundation/Foundation.h>

@class LVSRoomListRoom;

NS_ASSUME_NONNULL_BEGIN

@interface LVSRoomOthersResponse : NSObject

@property (nonatomic, nullable, strong) NSNumber *code;
@property (nonatomic, nullable, copy)   NSString *msg;
@property (nonatomic, nullable, copy)   NSArray<LVSRoomListRoom *> *data;

@end

NS_ASSUME_NONNULL_END
