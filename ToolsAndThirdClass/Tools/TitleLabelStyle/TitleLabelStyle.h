//
//  TitleLabelStyle.h
//  RedPacketApp
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleLabelStyle : UILabel

- (void)titleLabel:(NSString *)str color:(UIColor *)color;//白色字体
//添加titleView（灰色字体）
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title andTextColor:(CGFloat)color;
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title;//添加titleView
+ (void)addtitleViewToMyVC:(UIViewController *)vc withTitle:(NSString *)title;//添加titleView
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title color:(UIColor *)color;//添加titleView

@end
