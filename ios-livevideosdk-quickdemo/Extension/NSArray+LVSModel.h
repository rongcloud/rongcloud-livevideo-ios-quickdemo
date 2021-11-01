//
//  NSArray+LVSModel.h
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (LVSModel)
- (NSArray *)lvs_jsonsToModelsWithClass:(Class)cls;
@end

NS_ASSUME_NONNULL_END
