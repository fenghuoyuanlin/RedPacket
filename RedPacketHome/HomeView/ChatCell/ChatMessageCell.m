//
//  ChatCell.m
//  RedPacketApp
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChatMessageCell.h"
#import "RedPacketView.h"

@interface ChatMessageCell()

@property (nonatomic, strong) UIImageView *backImgView;//聊天背景图

@property (nonatomic, strong) PlayVoiceImgView *voiceImgView;//播放语音

@property (nonatomic, strong) RedPacketView *packetView;//红包视图

@end

@implementation ChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = backGroundColor;
        //用户头像
        _headerImageView = [[UIImageView alloc] init];
        [self addSubview:_headerImageView];
        //聊天背景图
        _backImgView = [[UIImageView alloc] init];
        [self addSubview:_backImgView];
        //会话内容
        _contentLabel = [UILabel LabelWithColor:[UIColor blackColor] andTextFont:33 andText:@"" addSubView:_backImgView];
        _contentLabel.numberOfLines = 0;
    }
    
    return self;
}
/**
 播放语音
 */
- (PlayVoiceImgView *)voiceImgView{
    if(!_voiceImgView){
        _voiceImgView = [[PlayVoiceImgView alloc] init];
        [self addSubview:_voiceImgView];
    }
    return _voiceImgView;
}
/**
 红包视图
 */
- (RedPacketView *)packetView{
    if(!_packetView){
        _packetView = [[RedPacketView alloc] init];
        [self addSubview:_packetView];
        [_packetView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerImageView.centerY);
            make.right.equalTo(self.headerImageView.left).offset(-25*m6Scale);
            make.size.equalTo(CGSizeMake(kScreenWidth*0.5, 140*m6Scale));
        }];
    }
    return _packetView;
}
-(void)setMessage:(EMMessage *)message{
    //头像
    if ([message.from isEqualToString:[[EMClient sharedClient] currentUsername]]) {
        _headerImageView.image = [UIImage imageNamed:@"5059454.png-thumb.jpg"];
    }else{
        _headerImageView.image = [UIImage imageNamed:@"u=3960794943,62863994&fm=27&gp=0.jpg"];
    }
    //会话内容
    NSString *messageText = @"";
    EMMessageBody *body = message.body;
    switch (body.type) {
            //文字消息
        case EMMessageBodyTypeText:{
            EMTextMessageBody *messageBody = (EMTextMessageBody *)body;
            messageText = messageBody.text;
            NSDictionary *diction = message.ext;
            
            BOOL isSendRedPacket = [diction[@"type"] isEqualToString:@"sendRedPacket"];
            _contentLabel.hidden = isSendRedPacket;
            _backImgView.hidden = isSendRedPacket;
            _contentLabel.text = (isSendRedPacket == YES) ? @"" : messageText;
            self.packetView.hidden = !isSendRedPacket;
            self.voiceImgView.hidden = YES;
            
            //判断消息的来源 发送方
            [self layoutChatContentFromOther:[message.from isEqualToString:[[EMClient sharedClient] currentUsername]]];
        }
            break;
        case EMMessageBodyTypeVoice:{
            self.packetView.hidden = YES;
            EMVoiceMessageBody *messageBody = (EMVoiceMessageBody *)body;
            BOOL other = [message.from isEqualToString:[[EMClient sharedClient] currentUsername]];
            _contentLabel.hidden = YES;
            _backImgView.hidden = YES;
            self.voiceImgView.hidden = NO;
            self.voiceImgView.voiceMessageFrom = (other==YES) ? PlayVoiceMessageFromSender : PlayVoiceMessageFromReciver;
            [self.voiceImgView setVoiceMessageFrom:self.voiceImgView.voiceMessageFrom playTime:messageBody.duration];
            [ChatViewHelper asyncDownloadMessage:message];
            [_headerImageView remakeConstraints:^(MASConstraintMaker *make) {
                if (!other) {
                    make.left.equalTo(20*m6Scale);
                }else{
                    make.right.equalTo(-20*m6Scale);
                }
                make.size.equalTo(CGSizeMake(80*m6Scale, 80*m6Scale));
                make.top.equalTo(20*m6Scale);
            }];
            [_voiceImgView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(150*m6Scale, 70*m6Scale));
                if (!other) {
                    make.left.equalTo(_headerImageView.right).offset(20*m6Scale);
                }else{
                    make.right.equalTo(_headerImageView.left).offset(-20*m6Scale);
                }
                make.centerY.equalTo(self.centerY);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutChatContentFromOther:(BOOL)other{
    _contentLabel.textAlignment = (!other) ? NSTextAlignmentLeft : NSTextAlignmentRight;
    [_headerImageView remakeConstraints:^(MASConstraintMaker *make) {
        if (!other) {
            make.left.equalTo(20*m6Scale);
        }else{
            make.right.equalTo(-20*m6Scale);
        }
        make.size.equalTo(CGSizeMake(80*m6Scale, 80*m6Scale));
        make.top.equalTo(20*m6Scale);
    }];
    //计算label的高度
    CGFloat height = [Factory getHeightLineWithString:_contentLabel.text withWidth:kScreenWidth*0.65 withFont:[UIFont systemFontOfSize:28*m6Scale]];
    CGFloat width = [ChatViewHelper calculateSingleTextSizeWithLabel:self.contentLabel];
    [_contentLabel remakeConstraints:^(MASConstraintMaker *make) {
        if (!other) {
            make.left.equalTo(_headerImageView.right).offset(40*m6Scale);
        }else{
            make.right.equalTo(_headerImageView.left).offset(-40*m6Scale);
        }
        make.top.equalTo(_headerImageView.top).offset(26*m6Scale);
        make.width.equalTo(width);
        make.height.equalTo(height);
    }];
    UIImage *image = nil;
    if (!other) {
        image = [UIImage imageNamed:@"chat_receiver_bg@2x"];
    }else{
        image = [UIImage imageNamed:@"chat_sender_bg@2x"];
    }
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:35];
    _backImgView.image = image;
    [_backImgView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel.left).offset(-30*m6Scale);
        make.right.equalTo(_contentLabel.right).offset(30*m6Scale);
        make.bottom.equalTo(_contentLabel.bottom).offset(10*m6Scale);
        make.top.equalTo(_contentLabel.top).offset(-10*m6Scale);
    }];
}

@end
