//
//  MacroDefinition.h
//  AppFramePlate
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

/**
 *  如果不需要log,把1改成0
 */
#define  myTest  1
#if myTest

#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil
#endif

//电池栏
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏
#define kNavBarHeight 44.0
//tabbar高度
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
//导航+电池栏
#define NavigationBarHeight (kStatusBarHeight + kNavBarHeight)
//安全区底部高度
#define KSafeBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0)

/**
 *  屏幕尺寸宽和高
 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/**
 *  比例系数适配
 */
#define m6PScale              kScreenWidth/1242.0
#define m6Scale               kScreenWidth/750.0
#define m5Scale               kScreenWidth/640.0

//存储到本地
#define UserDefaults(Object, Key)\
[[NSUserDefaults standardUserDefaults] setValue:Object forKey:Key];\

#define defaults [NSUserDefaults standardUserDefaults]

/********颜色相关宏***********/
//十六进制颜色
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
/**
 *  背景颜色
 */
#define backGroundColor [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0/255.0 alpha:1.0]
/** 弱引用 */
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#endif /* MacroDefinition_h */
