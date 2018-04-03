//
//  PlayVoiceImgView.h
//  RedPacketApp
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 PlayVoiceMessage 播放的语音消息来自发送方 接收方

 - PlayVoiceMessageFromSender: 播放的语音消息来自发送方
 - PlayVoiceMessageFromReciver: 播放的语音消息来自接收方
 */
typedef NS_ENUM(NSUInteger, PlayVoiceMessage) {
    PlayVoiceMessageFromSender,
    PlayVoiceMessageFromReciver
};

@interface PlayVoiceImgView : UIImageView

@property (nonatomic, assign) PlayVoiceMessage voiceMessageFrom;

- (void)setVoiceMessageFrom:(PlayVoiceMessage)voiceMessageFrom playTime:(int)playTime;

/**
 播放语音
 */
+ (void)playVoiceMessage:(EMMessage *)message;

@end
