//
//  UIButton+Category.m
//  HengShuaWallet
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 guanrukeji. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

//runtime用键取值 此处定义一个键  键的类型随意 int 什么都可以  但是char类型占用内存最小
static char buttonActionKey;

@implementation UIButton (Category)
    
    //按钮背景色的setter 和 getter方法实现
- (void)setColor:(SXYButtonBackColor)color{
    objc_setAssociatedObject(self, @selector(color), @(color), OBJC_ASSOCIATION_ASSIGN);
    if (color == ButtonWhiteColor){
        self.userInteractionEnabled = YES;
        [self setTitleColor:UIColorFromRGB(0x1ad4be) forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
    }else if (color == ButtonClearColor){
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }else if (color == ButtonYellowColor){
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:[UIColor yellowColor]];
    }else if (color == ButtonWhiteColorWithLine){
        [self setTitleColor:UIColorFromRGB(0x009efd) forState:0];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColorFromRGB(0x009efd).CGColor;
    }else if (color == ButtonBlueColor){
        //        [self setBackgroundColor:RGB(108, 234, 206)];
        self.userInteractionEnabled = YES;
    }
}
    
- (SXYButtonBackColor)color{
    NSNumber *value = objc_getAssociatedObject(self, @selector(color));
    return value.intValue;
}
    
    /**
     *  适用于 有背景颜色 有圆角 的按钮 点击事件可以在block回调中处理
     */
+ (UIButton *)ButtonWithTitle:(NSString *)title ButtonBackColor:(SXYButtonBackColor)buttonBackColor CornerRadius:(CGFloat)radius addSubView:(UIView *)subView buttonActionBlock:(ButtonActionBlock)buttonActionBlock{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:0];
    button.layer.cornerRadius = radius*m6Scale;
    button.layer.masksToBounds = YES;
    button.color = buttonBackColor;
    //取消点击按钮时候的闪烁
    button.adjustsImageWhenHighlighted = NO;
    if (buttonActionBlock) {
        [button addTarget:button action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        //最关键的 步骤  block 既可以作为参数 又可以 作为方法  此处将block作为参数  动态绑定到 button上
        objc_setAssociatedObject(button, &buttonActionKey, buttonActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [subView addSubview:button];
    
    return button;
}
    /**
     按钮的点击事件
     
     @param button 按钮
     */
- (void)buttonAction:(UIButton *)button{
    //取出绑定在button上的block
    ButtonActionBlock block = objc_getAssociatedObject(button, &buttonActionKey);
    block(button);
}
    
    @end

