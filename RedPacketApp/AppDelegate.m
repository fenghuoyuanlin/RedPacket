//
//  AppDelegate.m
//  RedPacketApp
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "XCQ_tabbarViewController.h"

#define EaseMobAppKey @"easemob-demo#chatdemoui"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor] ;
    [self.window makeKeyAndVisible];
    
    NSArray *selectedArr = @[@"ic_c_backetball",@"ic_c_eat",@"ic_c_leaf",@"ic_c_montain",@"ic_c_movie"]  ;
    NSArray *unSeleceArr = @[@"ic_c_backetball_gray",@"ic_c_eat_gray",@"ic_c_leaf_gray",@"ic_c_montain_gray",@"ic_c_movie_gray"] ;
    NSArray *titleArr = @[@"聊天",@"通讯录",@"游戏",@"分享",@"个人中心"] ;
    
    XCQ_tabbarViewController *xcq_tab = [[XCQ_tabbarViewController alloc]initWithNomarImageArr:unSeleceArr
                                                                             andSelectImageArr:selectedArr
                                                                                   andtitleArr:titleArr];
    xcq_tab.modalTransitionStyle =UIModalTransitionStyleCrossDissolve ;
    
    self.window.rootViewController = xcq_tab ;
    
    //初始化环信SDK
    [self initHuanXinSDK];
    
    return YES;
}
/**
 初始化环信SDK
 */
- (void)initHuanXinSDK{
    //AppKey
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAppKey];
    //推送证书名称，不用添加后缀
    options.apnsCertName = @"chatdemoui_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
/**
 App进入后台
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}
/**
 App将要从后台返回
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
