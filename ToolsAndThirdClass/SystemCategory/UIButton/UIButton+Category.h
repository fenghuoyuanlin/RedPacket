//
//  UIButton+Category.h
//  HengShuaWallet
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 guanrukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
//按钮的点击事件 block
typedef void(^ButtonActionBlock)(UIButton *button);

/**
 枚举按钮的背景颜色
 - ButtonNormalColor: 背景色主色调 可以交互
 - ButtonGrayColor: 灰色按钮 不可交互
 - ButtonWhiteColor: 白色背景按钮 可交互
 - ButtonClearColor: 透明色 可交互
 -ButtonYellowColor: 黄色 用于发验证码按钮 默认可交互
 */
typedef NS_ENUM(NSUInteger, SXYButtonBackColor){
    ButtonNormalColor,
    ButtonGrayColor,
    ButtonWhiteColor,
    ButtonClearColor,
    ButtonYellowColor,
    ButtonWhiteColorWithLine,
    ButtonBlueColor,
};

@interface UIButton (Category)
    
@property(nonatomic, assign) SXYButtonBackColor color;
    
/**
 *  适用于 有背景颜色 有圆角 的按钮 点击事件可以在block回调中处理
 */
+ (UIButton *)ButtonWithTitle:(NSString *)title ButtonBackColor:(SXYButtonBackColor)buttonBackColor CornerRadius:(CGFloat)radius addSubView:(UIView *)subView buttonActionBlock:(ButtonActionBlock)buttonActionBlock;
    
@end

