//
//  HeaderService.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "HeaderService.h"
#import "SDCycleScrollView.h"
#import "TopTableViewCell.h"
#import "OtherTableViewCell.h"
#import "YBImageBrowser.h"

static NSString * top_cell_identifier = @"top_cell_identifier";
static NSString * other_cell_identifier = @"other_cell_identifier";

@interface HeaderService ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *main_tablView;

@property (nonatomic, strong) SDCycleScrollView *headerScrollView;

@property (nonatomic, strong) UIView *table_headerView;

@property (nonatomic, strong) NSArray *pictureUrls;

@end

@implementation HeaderService
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;

        self.pictureUrls = @[
                             @"http://img1.imgtn.bdimg.com/it/u=3893146502,314297687&fm=26&gp=0.jpg",
                             @"http://img5.imgtn.bdimg.com/it/u=1007455858,950215249&fm=26&gp=0.jpg",
                             @"http://img0.imgtn.bdimg.com/it/u=3649495861,4269548325&fm=26&gp=0.jpg"
                             ];
        [self addSubview:self.headerScrollView];
        [self addSubview:self.main_tablView];
        self.headerScrollView.imageURLStringsGroup = self.pictureUrls;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point
                        withEvent:event];
    if (view == nil || view == self.table_headerView) {
        return [self.headerScrollView hitTest:point withEvent:event];
    }
    else{
        return view;
    }
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSMutableArray *browserDataArr = [NSMutableArray array];
    [self.pictureUrls enumerateObjectsUsingBlock:^(NSString *_Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:urlStr];
        data.projectiveView = self.headerScrollView;
        [browserDataArr addObject:data];
    }];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    browser.currentPage = index;
    [browser show];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TopTableViewCell *cell = [TopTableViewCell tableView:tableView identifier:top_cell_identifier];
        return cell;
    }
    else{
        OtherTableViewCell *cell = [OtherTableViewCell tableView:tableView identifier:other_cell_identifier];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    return 50;
}

#pragma mark - lazy
- (UITableView *)main_tablView{
    if (!_main_tablView) {
        _main_tablView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64) style:UITableViewStylePlain];
        _main_tablView.delegate = self;
        _main_tablView.dataSource = self;
        _main_tablView.tableFooterView = [UIView new];
        _main_tablView.backgroundColor = UIColor.clearColor;
        _main_tablView.showsVerticalScrollIndicator = NO;
        _main_tablView.scrollsToTop = YES;
        _main_tablView.tableHeaderView = self.table_headerView;
    }
    return _main_tablView;
}

- (UIView *)table_headerView{
    if (!_table_headerView) {
        _table_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width * 0.5 - 10)];
        _table_headerView.backgroundColor = UIColor.clearColor;
    }
    return _table_headerView;
}

- (SDCycleScrollView *)headerScrollView{
    if (!_headerScrollView) {
        _headerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width * 0.5) delegate:self placeholderImage:nil];
        _headerScrollView.pageControlBottomOffset = 16;
        _headerScrollView.currentPageDotColor = [UIColor.whiteColor colorWithAlphaComponent:1];
        _headerScrollView.pageDotColor = [UIColor.whiteColor colorWithAlphaComponent:.5];
        _headerScrollView.autoScrollTimeInterval = 4;
        _headerScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerScrollView;
}

@end
