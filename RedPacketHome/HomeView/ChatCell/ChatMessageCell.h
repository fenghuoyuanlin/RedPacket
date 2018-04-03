//
//  ChatCell.h
//  RedPacketApp
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayVoiceImgView.h"

@interface ChatMessageCell : UITableViewCell

@property (nonatomic, strong) EMMessage *message;

@property (nonatomic, strong) UIImageView *headerImageView;//用户头像
@property (nonatomic, strong) UILabel *contentLabel;//会话内容



@end
