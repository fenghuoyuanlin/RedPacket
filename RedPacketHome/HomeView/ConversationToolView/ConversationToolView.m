//
//  ConversationToolView.m
//  RedPacketApp
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ConversationToolView.h"
#import "AddRedPacketView.h"
#import "XYTextFiled.h"
#import "RecordVoiceView.h"

const static CGFloat width = 40;

@interface ConversationToolView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *voiceButton;//说话录音按钮
@property (nonatomic, strong) XYTextFiled *inputFiled;//输入框
@property (nonatomic, strong) UIButton *faceButton;//表情按钮
@property (nonatomic, strong) UIButton *addButton;//增加按钮
@property (nonatomic, strong) AddRedPacketView *packetView;
@property (nonatomic, strong) RecordVoiceView *voiceView;//录音视图

@end

@implementation ConversationToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //约束UI
        [self layoutView];
        //监听键盘高度的改变 键盘将要出现或者高度即将改变的时候
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHeightWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        //监听键盘将要隐藏的时候
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}
/**
 录音视图
 */
- (RecordVoiceView *)voiceView{
    if(!_voiceView){
        _voiceView = [[RecordVoiceView alloc] init];
        _voiceView.hidden = YES;
        [self addSubview:_voiceView];
        [_voiceView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_voiceButton.right).offset(15*m6Scale);
            make.size.equalTo(CGSizeMake(kScreenWidth*0.6, width));
            make.top.equalTo(_voiceButton.top);
        }];
    }
    return _voiceView;
}
-(void)setConversation:(EMConversation *)conversation{
    self.voiceView.conversation = conversation;
    self.packetView.conversation = conversation;
}
/**
 约束UI
 */
- (void)layoutView{
    self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:0.5];
    //说话录音按钮
    _voiceButton = [UIButton buttonWithType:0];
    [_voiceButton setImage:[UIImage imageNamed:@"chatBar_record@2x"] forState:0];
    [_voiceButton addTarget:self action:@selector(voiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceButton];
    [_voiceButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(30*m6Scale);
        make.size.equalTo(CGSizeMake(width, width));
        make.top.equalTo((self.frame.size.height-width)/2);
    }];
    //聊天输入框
    _inputFiled = [[XYTextFiled alloc] init];
    _inputFiled.placeholder = @"请输入消息";
    _inputFiled.layer.borderWidth = 1;
    _inputFiled.delegate = self;
    _inputFiled.returnKeyType = UIReturnKeySend;
    _inputFiled.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.3].CGColor;
    [self addSubview:_inputFiled];
    [_inputFiled makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_voiceButton.right).offset(15*m6Scale);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.6, width));
        make.top.equalTo(_voiceButton.top);
    }];
    //表情按钮
    _faceButton = [UIButton buttonWithType:0];
    [_faceButton setImage:[UIImage imageNamed:@"chatBar_face@2x"] forState:0];
    [self addSubview:_faceButton];
    [_faceButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputFiled.right).offset(15*m6Scale);
        make.size.equalTo(CGSizeMake(width, width));
        make.top.equalTo(_voiceButton.top);
    }];
    //添加按钮
    _addButton = [UIButton buttonWithType:0];
    [_addButton setImage:[UIImage imageNamed:@"chatBar_more@2x"] forState:0];
    [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
    [_addButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_faceButton.right).offset(5*m6Scale);
        make.size.equalTo(CGSizeMake(width, width));
        make.top.equalTo(_voiceButton.top);
    }];
}
/**
 添加红包 位置等按钮的View
 */
- (AddRedPacketView *)packetView{
    if(!_packetView){
        _packetView = [[AddRedPacketView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 200*m6Scale)];

        [self addSubview:_packetView];
    }
    return _packetView;
}
/**
 键盘将要出现或者高度即将改变的时候
 */
- (void)keyBoardHeightWillChange:(NSNotification *)noti{
    _faceButton.selected = YES;
    NSDictionary *info = [noti userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    self.packetView.hidden = YES;
    _keyBoardHeight(keyboardSize.height+60, duration);
}
/**
 监听键盘将要隐藏的时候
 */
- (void)keyBoardWillDisAppear:(NSNotification *)noti{
    _keyBoardHeight(60, 0.2);
}
/**
 发送消息
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![Factory theidTypeIsNull:textField.text]) {
        _sendMessage(textField);
    }
    
    return YES;
}
/**
 添加按钮的点击事件
 */
- (void)addButtonClick{
    _faceButton.selected = !_faceButton.selected;
    [_inputFiled resignFirstResponder];
    if (_faceButton.selected) {
        self.packetView.hidden = NO;
        _keyBoardHeight(200*m6Scale+60, 0.2);
    }else{
        self.packetView.hidden = YES;
        _keyBoardHeight(60, 0.2);
    }
}
/**
 录音按钮的点击事件
 */
- (void)voiceButtonClick{
    self.voiceButton.selected = !self.voiceButton.selected;
    if (self.voiceButton.selected) {
        //键盘失去第一响应者 隐藏键盘
        [_voiceButton setImage:[UIImage imageNamed:@"chatBar_keyboard@2x"] forState:UIControlStateNormal];
        [self.inputFiled resignFirstResponder];
        self.inputFiled.hidden = YES;
        self.voiceView.hidden = NO;
    }else{
        //键盘成为第一响应者 显示键盘
        [_voiceButton setImage:[UIImage imageNamed:@"chatBar_record@2x"] forState:UIControlStateNormal];
        [self.inputFiled becomeFirstResponder];
        self.inputFiled.hidden = NO;
        self.voiceView.hidden = YES;
    }
    
}
- (void)setType:(EMConversationType)type{
    if (type == EMConversationTypeGroupChat) {
        _inputFiled.userInteractionEnabled = NO;
        _voiceButton.userInteractionEnabled = NO;
        _faceButton.userInteractionEnabled = NO;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
