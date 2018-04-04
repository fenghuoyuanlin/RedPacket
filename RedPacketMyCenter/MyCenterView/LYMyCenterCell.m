//
//  LYMyCenterCell.m
//  RedPacketApp
//
//  Created by 刘园 on 2018/4/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LYMyCenterCell.h"
// Controllers

// Models
#import "MyCenterModel.h"
// Views

// Vendors

// Categories

// Others

@interface LYMyCenterCell ()
//标题
@property(nonatomic, strong) UILabel *titleLabel;
//图片
@property(nonatomic, strong) UIImageView *imageNameView;
//详情
@property(nonatomic, strong) UILabel *infoLabel;
//底部分割线
@property(nonatomic, strong) UIView *cellLine;

@end

@implementation LYMyCenterCell

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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR14Font;
    [self addSubview:_titleLabel];
    
    _imageNameView = [[UIImageView alloc] init];
    [self addSubview:_imageNameView];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.font = PFR14Font;
    [self addSubview:_infoLabel];
    
    _cellLine = [[UIView alloc] init];
    _cellLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self addSubview:_cellLine];
    
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
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageNameView.right).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-DCMargin);
        make.centerY.equalTo(self.centerY);
    }];
    
    [_cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(1);
        make.bottom.equalTo(0);
    }];
    
}

#pragma mark - Setter Getter Methods
-(void)setCenterModel:(MyCenterModel *)centerModel
{
    _centerModel = centerModel;
    _titleLabel.text = centerModel.title;
    
}

@end
