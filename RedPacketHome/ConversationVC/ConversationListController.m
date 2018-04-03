//
//  ConversationListController.m
//  自定义tabbar
//
//  Created by Mr.X on 2016/12/14.
//  Copyright © 2016年 Mr.X. All rights reserved.
//

#import "ConversationListController.h"
#import "ConversationCell.h"
#import "ConversationDetailsVC.h"

@interface ConversationListController ()<UITableViewDelegate, UITableViewDataSource,EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *unReadArray;//未读消息数量数组

@end

@implementation ConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"连接中..." color:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    //登录环信
    [[EMClient sharedClient] loginWithUsername:@"15738962856" password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"聊天" color:[UIColor whiteColor]];
        //获取最新消息
        [self refreshConversationList];
    }];
    //添加环信消息的监听
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}
/**
 tableView的懒加载
 */
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, kScreenWidth, kScreenHeight-NavigationBarHeight-kTabBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = backGroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
/**
 未读消息数量数组
 */
- (NSMutableArray *)unReadArray{
    if(!_unReadArray){
        _unReadArray = [NSMutableArray array];
    }
    return _unReadArray;
}
#pragma  UITableViewDataSource---numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
#pragma UITableViewDataSource---cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseString = @"ConversationCell";
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseString];
    if (!cell) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseString];
    }
    cell.selectionStyle = NO;
    EMConversation *conversation = self.dataSource[indexPath.row];
    cell.conversation = conversation;
    cell.unReadMessageCount = self.unReadArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150*m6Scale;
}
/**
 didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转会话详情页
    ConversationDetailsVC *tempVC = [[ConversationDetailsVC alloc] init];
    tempVC.conversation = self.dataSource[indexPath.row];
    [tempVC setRefreshList:^{
        //获取最新消息
        [self refreshConversationList];
    }];
    [tempVC setAllMessageRead:^{
        //将某会话所有消息设为已读
        [self markAllMessageAsRead:self.dataSource[indexPath.row] indexPath:indexPath];
    }];
    [self.navigationController pushViewController:tempVC animated:YES];
    //将某会话所有消息设为已读
    [self markAllMessageAsRead:self.dataSource[indexPath.row] indexPath:indexPath];
}
/**
 EMChatManagerDelegate  接收到一条及以上非cmd消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages{
    //获取最新消息
    [self refreshConversationList];
    //消息提示音
    [Factory reciveMessageAlterVoice];
}
/**
 EMChatManagerDelegate  接收到一条及以上cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
    NSLog(@"%@", aCmdMessages);
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //获取最新的消息
    [self refreshConversationList];
    //监听 从通讯录中 点击触发的会话消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshConversationList) name:@"RefreshConversationList" object:nil];
}
/**
 获取最新消息
 */
- (void)refreshConversationList{
    [self.dataSource removeAllObjects];
    //获取所有的会话列表
    self.dataSource = [NSMutableArray arrayWithArray:[[EMClient sharedClient].chatManager getAllConversations]];
    //冒泡排序
    [ChatViewHelper bubbleSortWithDataSource:self.dataSource unReadArray:self.unReadArray];
    
    [self.tableView reloadData];
}
/**
 将某会话所有消息设为已读
 */
- (void)markAllMessageAsRead:(EMConversation *)conversation indexPath:(NSIndexPath *)indexPath{
    EMError *error = nil;
    [conversation markAllMessagesAsRead:&error];
    if ([Factory theidTypeIsNull:error]) {
        [self.unReadArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%d", 0]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
