//
//  Factory.h
//  RedPacketApp
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FormatterType){
    YYYYMMDDHHMMSSType,
    YYYYMMDDHHMMType,
    YYYYMMDDType,
};

@interface Factory : NSObject

@property (nonatomic, assign) FormatterType type;

//右边的按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andrightStr:(NSString *)rightStr;
//右边图片按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andImageName:(NSString *)ImageName;
//时间戳转换日期
+ (NSString *)translateDateWithStr:(NSString *)dateStr;
/**
 * 因为在项目中要遇到一些后台返回的字符串或者其他空值 要做特殊处理 校验这个值是否为空
 */
+ (BOOL)theidTypeIsNull:(id)type;
//获取当前时间的时间戳
+(NSString *)getNowTimeTimestamp;
/**
 根据字符串计算label高度
 */
+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;
/**
 聊天页面中  两条消息之间相差小于1分钟 则不显示时间 反之显示时间
 */
+ (NSString *)compareTimeDifferenceBetweenLastTime:(NSString *)lastTime andTopTime:(NSString *)topTime;
/**
 提示框
 */
+ (void)alertMes:(NSString *)mes;
//左边的按钮
+ (UIButton *)addLeftbottonToVC:(UIViewController *)vc;
//左边的按钮(灰色)
+ (UIButton *)addBlackLeftbottonToVC:(UIViewController *)vc;
//画一个渐变色的图片
+(UIImage *)navgationImageWithFrame:(CGRect)frame;
/**
 消息提示音乐
 */
+ (void)reciveMessageAlterVoice;

@end
