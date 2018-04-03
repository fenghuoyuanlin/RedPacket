//
//  PlayVoiceImgView.m
//  RedPacketApp
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PlayVoiceImgView.h"
#import "CDPAudioRecorder.h"//引入.h文件

@interface PlayVoiceImgView()

@property (nonatomic, strong) UIImageView *imageView;//波浪小图标

@property (nonatomic, strong) UILabel *timeLabel;//录音时间

@end

@implementation PlayVoiceImgView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}
/**
 波浪小图标
 */
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}
/**
 录音时间
 */
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [UILabel LabelWithColor:[UIColor colorWithWhite:0.5 alpha:0.5] andTextFont:24 andText:@"" addSubView:self];
    }
    return _timeLabel;
}
-(void)setVoiceMessageFrom:(PlayVoiceMessage)voiceMessageFrom playTime:(int)playTime{
    UIImage *image = nil;
    self.timeLabel.text = [NSString stringWithFormat:@"%d''", playTime];
    switch (voiceMessageFrom) {
        case PlayVoiceMessageFromSender:{
            image = [UIImage imageNamed:@"chat_sender_bg@2x"];
            self.imageView.image = [UIImage imageNamed:@"chat_sender_audio_playing_003@2x"];
            
            [self.imageView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
                make.centerY.equalTo(self.centerY);
                make.right.equalTo(-20*m6Scale);
            }];
            
            [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.imageView.left).offset(-20*m6Scale);
                make.centerY.equalTo(self.centerY);
            }];
        }
            break;
        case PlayVoiceMessageFromReciver:{
            image = [UIImage imageNamed:@"chat_receiver_bg@2x"];
            self.imageView.image = [UIImage imageNamed:@"chat_receiver_audio_playing_full@2x"];
            [self.imageView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
                make.centerY.equalTo(self.centerY);
                make.left.equalTo(20*m6Scale);
            }];
            
            [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.right).offset(20*m6Scale);
                make.centerY.equalTo(self.centerY);
            }];
        }
            break;
            
        default:
            break;
    }
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:35];
    self.image = image;
}
/**
 播放语音
 */
+ (void)playVoiceMessage:(EMMessage *)message{
    EMVoiceMessageBody *body = (EMVoiceMessageBody *)message.body;
    NSLog(@"文件大小%lld   文件路径%@  附件的显示名%@", body.fileLength, body.localPath, body.displayName);
    NSURL *url = [NSURL fileURLWithPath:body.localPath];
    [[CDPAudioRecorder shareRecorder] playAudioWithUrl:url.absoluteString];
}
@end
