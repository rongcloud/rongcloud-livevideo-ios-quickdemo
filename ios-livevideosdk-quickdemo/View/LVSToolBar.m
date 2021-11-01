//
//  LVSToolBar.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/28.
//

#import "LVSToolBar.h"

static NSInteger kColumn = 4;

static NSInteger kMask = 999;

static CGFloat kSpace = 10.0f;

static CGFloat kButtonHeight = 40.0f;

#define kButtonWidth (kScreenWidth - (kColumn + 1)*kSpace)/kColumn

@interface LVSToolBar ()
@property (nonatomic, assign) BOOL initialized;
@end

@implementation LVSToolBar

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!_initialized) {
        _initialized = YES;
        [self buildLayout];
    }
}

#pragma mark - layout subviews

- (void)buildLayout {
    
    if (![self.dataSource respondsToSelector:@selector(numberOfItems)] || ![self.dataSource respondsToSelector:@selector(buttonForIndex:)]) {
        NSAssert(NO, @"numberOfItems & buttonForIndex must be complete");
    }
    
    NSInteger count = [self.dataSource numberOfItems];
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [self.dataSource buttonForIndex:i];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat x = (i%kColumn + 1)*kSpace + i%kColumn*kButtonWidth;
        CGFloat y = i/kColumn * (kButtonHeight + kSpace) + kSpace;
        button.frame = CGRectMake(x, y, kButtonWidth, kButtonHeight);
        button.tag = kMask + i;
        [self addSubview:button];
    }
}

#pragma mark - actions

- (void)buttonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(itemClickAtIndex:)]) {
        [self.delegate itemClickAtIndex:button.tag - kMask];
    }
}

@end
