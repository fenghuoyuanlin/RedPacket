//
//  UIView+Category.h
//  RedPacketApp
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

//查找当前视图所在的视图控制器
- (UIViewController *)ViewController;

@end
