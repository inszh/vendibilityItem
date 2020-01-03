//
//  FLQViewController.m
//  RMCalendar
//
//  Created by ark on 2019/12/12.
//  Copyright © 2019 迟浩东. All rights reserved.
//

#import "FLQViewController.h"
#import "FLQCell.h"
#import "UITableViewCell+ACExtension.h"

@interface FLQViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation FLQViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView
{
    self.title=@"可购买产品";
    UITableView *tableView=[UITableView new];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.frame=self.view.bounds;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    
    tableView.rowHeight =  UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLQCell *cell=[FLQCell cellWithTableView:tableView];
    cell.ettModel=self.dataSouce[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSouce.count;
}


@end
