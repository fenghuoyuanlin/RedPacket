//
//  AddRedPacketView.m
//  RedPacketApp
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddRedPacketView.h"
#import "SendRedPacketVC.h"
#import "ConversationDetailsVC.h"

@interface AddRedPacketView()

@end

@implementation AddRedPacketView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加按钮
        [self addButton];
        self.backgroundColor = backGroundColor;
    }
    
    return self;
}
/**
 添加按钮
 */
- (void)addButton{
    NSArray *titles = @[@"发红包"];
    NSArray *imageArr = @[@"红包ImgView.jpg"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:0];
        button.tag = 10000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30*m6Scale);
            make.top.equalTo(20*m6Scale);
            make.size.equalTo(CGSizeMake(70*m6Scale, 70*m6Scale));
        }];
        
        UILabel *label = [UILabel LabelWithColor:[UIColor blackColor] andTextFont:25 andText:titles[i] addSubView:self];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.bottom).offset(10*m6Scale);
            make.centerX.equalTo(button.centerX);
        }];
    }
}
/**
 点击事件
 */
- (void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 10000:{
//            //发红包按钮点击
            ConversationDetailsVC *conversationVC = (ConversationDetailsVC *)[self ViewController];
//            //跳转至发送红包页面
//            SendRedPacketVC *tempVC = [[SendRedPacketVC alloc] init];
//
//            [conversationVC presentViewController:tempVC animated:YES completion:^{
//
//            }];
            //环信 插入消息
            EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"发红包"];
            NSString *from = [[EMClient sharedClient] currentUsername];
            NSDictionary *messageExt = @{@"type":@"sendRedPacket"};
            //生成Message
            EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.conversation.conversationId body:body ext:messageExt];
            message.chatType = self.conversation.latestMessage.chatType;
            [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                NSLog(@"%@   %@", self.conversation.conversationId, error);
                if ([Factory theidTypeIsNull:error]) {
                    [conversationVC didReceiveMessage:@[message]];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}
@end
