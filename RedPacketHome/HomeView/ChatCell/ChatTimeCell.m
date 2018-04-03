//
//  ChatTimeCell.m
//  RedPacketApp
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChatTimeCell.h"

@interface ChatTimeCell()

@property (nonatomic, strong) UILabel *timeLabel;//时间标签

@end

@implementation ChatTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = backGroundColor;
        //获取消息的时间
        _timeLabel = [UILabel LabelWithColor:[UIColor colorWithWhite:0.5 alpha:0.5] andTextFont:30 andText:@"" addSubView:self];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
        }];
    }
    
    return self;
}

- (void)setMessageTime:(NSString *)messageTime{
    _timeLabel.text = messageTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
