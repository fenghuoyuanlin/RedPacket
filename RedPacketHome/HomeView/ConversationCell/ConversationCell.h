//
//  ConversationCell.h
//  RedPacketApp
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationCell : UITableViewCell

@property (nonatomic, strong) UIImageView *messageImageView;//会话图标、头像
@property (nonatomic, strong) UILabel *titleLabel;//会话标题或对象昵称
@property (nonatomic, strong) UILabel *unreadNumLabel;//未读消息数量
@property (nonatomic, strong) UILabel *messsageContentLabel;//会话消息内容
@property (nonatomic, strong) UILabel *timeLabel;//会话时间
@property (nonatomic, strong) NSString *unReadMessageCount;//未读消息数量

@property (nonatomic, strong) EMConversation *conversation;

@end
