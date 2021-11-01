//
//  UIImage+Color.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/11/1.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)
+ (UIImage*)imageWithColor:(UIColor*)color {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
