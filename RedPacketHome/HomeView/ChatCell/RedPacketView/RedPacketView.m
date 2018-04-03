//
//  RedPacketView.m
//  RedPacketApp
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RedPacketView.h"

@interface RedPacketView()
//黄色背景图
@property (nonatomic, strong) UIView *topView;
//红包标识
@property (nonatomic, strong) UILabel *redLabel;
//红包图标
@property (nonatomic, strong) UIImageView *redImgView;

@end

@implementation RedPacketView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //黄色背景图
        [self.topView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(0);
            make.bottom.equalTo(-30*m6Scale);
        }];
        //红包标识
        _redLabel = [UILabel LabelWithColor:[UIColor colorWithWhite:0.5 alpha:0.5] andTextFont:25 andText:@"来抢红包吧" addSubView:self];
        [_redLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottom).offset(-15*m6Scale);
            make.left.equalTo(20*m6Scale);
        }];
        //红包图标
        _redImgView = [UIImageView imageViewWithImageName:@"红包ImgView.jpg" addSubView:self.topView];
        [_redImgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30*m6Scale);
            make.centerY.equalTo(self.topView.centerY);
            make.size.equalTo(CGSizeMake(70*m6Scale, 70*m6Scale));
        }];
    }
    
    return self;
}
/**
 黄色背景图
 */
- (UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = RGBA(249 , 156, 70, 1);
        [self addSubview:_topView];
    }
    return _topView;
}

@end
