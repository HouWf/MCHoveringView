//
//  ViewController.m
//  MCHoveringView
//
//  Created by qinmuqiao on 2019/3/25.
//  Copyright © 2019年 MuYaQin. All rights reserved.
//

#import "ViewController.h"
#import "MCHoveringView.h"
#import "Demo1ViewController.h"
#import "Demo2ViewController.h"
#import "Demo3ViewController.h"
#import "MJRefresh.h"
@interface ViewController ()<MCHoveringListViewDelegate>
@property (nonatomic , strong) Demo1ViewController * demo1;
@property (nonatomic , strong) Demo2ViewController * demo2;
@property (nonatomic , strong) Demo3ViewController * demo3;
@property (nonatomic , strong) MCHoveringView * hoveringView;
@property (nonatomic , strong) UIView * headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo";
    
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.demo1 = [Demo1ViewController new];
    self.demo2 = [Demo2ViewController new];
    self.demo3 = [Demo3ViewController new];

    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.headerView.backgroundColor = [UIColor redColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:UIColor.orangeColor];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:button];
    
    //具体的MCPageView、QQTableView 参见 github:https://github.com/MuYanQin 勿喷！！！
    
    MCHoveringView *hovering = [[MCHoveringView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.safeAreaLayoutGuide.layoutFrame.size.height) deleaget:self];
    hovering.isMidRefresh = YES;
    [self.view addSubview:hovering];
    //设置搜索 、认证、我的的字体颜色。
    hovering.pageView.defaultTitleColor = [UIColor blackColor];
    hovering.pageView.selectTitleColor = [UIColor redColor];
    
    //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
    hovering.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [hovering.scrollView.mj_header endRefreshing];
    }];
}

- (void)buttonClick{
    NSLog(@"buttonClick");
}
- (NSArray *)listView
{
    return @[self.demo1.tableView,self.demo2.tableView,self.demo3.tableView];
}
- (UIView *)headView
{
    return self.headerView;
}
- (NSArray<UIViewController *> *)listCtroller
{
    return @[self.demo1,self.demo2,self.demo3];
}
- (NSArray<NSString *> *)listTitle
{
    return @[@"搜索",@"认证",@"我的"];
}

@end
