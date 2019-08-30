//
//  DYViewController.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/28.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "DYViewController.h"
#import "GKPageScrollView.h"
#import "DYHeaderView.h"
#import "WBPageViewController.h"
#import "WBListTableViewController.h"
#import "UILabel+Category.h"

@interface DYViewController ()<GKPageScrollViewDelegate, WMPageControllerDelegate, WMPageControllerDataSource, WBPageViewControllerScrollDelegate, UIScrollViewDelegate>

// 最底层
@property (nonatomic, strong) GKPageScrollView *pageScrollView;
// 顶部
@property (nonatomic, strong) DYHeaderView *headerView;
// 分页控制器
@property (nonatomic, strong) WBPageViewController *pageVC;
// 承接分页视图
@property (nonatomic, strong) UIView *pageView;

// 分页控制器标题数组
@property (nonatomic, strong) NSArray *titles;
// 分页控制器子控制器数组
@property (nonatomic, strong) NSArray *childVCs;

// 导航顶部titleView
@property (nonatomic, strong) UILabel *titleView;
@end

@implementation DYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = RGBA(34, 33, 37, 1);
    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageScrollView reloadData];
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.headerView;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.pageView;
}

- (NSArray <id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.childVCs;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = 0;
    if (offsetY < 200) {
        alpha = 0;
    }
    else if (offsetY > (kDYHeaderHeight - k_Height_NavBar)){
        alpha = 1;
    }
    else{
        alpha = (offsetY - 200) / (kDYHeaderHeight - k_Height_NavBar - 200);
    }
    self.gk_navBarAlpha = alpha;
    self.titleView.alpha = alpha;
    // 缩放
    [self.headerView scrollViewDidScroll:offsetY];
}

#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.childVCs.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.childVCs[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kScreenW, 40.0f);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat maxY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:pageController.menuView]);
    return CGRectMake(0, maxY, kScreenW, kScreenH - maxY - kNavBarHeight);
}

#pragma mark - WMPageControllerDelegate
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    NSLog(@"加载数据");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

#pragma mark - lazy
- (GKPageScrollView *)pageScrollView{
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.mainTableView.backgroundColor = UIColor.lightGrayColor;
    }
    return _pageScrollView;
}

- (DYHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DYHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, kDYHeaderHeight)];
    }
    return _headerView;
}

- (WBPageViewController *)pageVC{
    if (!_pageVC) {
        _pageVC = [[WBPageViewController alloc] init];
        _pageVC.delegate = self;
        _pageVC.dataSource = self;
        _pageVC.scrollDelegate = self;
        _pageVC.menuItemWidth = Main_Screen_Width / 4.f - 20;
        _pageVC.menuViewStyle = WMMenuViewStyleLine;
        _pageVC.titleSizeNormal = 16.f;
        _pageVC.titleSizeSelected = 16.f;
        _pageVC.titleColorNormal = UIColor.grayColor;
        _pageVC.titleColorSelected = UIColor.blackColor;
        _pageVC.progressColor = RGBA(250, 69, 6, 1);
        _pageVC.progressWidth = 30.f;
        _pageVC.progressHeight = 3.f;
        _pageVC.progressViewBottomSpace = 2.f;
        _pageVC.progressViewCornerRadius = _pageVC.progressHeight / 2;
        _pageVC.progressViewIsNaughty = YES;
    }
    return _pageVC;
}

- (UIView *)pageView {
    if (!_pageView) {
        [self addChildViewController:self.pageVC];
        [self.pageVC didMoveToParentViewController:self];
        _pageView = self.pageVC.view;
    }
    return _pageView;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"主页", @"微博", @"视频", @"故事"];
    }
    return _titles;
}

- (NSArray *)childVCs{
    if (!_childVCs) {
        WBListTableViewController *homeCtr = [[WBListTableViewController alloc] init];
        WBListTableViewController *wbCtr = [[WBListTableViewController alloc] init];
        WBListTableViewController *videoCtr = [[WBListTableViewController alloc] init];
        WBListTableViewController *storyCtr = [[WBListTableViewController alloc] init];
        _childVCs = @[homeCtr, wbCtr, videoCtr, storyCtr];
    }
    return _childVCs;
}

- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [UILabel labelWithSize:[UIFont systemFontOfSize:18.f]
                                   textColor:UIColor.whiteColor
                               textAlignment:NSTextAlignmentCenter];
        _titleView.frame = CGRectMake(0, 0, 160, 44);
        _titleView.text = @"❤️会说话的刘二豆❤️";
        _titleView.alpha = 0;
    }
    return _titleView;
}

@end
