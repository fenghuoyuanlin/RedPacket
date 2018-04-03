//
//  UILabel+Category.m
//  HengShuaWallet
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 guanrukeji. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)
    
    /**
     生成Label，颜色自定义
     */
+ (UILabel *)LabelWithColor:(UIColor *)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font*m6Scale];
    label.text = text;
    [view addSubview:label];
    
    return label;
}
    
    @end

