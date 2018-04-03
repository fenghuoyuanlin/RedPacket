//
//  NSString+Category.m
//  RedPacketApp
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (CGSize)stringSizeWithContentSize:(CGSize)contentSize font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [self boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

@end
