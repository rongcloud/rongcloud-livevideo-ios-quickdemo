//
//  LVSLiveInfoView.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/29.
//

#import "LVSLiveInfoView.h"

@interface LVSLiveInfoView ()
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomIdLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userIdLabel;
@end

@implementation LVSLiveInfoView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = lvsMainColor;
        self.alpha = 0.8;
        [self buildLayout];
    }
    return self;
}

- (void)updateLiveInfo:(NSString *)roomName roomId:(NSString *)roomId userName:(NSString *)userName userId:(NSString *)userId {
    self.roomNameLabel.text = [NSString stringWithFormat:@"房间名：%@",roomName];
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",roomId];
    self.userNameLabel.text = [NSString stringWithFormat:@"用户名：%@",userName];
    self.userIdLabel.text = [NSString stringWithFormat:@"用户ID：%@",userId];
}

- (UILabel *)roomNameLabel {
    if (_roomNameLabel == nil) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.font = [UIFont systemFontOfSize:12];
        _roomNameLabel.textColor = [UIColor whiteColor];
    }
    return _roomNameLabel;
}

- (UILabel *)roomIdLabel {
    if (_roomIdLabel == nil) {
        _roomIdLabel = [[UILabel alloc] init];
        _roomIdLabel.font = [UIFont systemFontOfSize:12];
        _roomIdLabel.textColor = [UIColor whiteColor];
    }
    return _roomIdLabel;
}

- (UILabel *)userNameLabel {
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:12];
        _userNameLabel.textColor = [UIColor whiteColor];
    }
    return _userNameLabel;
}

- (UILabel *)userIdLabel {
    if (_userIdLabel == nil) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.font = [UIFont systemFontOfSize:12];
        _userIdLabel.textColor = [UIColor whiteColor];
    }
    return _userIdLabel;
}

- (void)buildLayout {
    [self addSubview:self.roomNameLabel];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self);
    }];
    
    [self addSubview:self.roomIdLabel];
    [self.roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self.roomNameLabel.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self.roomIdLabel.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.userIdLabel];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(10);
    }];
    
}
@end
