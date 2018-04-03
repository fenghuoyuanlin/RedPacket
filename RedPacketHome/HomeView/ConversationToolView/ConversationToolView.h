//
//  ConversationToolView.h
//  RedPacketApp
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnKeyBoardHeight)(CGFloat height, CGFloat animationTime);

typedef void(^sendMessageBlock)(UITextField *textFiled);

@interface ConversationToolView : UIView

@property (nonatomic, copy) returnKeyBoardHeight keyBoardHeight;

@property (nonatomic, copy) sendMessageBlock sendMessage;

@property (nonatomic, assign) EMConversationType type;

@property (nonatomic, strong) EMConversation *conversation;//会话对象

@end
