//
//  HomeTableViewCell.m
//  ios-livevideosdk-quickdemo
//
//  Created by xuefeng on 2021/10/27.
//

#import "HomeTableViewCell.h"

NSString *const HomeTableViewCellIdentifier = @"HomeTableViewCellIdentifier";

@interface HomeTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@end

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.leading.equalTo(self.contentView).offset(10);
        make.trailing.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentView addSubview:self.idLabel];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.leading.equalTo(self.contentView).offset(10);
        make.trailing.equalTo(self.contentView).offset(-10);
    }];
}

- (void)updateRoomName:(NSString *)roomName roomId:(NSString *)roomId {
    self.nameLabel.text = [NSString stringWithFormat:@"房间名: %@",roomName];
    self.idLabel.text = [NSString stringWithFormat:@"房间ID: %@",roomId];
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)idLabel {
    if (_idLabel == nil) {
        _idLabel = [[UILabel alloc] init];
        _idLabel.font = [UIFont systemFontOfSize:14];
        _idLabel.textColor = [UIColor blackColor];
    }
    return _idLabel;
}

@end
