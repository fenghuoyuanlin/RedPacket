//
//  UIView+Category.m
//  RedPacketApp
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)
//查找当前视图所在的视图控制器
- (UIViewController *)ViewController {

    UIResponder *next = self.nextResponder;
    while (YES) {
        
        if ([next.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next.nextResponder;
        } else if (next.nextResponder == nil) {
            return nil;
        }
        
        next = next.nextResponder;
    }
}

@end
