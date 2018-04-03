//
//  ConversationDetailsVC.m
//  RedPacketApp
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ConversationDetailsVC.h"
#import "ChatTimeCell.h"
#import "ChatMessageCell.h"
#import "ConversationToolView.h"
#import "GroupInfomationVC.h"
#import "WSRedPacketView.h"

const static CGFloat toolBarHeight = 60;

@interface ConversationDetailsVC ()<UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
//刷新tableView列表的数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//上拉刷新的时候加载的页数
@property (nonatomic, assign) int page;
//进入聊天页面首次请求的数据条数 假如接收或发送消息 也需要获取消息 增加numbers
@property (nonatomic, assign) int numbers;
//在同一个conversationId聊天中 接受或发送的消息 放到一个数组中 数组中只存放最新的消息
@property (nonatomic, strong) NSMutableArray *newerMessages;
//聊天框
@property (nonatomic, strong) ConversationToolView *toolView;

@end

@implementation ConversationDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    //默认值
    _page = 20;
    _numbers = 10;
    [self.view addSubview:self.tableView];
    //添加返回按钮和群聊单聊设置按钮
    [self addBackButtonAndSetButton];
    //会话标题
    [self getConversationTitle];
    //从服务器获取历史消息
    [self getHistoryMessageFromServer];
    //添加环信消息的监听
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [self.view addSubview:self.toolView];
}
/**
 tableView的懒加载
 */
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, kScreenWidth, kScreenHeight-NavigationBarHeight-toolBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = backGroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏掉tableView的所有分割线
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownGetHistoryConversation)];
    }
    
    return _tableView;
}
/**
 在同一个conversationId聊天中 接受或发送的消息 放到一个数组中 数组中只存放最新的消息
 */
- (NSMutableArray *)newerMessages{
    if(!_newerMessages){
        _newerMessages = [NSMutableArray array];
    }
    return _newerMessages;
}
/**
 聊天框
 */
- (ConversationToolView *)toolView{
    if(!_toolView){
        _toolView = [[ConversationToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight-toolBarHeight-KSafeBarHeight, kScreenWidth, toolBarHeight)];
        _toolView.type = self.conversation.type;
        
        _toolView.conversation = self.conversation;
        NSLog(@"%@  %@", _toolView.conversation.conversationId, self.conversation.conversationId);
        WeakSelf(weakSelf);
        //根据键盘的高度 动态改变tableView和toolView的位置
        [_toolView setKeyBoardHeight:^(CGFloat height, CGFloat animationTime) {
            [UIView animateWithDuration:animationTime animations:^{
                weakSelf.tableView.frame = CGRectMake(0, NavigationBarHeight, kScreenWidth, kScreenHeight-NavigationBarHeight-height);
                NSInteger section = 0;
                if (weakSelf.dataSource.count) {
                    section = self.dataSource.count-1;
                    //滑到最后一行
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
                weakSelf.toolView.frame = CGRectMake(0, kScreenHeight-height, kScreenWidth, height);
            }];
        }];
        //发送消息
        [_toolView setSendMessage:^(UITextField *textFiled) {
            //环信 插入消息
            EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textFiled.text];
            NSString *from = [[EMClient sharedClient] currentUsername];
            NSLog(@"%@   %@", from, weakSelf.conversation.conversationId);
            //生成Message
            EMMessage *message = [[EMMessage alloc] initWithConversationID:weakSelf.conversation.conversationId from:from to:weakSelf.conversation.conversationId body:body ext:nil];
            message.chatType = weakSelf.conversation.latestMessage.chatType;
            [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                if ([Factory theidTypeIsNull:error]) {
                    //监听消息接受
                    [weakSelf messagesDidReceive:@[message]];
                    if (weakSelf.refreshList) {
                        //会话聊天页面用block刷新新数据
                        weakSelf.refreshList();
                    }else{
                        //从通讯录中 点击触发的会话消息 用通知处理
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshConversationList" object:nil];
                    }
                    textFiled.text = @"";
                }
            }];
        }];
    }
    return _toolView;
}
#pragma  UITableViewDataSource---numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
#pragma UITableViewDataSource---cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //EMMessage 消息对象
    EMMessage *message = self.dataSource[indexPath.section];
    if (indexPath.row == 0) {
        //时间标签
        ChatTimeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatTimeCell"];
        if (!cell) {
            cell = [[ChatTimeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ChatTimeCell"];
        }
        NSString *lastTime = @"";
        NSString *topTime = @"";
        if (indexPath.section != 0) {
            //EMMessage 消息对象
            EMMessage *lastMessage = self.dataSource[indexPath.section];
            EMMessage *topMessage = self.dataSource[indexPath.section-1];
            lastTime = [NSString stringWithFormat:@"%lld", lastMessage.timestamp];
            topTime = [NSString stringWithFormat:@"%lld", topMessage.timestamp];
        }
        cell.messageTime = [Factory compareTimeDifferenceBetweenLastTime:lastTime andTopTime:topTime];
        
        return cell;
    }else{
        //消息内容
        ChatMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatMessageCell"];
        if (!cell) {
            cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ChatMessageCell"];
        }
        cell.message = message;
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        EMMessage *mssage = self.dataSource[indexPath.section];
        
        return [ChatViewHelper heightForMessageContentCellWithMessage:mssage];
    }else{
        NSString *lastTime = @"";
        NSString *topTime = @"";
        if (indexPath.section != 0) {
            //EMMessage 消息对象
            EMMessage *lastMessage = self.dataSource[indexPath.section];
            EMMessage *topMessage = self.dataSource[indexPath.section-1];
            lastTime = [NSString stringWithFormat:@"%lld", lastMessage.timestamp];
            topTime = [NSString stringWithFormat:@"%lld", topMessage.timestamp];
        }
        return [Factory theidTypeIsNull:[Factory compareTimeDifferenceBetweenLastTime:lastTime andTopTime:topTime]] ? 0.01 : 40*m6Scale;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMMessage *message = self.dataSource[indexPath.section];
    if (message.body.type == EMMessageBodyTypeVoice) {
        //语音类消息
        [PlayVoiceImgView playVoiceMessage:message];
    }else if (message.body.type == EMMessageBodyTypeText){
        //文字消息的点击
        NSDictionary *diction = message.ext;
        if ([diction[@"type"] isEqualToString:@"sendRedPacket"]) {
            WSRewardConfig *info = ({
                WSRewardConfig *info   = [[WSRewardConfig alloc] init];
                info.money         = 10000.0;
                info.avatarImage    = [UIImage imageNamed:@"avatar"];
                info.content = @"恭喜发财，大吉大利";
                info.userName  = @"小雨同学";
                info;
            });
            
            
            [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
                NSLog(@"取消领取");
            } finishBlock:^(float money) {
                NSLog(@"领取金额：%f",money);
            }];
        }
    }
}
/**
 从服务器获取最新消息
 */
- (void)getHistoryMessageFromServer{
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //异步执行耗时操作
    dispatch_async(queue, ^{
        EMCursorResult *result = [EMClient.sharedClient.chatManager fetchHistoryMessagesFromServer:self.conversation.conversationId conversationType:self.conversation.type startMessageId:@"0" pageSize:_numbers error:nil];
        self.dataSource = [NSMutableArray arrayWithArray:result.list];
        //回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主队列刷新UI %ld", self.dataSource.count);
            if (self.dataSource.count) {
                _numbers = (int)(_numbers+self.newerMessages.count);
                [self.tableView reloadData];
                NSInteger section = 0;
                if (self.dataSource.count) {
                    section = self.dataSource.count-1;
                    //滑到最后一行
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }
            _page = _numbers+10;
        });
    });
}
/**
 下拉刷新获取历史会话
 */
- (void)pullDownGetHistoryConversation{
    [EMClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:self.conversation.conversationId conversationType:self.conversation.type startMessageId:@"0" pageSize:_page completion:^(EMCursorResult *aResult, EMError *aError) {
        if (self.dataSource.count != aResult.list.count) {
            //准确找到刷新的位置
            NSInteger section = aResult.list.count-self.dataSource.count;
            self.dataSource = [NSMutableArray arrayWithArray:aResult.list];
            _numbers = (int)self.dataSource.count;
            [self.tableView reloadData];
            //刷新完成 并让tableView滑到指定位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            _page = _page + 10;
        }
        
        [_tableView.mj_header endRefreshing];
    }];
}
/**
 会话标题
 */
- (void)getConversationTitle{
    //单聊
    if (self.conversation.type == EMConversationTypeChat) {
        self.title = self.conversation.conversationId;
    }else if (self.conversation.type == EMConversationTypeGroupChat){
        [EMClient.sharedClient.groupManager getGroupSpecificationFromServerWithId:self.conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
            if ([Factory theidTypeIsNull:aGroup.subject]) {
                //会话标题或对象昵称
                self.title = self.conversation.conversationId;
            }else{
                //会话标题或对象昵称
                self.title = aGroup.subject;
            }
        }];
    }
}
/**
 视图已经出现
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
/**
 EMChatManagerDelegate  接收到一条及以上非cmd消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages{
    [self.newerMessages removeAllObjects];
    for (EMMessage *message in aMessages) {
        //收到同一个会话的消息
        if ([message.conversationId isEqualToString:self.conversation.conversationId]) {
            [self.newerMessages addObject:message];
            [self.dataSource addObject:message];
        }
    }
    //插入消息
    [[EMClient sharedClient].chatManager importMessages:self.newerMessages completion:^(EMError *aError) {
        if ([Factory theidTypeIsNull:aError]) {
            //插入成功 调用消息查询接口 刷新UI
            //[self getHistoryMessageFromServer];
            [self.tableView reloadData];
            NSInteger section = 0;
            if (self.dataSource.count) {
                section = self.dataSource.count-1;
                //滑到最后一行
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        
    }];
}
- (void)didReceiveMessage:(NSArray *)messages{
    [self messagesDidReceive:messages];
}
/**
 添加返回按钮和群聊单聊设置按钮
 */
- (void)addBackButtonAndSetButton{
    //返回按钮
    UIButton *backButton = [Factory addLeftbottonToVC:self];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        //群组设置按钮
        UIButton *groupButton = [Factory addRightbottonToVC:self andrightStr:@"群组设置"];
        [groupButton addTarget:self action:@selector(groupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
/**
 群组设置按钮
 */
- (void)groupButtonClick{
    //群组设置页面
    GroupInfomationVC *tempVC = [[GroupInfomationVC alloc] init];
    
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 返回按钮的点击事件
 */
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    if (_allMessageRead) {
        _allMessageRead();
    }
}
/**
 EMChatManagerDelegate  接收到一条及以上cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
    NSLog(@"%@", aCmdMessages);
}

@end
