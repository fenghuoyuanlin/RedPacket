//
//  SendRedPacketCell.m
//  RedPacketApp
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SendRedPacketCell.h"

@interface SendRedPacketCell()

@property (nonatomic, strong) UIView *backView;//背景View
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation SendRedPacketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = [UIColor clearColor];
        //UI
        [self layoutUIView];
    }
    
    return self;
}
/**
 UI
 */
- (void)layoutUIView{
    //背景View
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 6*m6Scale;
    _backView.layer.masksToBounds = YES;
    [self addSubview:_backView];
    [_backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20*m6Scale);
        make.right.equalTo(-20*m6Scale);
        make.top.equalTo(35*m6Scale);
        make.bottom.equalTo(-35*m6Scale);
    }];
    //左标签
    _leftLabel = [UILabel LabelWithColor:[UIColor blackColor] andTextFont:40 andText:@"" addSubView:_backView];
    [_leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20*m6Scale);
        make.centerY.equalTo(_backView.centerY);
    }];
    ///右标签
    _rightLabel = [UILabel LabelWithColor:[UIColor blackColor] andTextFont:35 andText:@"" addSubView:_backView];
    [_rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20*m6Scale);
        make.centerY.equalTo(_backView.centerY);
    }];
}

-(void)setText:(NSString *)text{
    _leftLabel.text = text;
}

@end
