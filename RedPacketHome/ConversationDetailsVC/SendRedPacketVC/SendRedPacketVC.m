//
//  SendRedPacketVC.m
//  RedPacketApp
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SendRedPacketVC.h"
#import "SendRedPacketCell.h"

@interface SendRedPacketVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *textArray;

@end

@implementation SendRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"发红包";
    self.textArray = @[@"红包个数", @"台面金额", @"是否翻倍", @"发包金额"];
    [self.view addSubview:self.tableView];
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
        _tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏掉tableView的所有分割线
    }
    
    return _tableView;
}
#pragma  UITableViewDataSource---numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.textArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150*m6Scale;
}
#pragma UITableViewDataSource---cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"SendRedPacketCell";
    SendRedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[SendRedPacketCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    //cell.text = self.textArray[indexPath.section];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [ChatViewHelper returnFooterViewWithSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < 2) {
        return 30*m6Scale;
    }else{
        return 0.01;
    }
}

@end
