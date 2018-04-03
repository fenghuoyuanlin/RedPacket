//
//  ConversationDetailsVC.h
//  RedPacketApp
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 接收到消息 到聊天列表页面刷新UI
 */
typedef void(^refreshConversationList)(void);
/**
 将所有消息设为已读
 */
typedef void(^markAllMessageAsRead)(void);

@interface ConversationDetailsVC : UIViewController

@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) NSString *conversationTitle;//会话标题
@property (nonatomic, copy) refreshConversationList refreshList;
@property (nonatomic, copy) markAllMessageAsRead allMessageRead;

- (void)didReceiveMessage:(NSArray *)messages;

@end
