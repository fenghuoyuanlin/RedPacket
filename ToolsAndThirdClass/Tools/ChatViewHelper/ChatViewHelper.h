//
//  ChatViewHelper.h
//  RedPacketApp
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatViewHelper : NSObject
/**
 计算单行文本的大小
 */
+ (CGFloat)calculateSingleTextSizeWithLabel:(UILabel *)label;
/**
 冒泡排序会话列表的列表顺序 按时间最新到最旧排序
 */
+ (void)bubbleSortWithDataSource:(NSMutableArray *)dataSource unReadArray:(NSMutableArray *)unReadArray;
/**
 下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 
 异步方法
 */
+ (void)asyncDownloadMessage:(id)message;
/**
 发红包页面  返回footerView
 */
+ (UIView *)returnFooterViewWithSection:(NSInteger)section;
/**
 cell内容高度解析
 */
+ (CGFloat)heightForMessageContentCellWithMessage:(id)message;

@end
