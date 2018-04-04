//
//  MyCenterVC.m
//  RedPacketApp
//
//  Created by apple on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyCenterVC.h"
// Controllers

// Models
#import "MyCenterModel.h"
// Views
#import "LYMyCenterCell.h"
#import "LYHeaderCell.h"
// Vendors
#import <MJExtension.h>
// Categories

// Others

@interface MyCenterVC ()<UITableViewDelegate, UITableViewDataSource>
//tableView
@property(nonatomic, strong) UITableView *tableView;
//模型数组
@property(nonatomic, strong) NSMutableArray<MyCenterModel *> *centerModelArr;

@end

static NSString *const LYMyCenterCellID = @"LYMyCenterCell";
static NSString *const LYHeaderCellID = @"LYHeaderCell";

@implementation MyCenterVC

#pragma mark - lazyLoad
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, DCMargin, ScreenW, ScreenH - 120 - 60 - 49);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //修饰轮廓
        //        _tableView.layer.cornerRadius = 8.0;
        //        _tableView.layer.masksToBounds = YES;
        [self.view addSubview:_tableView];
        
        //注册
        [_tableView registerClass:[LYHeaderCell class] forCellReuseIdentifier:LYHeaderCellID];
        [_tableView registerClass:[LYMyCenterCell class] forCellReuseIdentifier:LYMyCenterCellID];
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
}

#pragma mark - initial
-(void)setUpBase
{
    self.view.backgroundColor = DCBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //个人中心
    self.title = @"个人中心";
    self.tableView.backgroundColor = DCBGColor;
    
    [self setUpNav];
}

#pragma mark - 设置导航栏
-(void)setUpNav
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"设置"] forState:0];
    button.frame = CGRectMake(0, 0, 28, 28);
    [button addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 消息数据
-(void)setUpData
{
//    _messageArr = [LYMyselfItem mj_objectArrayWithFilename:@"MyselfNote.plist"];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 2) ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *gridCell;
    if (indexPath.section == 0)
    {
        LYHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:LYHeaderCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        gridCell = cell;
    }
    else
    {
        LYMyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:LYMyCenterCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1)
        {
            cell.centerModel = _centerModelArr[indexPath.row];
        }
        else if (indexPath.section == 2)
        {
            cell.centerModel = _centerModelArr[indexPath.row + 1];
        }
        else if (indexPath.section == 3)
        {
            cell.centerModel = _centerModelArr[indexPath.row + 3];
        }
        gridCell = cell;
        
    }
    
    
    return gridCell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    footerView.backgroundColor = DCBGColor;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
