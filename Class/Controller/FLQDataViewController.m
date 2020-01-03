//
//  FLQDataViewController.m
//  RMCalendar
//
//  Created by ark on 2020/1/1.
//  Copyright © 2020 迟浩东. All rights reserved.
//

#import "FLQDataViewController.h"
#import "FLQCell.h"
#import "UITableViewCell+ACExtension.h"
#import "FLQdatas.h"
#import "MJExtension.h"
#import "EttlementModel.h"
#import "EditDataViewController.h"
#import "UIButton+SYExtension.h"

@interface FLQDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation FLQDataViewController

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
    
    
    self.dataSouce=[EttlementModel objectArrayWithKeyValuesArray:[FLQdatas formatDats]];

    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"添加数据" forState:0];
    [backButton setTitleColor:[UIColor blackColor] forState:0];
    backButton.frame=CGRectMake(0, 0, 44, 44);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [backButton addTargetBlock:^(NSInteger tag) {
        EditDataViewController *ed=EditDataViewController.new;
        [self.navigationController pushViewController:ed animated:YES];
    }];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditDataViewController *ed=EditDataViewController.new;
    ed.dataModel=self.dataSouce[indexPath.row];
    [self.navigationController pushViewController:ed animated:YES];

    
}

@end
