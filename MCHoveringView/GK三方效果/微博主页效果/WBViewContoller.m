//
//  GKWBViewContoller.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "WBViewContoller.h"
#import "GKPageScrollView.h"
#import "WBHeaderView.h"
#import "WBPageViewController.h"
#import "WBListTableViewController.h"
#import "UILabel+Category.h"

@interface WBViewContoller ()<GKPageScrollViewDelegate, WMPageControllerDelegate, WMPageControllerDataSource, WBPageViewControllerScrollDelegate>
// 最底层
@property (nonatomic, strong) GKPageScrollView *pageScrollView;
// 顶部
@property (nonatomic, strong) WBHeaderView *headerView;
// 分页控制器
@property (nonatomic, strong) WBPageViewController *pageVC;
// 承接分页视图
@property (nonatomic, strong) UIView *pageView;

// 分页控制器标题数组
@property (nonatomic, strong) NSArray *titles;
// 分页控制器子控制器数组
@property (nonatomic, strong) NSArray *childVCs;

// 导航顶部titleView
@property (nonatomic, strong) UIView *titleView;
// 导航标题
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WBViewContoller

- (void)viewDidLoad{
    [super viewDidLoad];
    self.gk_navBarAlpha = 0;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navTitleView = self.titleView;
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithImageName:@"wb_more" target:self action:@selector(more)];
    
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageScrollView reloadData];
}

- (void)more{
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/**
 更改图片颜色

 @param color 更改以后的颜色
 @param image 需要转换的图片
 */
- (UIImage *)changeImageWithColor:(UIColor *)color image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - GKPageScrollViewDelegate
/**
 返回tableHeaderView
 */
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.headerView;
}

#pragma mark - 是否懒加载列表，优先级高于属性isLazyLoadList
/**
 返回分页视图
 非懒加载相关方法(`shouldLazyLoadListInPageScrollView`方法返回NO时必须实现下面的方法)
 */
- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.pageView;
}

/**
 返回listView
 */
- (NSArray <id <GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.childVCs;
}

// GKNavigationBarViewController 可替换，实际使用时不再使用该库
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = 0;
    UIImage *leftBar = nil;
    UIImage *rightBar = nil;
    if (offsetY <= 60.f) {
        alpha = 0.f;
        self.titleLabel.alpha = alpha;
        self.gk_statusBarStyle = UIStatusBarStyleLightContent;
        leftBar = GKImage(@"btn_back_white");
        rightBar = GKImage(@"wb_more");
    }
    else if (offsetY >= 100.f){
        alpha = 1.f;
        self.titleLabel.alpha = alpha;
        self.gk_statusBarStyle = UIStatusBarStyleDefault;
        leftBar = GKImage(@"btn_back_black");
        rightBar = [self changeImageWithColor:[UIColor blackColor] image:[UIImage imageNamed:@"wb_more"]];
    }
    else{
        alpha = (offsetY - 60) / (100 - 60);
        if (alpha > 0.8) {
            self.titleLabel.alpha = (offsetY - 92) / (100 - 92);
            self.gk_statusBarStyle = UIStatusBarStyleDefault;
            leftBar = GKImage(@"btn_back_black");
            rightBar = [self changeImageWithColor:[UIColor blackColor] image:[UIImage imageNamed:@"wb_more"]];
        }
        else{
            self.titleLabel.alpha = 0;
            self.gk_statusBarStyle = UIStatusBarStyleLightContent;
            leftBar = GKImage(@"btn_back_white");
            rightBar = GKImage(@"wb_more");
        }
    }
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil
                                                            image:leftBar
                                                           target:self
                                                           action:@selector(back)];
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil
                                                             image:rightBar
                                                            target:self
                                                            action:@selector(more)];
    self.gk_navBarAlpha = alpha;
    [self.headerView scrollViewDidScroll:offsetY];
}

#pragma mark - WMPageControllerDelegate, WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.childVCs.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    return self.childVCs[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, 0, Main_Screen_Width, 40.0f);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    CGFloat maxY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:pageController.menuView]);
    return CGRectMake(0, maxY, Main_Screen_Width, Main_Screen_Height - maxY - k_Height_NavBar);
}

#pragma mark - WMPageControllerDelegate
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    NSLog(@"加载数据");
}

#pragma mark - GKWBPageViewControllDelegate
- (void)pageScrollViewWillBeginScroll {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)pageScrollViewDidEndedScroll {
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

- (WBHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WBHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, kHeaderHeight)];
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

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        _titleView.backgroundColor = UIColor.clearColor;
        [_titleView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.titleView);
        }];
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithSize:[UIFont systemFontOfSize:18.f]
                                   textColor:UIColor.blackColor
                               textAlignment:NSTextAlignmentCenter];
        _titleLabel.text = @"广文博见V";
        _titleLabel.alpha = 0;
    }
    return _titleLabel;
}

@end
