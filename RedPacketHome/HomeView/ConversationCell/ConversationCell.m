//
//  ConversationCell.m
//  RedPacketApp
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ConversationCell.h"

@interface ConversationCell()



@end

@implementation ConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //布局
        [self layoutConversationCell];
    }
    
    return self;
}
/**
 布局
 */
- (void)layoutConversationCell{
    //会话图标、头像
    _messageImageView = [[UIImageView alloc] init];
    [self addSubview:_messageImageView];
    [_messageImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20*m6Scale);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(100*m6Scale, 100*m6Scale));
    }];
    //未读消息数量
    _unreadNumLabel = [UILabel LabelWithColor:[UIColor whiteColor] andTextFont:24 andText:@"" addSubView:self];
    _unreadNumLabel.backgroundColor = [UIColor redColor];
    _unreadNumLabel.textAlignment = NSTextAlignmentCenter;
    _unreadNumLabel.layer.cornerRadius = 20*m6Scale;
    _unreadNumLabel.layer.masksToBounds = YES;
    [_unreadNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.centerY.equalTo(_messageImageView.top);
        make.left.equalTo(_messageImageView.right).offset(-20*m6Scale);
    }];
    //会话标题或对象昵称
    _titleLabel = [UILabel LabelWithColor:[UIColor blackColor] andTextFont:40 andText:@"" addSubView:self];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY).offset(-30*m6Scale);
        make.left.equalTo(_unreadNumLabel.right).offset(15*m6Scale);
    }];
    //会话消息内容
    _messsageContentLabel = [UILabel LabelWithColor:[UIColor colorWithWhite:0.5 alpha:1] andTextFont:35 andText:@"" addSubView:self];
    [_messsageContentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.left);
        make.centerY.equalTo(self.centerY).offset(30*m6Scale);
        make.right.equalTo(-80*m6Scale);
    }];
    //最后会话时间
    _timeLabel = [UILabel LabelWithColor:[UIColor blackColor] andTextFont:35 andText:@"" addSubView:self];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.centerY);
        make.right.equalTo(-20*m6Scale);
    }];
}

- (void)setConversation:(EMConversation *)conversation{
    //最后会话时间
    EMMessage *lastMessage = conversation.latestMessage;
    _timeLabel.text = [Factory translateDateWithStr:[NSString stringWithFormat:@"%lld", lastMessage.localTime]];
    //确认会话类型
    [self makeSureConversationContent:conversation];
}
/**
 确认会话内容
 */
- (void)makeSureConversationContent:(EMConversation *)conversation{
    //会话消息内容  获取最后一条会话消息
    EMMessage *lastMessage = conversation.latestMessage;
    EMMessageBody *body = lastMessage.body;
    switch (conversation.type) {
        case EMConversationTypeChat:{
            _titleLabel.text = conversation.conversationId;
            //单聊会话
            _messsageContentLabel.text = [self selectMessageTypeByBody:body];
            _messageImageView.image = [UIImage imageNamed:@"u=3960794943,62863994&fm=27&gp=0.jpg"];
        }
            break;
        case EMConversationTypeGroupChat:{
            _messageImageView.image = [UIImage imageNamed:@"0J2524G0-3.jpg"];
            [EMClient.sharedClient.groupManager getGroupSpecificationFromServerWithId:conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
                if ([Factory theidTypeIsNull:aGroup.subject]) {
                    //会话标题或对象昵称
                   _titleLabel.text = conversation.conversationId;
                }else{
                    //会话标题或对象昵称
                    _titleLabel.text = aGroup.subject;
                }
            }];
            //群聊会话
            if ([lastMessage.from isEqualToString:[[EMClient sharedClient] currentUsername]]) {
                _messsageContentLabel.text = [NSString stringWithFormat:@"%@",[self selectMessageTypeByBody:body]];
            }else{
                _messsageContentLabel.text = [NSString stringWithFormat:@"%@：%@",lastMessage.from, [self selectMessageTypeByBody:body]];
            }
        }
            break;
            
        default:
            break;
    }
}
/**
 未读消息数量
 */
-(void)setUnReadMessageCount:(NSString *)unReadMessageCount{
    NSLog(@"unReadMessageCount = %@", unReadMessageCount);
    if (unReadMessageCount.intValue) {
        _unreadNumLabel.hidden = NO;
        _unreadNumLabel.text = unReadMessageCount;
    }else{
        _unreadNumLabel.hidden = YES;
    }
}
/**
 筛选消息的类型
 */
- (NSString *)selectMessageTypeByBody:(EMMessageBody *)body{
    NSString *lastMessageTitle = @"";
    switch (body.type) {
        case EMMessageBodyTypeText:{
            EMTextMessageBody *messageBody = (EMTextMessageBody *)body;
            lastMessageTitle = messageBody.text;
        }
            break;
        case EMMessageBodyTypeVoice:{
            lastMessageTitle = @"[语音]";
        }
            break;
            
        default:
            break;
    }
    
    return lastMessageTitle;
}

@end
