//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//  XCQ_tabbar.h
//  自定义tabbar
//
//  Created by Mr.X on 2016/12/14.
//  Copyright © 2016年 Mr.X. All rights reserved.
//
#import <UIKit/UIKit.h>
/**
    自定义tabbar 上的按钮，可以定义选中和非选中的图片与标题
 **/

#define XCQRandColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0]

@interface XCQ_tabbar : UIView
//未选中图片
@property(nonatomic,strong) UIImage *unSelectedImg ;
//选中图片
@property(nonatomic,strong) UIImage *selectedImg ;
//点击事件
@property(nonatomic,assign) id tabbarTarget ;
@property(nonatomic,assign) SEL tabbarAction;
//选中状态以及推送红点状态
@property(nonatomic,assign) BOOL tabbarSelected ,redIndex;
//盛放tabbarBtn的View
@property(nonatomic,strong) UIView *itemView ;
//显示标题的title
@property(nonatomic,strong) UILabel *titleLabel ;
//显示标签图片的imgView
@property(nonatomic,strong) UIImageView *tabbarImgView ;


#pragma mark -- 按钮的初始化方法

-(id)initWithFrame:(CGRect)frame
 withUnSelectedImg:(UIImage *)unSelectedImg
   withSelectedImg:(UIImage *)selectedImg
         withTitle:(NSString *)tabbarTitle ;

#pragma mark -- 按钮的点击事件

-(void)setClickEventTarget:(id)target action:(SEL)action ;

#pragma mark -- tabbar按钮添加徽标以及徽标数目

-(void)setRedIndex:(BOOL)redIndex andBudgeNum:(NSInteger)budgeNum;

-(void)setSelected:(BOOL)selected ;

@end
