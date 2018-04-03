//
//  TwoViewController.m
//  自定义tabbar
//
//  Created by Mr.X on 2016/12/14.
//  Copyright © 2016年 Mr.X. All rights reserved.
//

#import "FriendsVC.h"
#import "ConversationDetailsVC.h"
#import "GroupListVC.h"

@interface FriendsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    //获取好友列表
    [self getFriendListFromServer];
}
/**
 tableView的懒加载
 */
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, kScreenWidth, kScreenHeight-kTabBarHeight-NavigationBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
/**
 好友数据列表
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma  UITableViewDataSource---numberOfSectionsInTableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma  UITableViewDataSource---numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.dataSource.count;
}
#pragma UITableViewDataSource---cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        NSString *reuse = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        cell.selectionStyle = NO;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
        
        return cell;
    }else{
        NSString *reuse = @"GroupTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        cell.selectionStyle = NO;
        cell.textLabel.text = @"群组";
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*m6Scale;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        //会话聊天页面
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:[NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]] type:EMConversationTypeChat createIfNotExist:YES];
        ConversationDetailsVC *tempVC = [[ConversationDetailsVC alloc] init];
        tempVC.conversation = conversation;
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        //群组列表页面
        GroupListVC *tempVC = [[GroupListVC alloc] init];
        
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
/**
 获取好友列表
 */
- (void)getFriendListFromServer{
    //首先从服务器获取好友列表
    EMError *error = nil;
    self.dataSource = [NSMutableArray arrayWithArray:[[EMClient sharedClient].contactManager getContactsFromServerWithError:&error]];
    if (error) {
        //假如没有从服务器获取数据  则从本地读取
        self.dataSource = [NSMutableArray arrayWithArray:[[EMClient sharedClient].contactManager getContacts]];
    }
}
@end
