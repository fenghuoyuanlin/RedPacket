//
//  UILabel+Category.h
//  HengShuaWallet
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 guanrukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)
    
    /**
     生成Label，颜色自定义
     */
+ (UILabel *)LabelWithColor:(UIColor *)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view;
    
    @end

