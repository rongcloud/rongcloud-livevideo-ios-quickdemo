//
//  NSArray+LVSModel.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/27.
//

#import "NSArray+LVSModel.h"

@implementation NSArray (LVSModel)
- (NSArray *)lvs_jsonsToModelsWithClass:(Class)cls {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *json in self) {
        id model = [cls yy_modelWithJSON:json];
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}
@end
