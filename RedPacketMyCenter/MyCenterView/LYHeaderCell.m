//
//  LYHeaderCell.m
//  RedPacketApp
//
//  Created by 刘园 on 2018/4/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LYHeaderCell.h"
// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface LYHeaderCell ()
//标题
@property(nonatomic, strong) UILabel *titleLabel;
//图片
@property(nonatomic, strong) UIImageView *imageNameView;
//详情
@property(nonatomic, strong) UILabel *infoLabel;
//二维码图片
@property(nonatomic, strong) UIImageView *codeImageView;

@end

@implementation LYHeaderCell

#pragma mark - inital
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _imageNameView = [[UIImageView alloc] init];
    _imageNameView.backgroundColor = [UIColor redColor];
    [self addSubview:_imageNameView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR16Font;
    [self addSubview:_titleLabel];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.font = PFR16Font;
    [self addSubview:_infoLabel];
    
    _codeImageView = [[UIImageView alloc] init];
    [self addSubview:_imageNameView];
    
}

#pragma mark - 布局
//对这个cell的真实有效部分进行设置
//-(void)setFrame:(CGRect)frame
//{
//
//    frame.origin.x += DCMargin;
//    frame.size.width -=  2 * DCMargin;
//
//    [super setFrame:frame];
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(DCMargin);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(60, 60));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageNameView.right).offset(15);
        make.top.equalTo(_imageNameView.top).offset(DCMargin);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageNameView.right).offset(15);
        make.top.equalTo(_titleLabel.bottom).offset(DCMargin);
    }];
    
    [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-30);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
}

#pragma mark - Setter Getter Methods


@end
