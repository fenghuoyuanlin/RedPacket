//
//  UIImageView+Category.m
//  RedPacketApp
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName addSubView:(UIView *)subView{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [subView addSubview:imgView];
    
    return imgView;
}

@end
