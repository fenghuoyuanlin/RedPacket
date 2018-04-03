//
//  GroupListVC.m
//  RedPacketApp
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupListVC.h"
#import "ConversationDetailsVC.h"

@interface GroupListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation GroupListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群聊";
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    //获取群组会话列表
    [self getGroupList];
}
/**
 tableView的懒加载
 */
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, kScreenWidth, kScreenHeight-NavigationBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
#pragma  UITableViewDataSource---numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
#pragma UITableViewDataSource---cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuse = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.selectionStyle = NO;
    EMGroup *group = self.dataSource[indexPath.row];
    cell.textLabel.text = group.subject;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*m6Scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMGroup *group = self.dataSource[indexPath.row];
    //全局队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        //会话聊天页面
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:[NSString stringWithFormat:@"%@", group.groupId] type:EMConversationTypeGroupChat createIfNotExist:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            ConversationDetailsVC *tempVC = [[ConversationDetailsVC alloc] init];
            tempVC.conversation = conversation;
            [self.navigationController pushViewController:tempVC animated:YES];
        });
    });
    
    
}
/**
 获取群组会话列表
 */
- (void)getGroupList{
    EMError *aError = nil;
    self.dataSource = [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:1 pageSize:10 error:&aError];
}

@end
