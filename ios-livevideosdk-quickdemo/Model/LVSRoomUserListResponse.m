#import "LVSRoomUserListResponse.h"

@implementation LVSRoomUserListResponse
- (void)setData:(NSArray<LVSRoomUser *> *)data {
    _data = [data lvs_jsonsToModelsWithClass:[LVSRoomUser class]];
}
@end

@implementation LVSRoomUser
@end
