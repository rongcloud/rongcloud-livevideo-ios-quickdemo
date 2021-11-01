#import "LVSRoomListResponse.h"

@implementation LVSRoomListResponse
@end

@implementation LVSRoomListData
- (void)setRooms:(NSArray<LVSRoomListRoom *> *)rooms {
    if (rooms != nil && rooms.count > 0 && [rooms.firstObject isKindOfClass:[NSDictionary class]]) {
        _rooms = [rooms lvs_jsonsToModelsWithClass:[LVSRoomListRoom class]];
    } else {
        _rooms = rooms;
    }
}
@end

@implementation LVSRoomListRoom
@end

@implementation LVSRoomListCreateUser
@end
