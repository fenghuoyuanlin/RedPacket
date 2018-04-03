//
//  Factory.m
//  RedPacketApp
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Factory.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation Factory
//右边的按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andrightStr:(NSString *)rightStr{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    
    [button setTitle:rightStr forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBarButton;
    return button;
}
//右边图片按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andImageName:(NSString *)ImageName{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBarButton;
    return button;
}
//时间戳转换日期
+ (NSString *)translateDateWithStr:(NSString *)dateStr {
    
    dateStr = [NSString stringWithFormat:@"%lf", dateStr.doubleValue/1000.0];
    //时间戳转换为时间的详细处理
    return [Factory timeTampTranslateToTime:dateStr];
}
/**
 时间戳转换为时间的详细处理
 */
+ (NSString *)timeTampTranslateToTime:(NSString *)dateStr{
    //获取当前时间戳
    NSString *timesTamp = [Factory getNowTimeTimestamp];
    //当前时间戳转换为时间
    NSString *currentTime = [Factory timeStampByStr:timesTamp type:YYYYMMDDHHMMType];
    //消息时间戳转换为时间
    NSString *messageTime = [Factory timeStampByStr:dateStr type:YYYYMMDDHHMMType];
    //最终显示在UI页面的时间
    NSString *displayTime = @"";
    NSArray *currentTimeArray = [currentTime componentsSeparatedByString:@"-"];
    NSArray *messageTimeArray = [messageTime componentsSeparatedByString:@"-"];
    //首先判断 年月日是否相同
    if ([currentTimeArray[0] intValue] == [messageTimeArray[0] intValue]) {
        if ([currentTimeArray[1] intValue] == [messageTimeArray[1] intValue]) {
            if ([currentTimeArray[2] intValue] == [messageTimeArray[2] intValue]) {
                NSTimeInterval inter = [dateStr doubleValue];
                NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:inter];
                //年月日相同
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"HH:mm";
                //时间转换日期
                displayTime = [formatter stringFromDate:newDate];
                return displayTime;
            }else if ([currentTimeArray[2] intValue] == [messageTimeArray[2] intValue]+1){
                displayTime = @"昨天";
                return displayTime;
            }else if ([currentTimeArray[2] intValue] == [messageTimeArray[2] intValue]+2){
                displayTime = @"前天";
                return displayTime;
            }
        }
    }
    
    displayTime = [Factory timeStampByStr:dateStr type:YYYYMMDDType];
    
    return displayTime;
}
//时间戳转化为时间日期
+ (NSString *)timeStampByStr:(NSString *)creaTime type:(FormatterType)type{
    //时间戳转化成时间
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    switch (type) {
        case YYYYMMDDHHMMSSType:
            [stampFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case YYYYMMDDHHMMType:
            [stampFormatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
            break;
        case YYYYMMDDType:
            [stampFormatter setDateFormat:@"yyyy/MM/dd"];
            break;
            
        default:
            break;
    }
    
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[creaTime doubleValue]];
    NSString *strDate = [stampFormatter stringFromDate:stampDate2];
    return strDate;
}
//获取当前时间的时间戳
+(NSString *)getNowTimeTimestamp
{
    NSDate *senddate = [NSDate date];
    
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    return date2;
}
/**
 * 因为在项目中要遇到一些后台返回的字符串或者其他空值 要做特殊处理 校验这个值是否为空
 */
+ (BOOL)theidTypeIsNull:(id)type{
    NSString *string = [NSString stringWithFormat:@"%@", type];
    
    if (![string isEqual:[NSNull null]] && ![string isEqual:@""] && string != nil && ![string isEqualToString:@"<null>"] && ![string isEqualToString:@"(null)"]) {
        return NO;
    }else{
        return YES;
    }
}
/**
 根据字符串计算label高度
 */
+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    height = (height < 50*m6Scale) ? 50*m6Scale : height;
    
    return height;
}
/**
 聊天页面中  两条消息之间相差小于1分钟 则不显示时间 反之显示时间
 */
+ (NSString *)compareTimeDifferenceBetweenLastTime:(NSString *)lastTime andTopTime:(NSString *)topTime{
    NSString *time = @"";
    lastTime = [Factory timeStampByStr:[NSString stringWithFormat:@"%lf", lastTime.doubleValue/1000.0] type:YYYYMMDDHHMMSSType];
    topTime = [Factory timeStampByStr:[NSString stringWithFormat:@"%lf", topTime.doubleValue/1000.0] type:YYYYMMDDHHMMSSType];
    NSArray *lastArr = [lastTime componentsSeparatedByString:@":"];
    NSArray *topArr = [topTime componentsSeparatedByString:@":"];
    if (![lastArr[1] isEqualToString:topArr[1]]) {
        time = lastTime;
    }
    
    return time;
}
//左边的按钮
+ (UIButton *)addLeftbottonToVC:(UIViewController *)vc
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    //[button setImage:[UIImage imageNamed:@"Back-Arrow"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"whiteBackArrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.leftBarButtonItem = leftBarButton;
    return button;
}
//左边的按钮(灰色)
+ (UIButton *)addBlackLeftbottonToVC:(UIViewController *)vc
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:@"blackBackArrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.leftBarButtonItem = leftBarButton;
    return button;
}
//给view加渐变色
+ (void)colorLayer :(UIView *)view {
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [gradientLayer setColors:@[(__bridge id)UIColorFromRGB(0x009efd).CGColor, (__bridge id)UIColorFromRGB(0x1ad4be).CGColor]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [view.layer addSublayer:gradientLayer];
}
//view转化为图片
+(UIImage *)convertViewToImage:(UIView*)view{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//画一个渐变色的图片
+(UIImage *)navgationImageWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [self colorLayer :view];
    UIImage *image = [self convertViewToImage:view];
    return image;
}
//画一个渐变色灰色的图片
+(UIImage *)initImageWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    //    view.backgroundColor = RGB(136, 136, 136);
    //[self colorLayer :view];
    UIImage *image = [self convertViewToImage:view];
    return image;
}
/**
 消息提示音乐
 */
+ (void)reciveMessageAlterVoice{
    //定义一个SystemSoundID
    SystemSoundID soundID = 1007;//具体参数详情下面贴出来
    //播放声音
    AudioServicesPlaySystemSound(soundID);
}
/**
 提示框(1.5s后自动消失)
 */
+ (void)alertMes:(NSString *)mes{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view;
        if (view == nil) view = [UIApplication sharedApplication].delegate.window;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.contentColor = [UIColor grayColor];
        hud.label.text = mes;
        hud.label.numberOfLines = 0;
        hud.mode = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.5];
    });
}
@end
