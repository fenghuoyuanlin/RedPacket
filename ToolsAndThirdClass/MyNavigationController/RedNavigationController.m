//
//  RedNavigationController.m
//  RedPacketApp
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RedNavigationController.h"

@interface RedNavigationController ()

@end

@implementation RedNavigationController

#pragma mark - load初始化一次
+ (void)load
{
    [self setUpBase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - <初始化>
+ (void)setUpBase
{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor whiteColor];
    [bar setShadowImage:[UIImage new]];
    //修改导航栏上返回按钮图片状态的颜色(之前是设置白色的，如果图片上是黑色的，那么也会紧跟着白色图片)
    [bar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置导航栏字体颜色
    UIColor * naiColor = [UIColor whiteColor];
    attributes[NSForegroundColorAttributeName] = naiColor;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:40*m6Scale];
    bar.titleTextAttributes = attributes;
}

#pragma mark - <返回>
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count >= 1) {
        //返回按钮自定义
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"whiteBackArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
        
        //影藏BottomBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //跳转
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 点击
- (void)backClick {
    
    [self popViewControllerAnimated:YES];
}

@end
