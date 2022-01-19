//
//  LVSRoomOthersResponse.m
//  ios-livevideosdk-quickdemo
//
//  Created by shaoshuai on 2022/1/19.
//

#import "LVSRoomListResponse.h"
#import "LVSRoomOthersResponse.h"

@implementation LVSRoomOthersResponse

- (void)setData:(NSArray<LVSRoomListRoom *> *)data {
    _data = [data lvs_jsonsToModelsWithClass:[LVSRoomListRoom class]];
}

@end
