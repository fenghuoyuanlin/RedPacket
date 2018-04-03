//
//  RecordVoiceView.m
//  RedPacketApp
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RecordVoiceView.h"
#import "CDPAudioRecorder.h"//引入.h文件

@interface RecordVoiceView()<CDPAudioRecorderDelegate>
//长按手势标签
@property (nonatomic, strong) UILabel *pressLabel;
//声音图标
@property (nonatomic, strong) UIImageView *soundImgView;
//录音对象
@property (nonatomic, strong) CDPAudioRecorder *recorder;
//录音文件路径
@property (nonatomic, strong) NSString *filePath;

@end

@implementation RecordVoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = backGroundColor;
        //长按手势标签
        [self addSubview:self.pressLabel];
        [self.pressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(0);
        }];
    }
    
    return self;
}
/**
 录音对象
 */
- (CDPAudioRecorder *)recorder{
    if(!_recorder){
        _recorder = [CDPAudioRecorder shareRecorder];
        _recorder.delegate = self;
    }
    return _recorder;
}
/**
 声音图标
 */
- (UIImageView *)soundImgView{
    if(!_soundImgView){
        _soundImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mic_0"]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_soundImgView];
        [_soundImgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(window.centerX);
            make.centerY.equalTo(window.centerY);
            make.size.equalTo(CGSizeMake(128*m6Scale, 128*m6Scale));
        }];
    }
    return _soundImgView;
}
/**
 长按手势标签
 */
- (UILabel *)pressLabel{
    if(!_pressLabel){
        _pressLabel = [UILabel LabelWithColor:[UIColor colorWithWhite:0.5 alpha:0.5] andTextFont:30 andText:@"长按录音" addSubView:self];
        _pressLabel.userInteractionEnabled = YES;
        _pressLabel.textAlignment = NSTextAlignmentCenter;
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        [_pressLabel addGestureRecognizer:longPress];
    }
    return _pressLabel;
}
/**
 长按手势事件
 */
- (void)longPressClick:(UILongPressGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateBegan) {
        _pressLabel.text = @"松开手，发送录音";
        self.soundImgView.hidden = NO;
        [self.recorder startRecording];
    }else if (press.state == UIGestureRecognizerStateEnded){
        _pressLabel.text = @"长按录音";
        self.soundImgView.hidden = YES;
        [self endRecord];
    }
}
/**
 *  更新音量分贝数峰值(0~1)  <CDPAudioRecorderDelegate>
 */
-(void)updateVolumeMeters:(CGFloat)value{
    NSInteger no=0;
    
    if (value>0&&value<=0.14) {
        no = 1;
    } else if (value<= 0.28) {
        no = 2;
    } else if (value<= 0.42) {
        no = 3;
    } else if (value<= 0.56) {
        no = 4;
    } else if (value<= 0.7) {
        no = 5;
    } else if (value<= 0.84) {
        no = 6;
    } else{
        no = 7;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"mic_%ld",(long)no];
    _soundImgView.image = [UIImage imageNamed:imageName];
}
//录音结束(url为录音文件地址,isSuccess是否录音成功)
-(void)recordFinishWithUrl:(NSString *)url isSuccess:(BOOL)isSuccess{
    //生成amr文件将要保存的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [path stringByAppendingPathComponent:@"CDPAudioFiles/CDPAudioRecord.amr"];
    
    //caf转码为amr格式
    [CDPAudioRecorder convertCAFtoAMR:[NSURL URLWithString:url].path savePath:self.filePath];
    
    NSLog(@"转码amr格式成功----文件地址为:%@",self.filePath);
}
//点击松开结束录音
-(void)endRecord{
    double currentTime=_recorder.recorder.currentTime;
    NSLog(@"本次录音时长%lf",currentTime);
    if (currentTime<1) {
        //时间太短
        _soundImgView.image = [UIImage imageNamed:@"mic_0"];
        [self alertWithMessage:@"说话时间太短"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recorder stopRecording];
            [self.recorder deleteAudioFile];
        });
    }
    else{
        //成功录音
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_recorder stopRecording];
            //生成录音Message
            EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:self.filePath displayName:@"audio"];
            body.duration = currentTime;
            NSString *from = [[EMClient sharedClient] currentUsername];
            
            EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.conversation.conversationId body:body ext:nil];
            message.chatType = EMChatTypeChat;// 设置为单聊消息
//            [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
//                NSLog(@"%@   %@", message, error);
//            }];
            
            [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
                NSLog(@"上传进度%d", progress);
            } completion:^(EMMessage *message, EMError *error) {
                NSLog(@"%@   %@", message, error);
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _soundImgView.image=[UIImage imageNamed:@"mic_0"];
            });
        });
    }
}
//alertView提示
-(void)alertWithMessage:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

@end
