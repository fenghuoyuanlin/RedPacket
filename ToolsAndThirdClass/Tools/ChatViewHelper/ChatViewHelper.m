//
//  ChatViewHelper.m
//  RedPacketApp
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChatViewHelper.h"

@implementation ChatViewHelper
/**
 计算单行文本的大小
 */
+ (CGFloat)calculateSingleTextSizeWithLabel:(UILabel *)label{
    CGFloat width = 0;
    // 根据字体得到NSString的尺寸
    CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil]];
    if (size.width < kScreenWidth*0.65) {
        width = size.width;
    }else{
        width = kScreenWidth*0.65;
        label.textAlignment = NSTextAlignmentLeft;
    }
    width = width+20*m6Scale;
    
    return width;
}
/**
 冒泡排序会话列表的列表顺序 按时间最新到最旧排序
 */
+ (void)bubbleSortWithDataSource:(NSMutableArray *)dataSource unReadArray:(NSMutableArray *)unReadArray{
    [unReadArray removeAllObjects];
    for (int i = 0; i < dataSource.count; i++) {
        for (int j = 0; j < dataSource.count-i-1; j++) {
            EMConversation *Jconver = dataSource[j];
            EMConversation *JMoreConver = dataSource[j+1];
            if (Jconver.latestMessage.localTime < JMoreConver.latestMessage.localTime) {
                EMConversation *tempConversation = dataSource[j+1];
                [dataSource replaceObjectAtIndex:j withObject:tempConversation];
                [dataSource replaceObjectAtIndex:j+1 withObject:Jconver];
            }
        }
    }
    for (int i = 0; i < dataSource.count; i++) {
        EMConversation *Iconver = dataSource[i];
        [unReadArray addObject:[NSString stringWithFormat:@"%d", Iconver.unreadMessagesCount]];
    }
}
/**
 下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 
 异步方法
 */
+ (void)asyncDownloadMessage:(id)message{
    EMMessage *mess = (EMMessage *)message;
    [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:mess progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        
    }];
}
/**
 发红包页面  返回footerView
 */
+ (UIView *)returnFooterViewWithSection:(NSInteger)section{
    if (section < 2) {
        NSArray *array = @[@"红包个数范围：2-4955个", @"按此金额进行计算"];
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [UILabel LabelWithColor:[UIColor colorWithWhite:0.5 alpha:0.5] andTextFont:30 andText:array[section] addSubView:footerView];
        [footerView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20*m6Scale);
            make.top.equalTo(0);
        }];
        
        return footerView;
    }else if(section == 4){
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        
        return footerView;
    }else{
        return nil;
    }
}
/**
 cell内容高度解析
 */
+ (CGFloat)heightForMessageContentCellWithMessage:(id)message{
    EMMessage *mssage = (EMMessage *)message;
    EMMessageBody *body = mssage.body;
    NSString *messageText = @"";
    switch (body.type) {
        case EMMessageBodyTypeText:{
            EMTextMessageBody *messageBody = (EMTextMessageBody *)body;
            messageText = messageBody.text;
        }
            break;
            
        default:
            break;
    }
    //计算label的高度
    CGFloat height = [Factory getHeightLineWithString:messageText withWidth:kScreenWidth*0.65 withFont:[UIFont systemFontOfSize:28*m6Scale]];
    height = (height < 74*m6Scale) ? 74*m6Scale : height;
    if ([mssage.ext[@"type"] isEqualToString:@"sendRedPacket"]) {
        height = 180*m6Scale;
    }
    
    return height+46*m6Scale;
}

@end
