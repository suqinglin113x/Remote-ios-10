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
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor brownColor];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 50);
    _scrollView.contentInset = UIEdgeInsetsMake(0, 50, 00, 0);
//    _scrollView.bounces = NO;
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//    _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [_scrollView flashScrollIndicators];
    _scrollView.directionalLockEnabled = YES; //很有用
    
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(10, 100, 150, 30);
    button.backgroundColor = [UIColor colorWithDisplayP3Red:0.4 green:0.3 blue:0.5 alpha:1];
    [button setTitle:@"我是iOS10label" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpToSystemSetting) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
    
    //添加刷新
    UIRefreshControl * _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor redColor];
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [_scrollView addSubview:_refreshControl];
    
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    NSLog(@"开始刷新！");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [refresh endRefreshing];
        NSLog(@"结束刷新！");
        
    });
}



- (void)jumpToSystemSetting
{
    NSLog(@"跳转到设置！");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}
@end
