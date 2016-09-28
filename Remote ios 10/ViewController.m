//
//  ViewController.m
//  Remote ios 10
//
//  Created by SU on 16/9/22.
//  Copyright © 2016年 SU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  

    
    
    
    //创建UI
    [self createUI];
}


- (void)createUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor brownColor];
    _scrollView.contentSize = CGSizeMake(300, 2000);
    
    _scrollView.refreshControl = [[UIRefreshControl alloc] init];
    [_scrollView.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"]];
    [_scrollView.refreshControl beginRefreshing];
    _scrollView.refreshControl.tintColor = [UIColor redColor];
    
//    [self.view addSubview:_scrollView];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 100, 100, 30);
    label.adjustsFontForContentSizeCategory = YES;
    label.backgroundColor = [UIColor colorWithDisplayP3Red:0.4 green:0.3 blue:0.5 alpha:1];
    label.text = @"我是iOS10label";
    [_scrollView addSubview:label];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    [self.view addSubview:_tableView];
    
    //添加刷新
    UIRefreshControl * _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor redColor];
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [_tableView addSubview:_refreshControl];
    
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    NSLog(@"ffffff");
    [refresh endRefreshing];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"已点击");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

@end
