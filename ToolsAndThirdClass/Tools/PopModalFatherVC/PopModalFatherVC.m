//
//  PopModalFatherVC.m
//  RedPacketApp
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PopModalFatherVC.h"

@interface PopModalFatherVC ()

@end

@implementation PopModalFatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    //假的导航栏
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[Factory navgationImageWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)]];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    //返回按钮
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.top.mas_equalTo(40*m6Scale+KSafeBarHeight);
        make.size.mas_equalTo(CGSizeMake(88*m6Scale, 88*m6Scale));
    }];
    //标题
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(65*m6Scale+KSafeBarHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
/**
 *  返回按钮
 */
- (UIButton *)backButton{
    if(!_backButton){
        _backButton = [UIButton buttonWithType:0];
        
        [_backButton setImage:[UIImage imageNamed:@"whiteBackArrow"] forState:0];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
/**
 *  返回按钮事件
 */
- (void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 *  标题
 */
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:35*m6Scale];
    }
    return _titleLabel;
}

@end
