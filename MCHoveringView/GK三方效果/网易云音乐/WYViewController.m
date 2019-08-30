//
//  WYViewController.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/28.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "WYViewController.h"
#import "WBListTableViewController.h"
#import "WBPageViewController.h"
#import "WYHeaderView.h"

#define off -ADAPTATIONRATIO * 50.0f

@interface WYViewController ()<GKPageScrollViewDelegate, WMPageControllerDelegate, WMPageControllerDataSource, WBPageViewControllerScrollDelegate>

// 最底层
@property (nonatomic, strong) GKPageScrollView *pageScrollView;
// 顶部
@property (nonatomic, strong) WYHeaderView *headerView;
// 分页控制器
@property (nonatomic, strong) WBPageViewController *pageVC;
// 承接分页视图
@property (nonatomic, strong) UIView *pageView;

// 分页控制器标题数组
@property (nonatomic, strong) NSArray *titles;
// 分页控制器子控制器数组
@property (nonatomic, strong) NSArray *childVCs;

@property (nonatomic, strong) UIImageView           *headerBgImgView;

@property (nonatomic, strong) UIVisualEffectView    *effectView;

@end

@implementation WYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gk_navBackgroundColor = [UIColor clearColor];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navTitleColor = [UIColor whiteColor];
    self.gk_navLineHidden = YES;
    
    [self.view addSubview:self.headerBgImgView];
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.pageScrollView];
    
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(k_Height_NavBar, 0, 0, 0));
    }];
#pragma 设置HeaderView的布局会产生下拉放大效果 对比WBViewController
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.width.mas_equalTo(Main_Screen_Width);
        make.height.mas_equalTo(kHeaderHeight);
    }];
    
    [self.headerBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(off);
        make.left.right.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(k_Height_NavBar);
        make.bottom.equalTo(self.headerView.mas_top).offset(kHeaderHeight - off);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerBgImgView);
    }];
    
    [self.pageScrollView reloadData];
    
}

- (BOOL)isAlbumNamelabelShowingOn{
    UIView *view = self.headerView.nameLabel;
    
    // 获取titleLabel在视图上的位置
    CGRect showFrame = [self.view convertRect:view.frame fromView:view.superview];
    showFrame.origin.y -= k_Height_NavBar;
    
    // 判断是否有重叠部分
    BOOL istersects = CGRectIntersectsRect(self.view.bounds, showFrame);
    
    return !view.isHidden && view.alpha > 0.01 && istersects;
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.headerView;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.pageView;
}

- (NSArray<id <GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.childVCs;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= kHeaderHeight) {
        [self.headerBgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(off);
            make.bottom.equalTo(self.headerView.mas_top).offset(kHeaderHeight - off);
        }];
        self.effectView.alpha = 1.f;
    }
    else{
        // 临界点 高度不变
        if (offsetY <= 0 && offsetY >= off) {
            CGFloat criticcalOffsetY = offsetY - off;
            [self.headerBgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(-criticcalOffsetY);
                make.bottom.equalTo(self.headerView.mas_top).offset(kHeaderHeight + criticcalOffsetY);
            }];
        }
        else{
            // 小于-20 下拉放大
            [self.headerBgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.headerView.mas_top).offset(kHeaderHeight);
            }];
        }
        self.effectView.alpha = offsetY / kHeaderHeight;
    }
    
    BOOL show = [self isAlbumNamelabelShowingOn];
    self.gk_navTitle = show ? @"" : self.headerView.nameLabel.text;
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
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.mainTableView.backgroundColor = [UIColor clearColor];
        _pageScrollView.ceilPointHeight = 0;
    }
    return _pageScrollView;
}

- (WYHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WYHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kHeaderHeight)];
    }
    return _headerView;
}

- (WBPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[WBPageViewController alloc] init];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        _pageVC.scrollDelegate = self;
        
        // 菜单属性
        _pageVC.menuItemWidth = kScreenW / 4.0f - 20;
        _pageVC.menuViewStyle = WMMenuViewStyleLine;
        
        _pageVC.titleSizeNormal     = 16.0f;
        _pageVC.titleSizeSelected   = 16.0f;
        _pageVC.titleColorNormal    = [UIColor grayColor];
        _pageVC.titleColorSelected  = [UIColor blackColor];
        
        // 进度条属性
        _pageVC.progressColor               = GKColorRGB(250, 69, 6);
        _pageVC.progressWidth               = 30.0f;
        _pageVC.progressHeight              = 3.0f;
        _pageVC.progressViewBottomSpace     = 2.0f;
        _pageVC.progressViewCornerRadius    = _pageVC.progressHeight / 2;
        
        // 调皮效果
        _pageVC.progressViewIsNaughty       = YES;
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

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"主页", @"微博", @"视频", @"故事"];
    }
    return _titles;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        WBListTableViewController *homeVC = [WBListTableViewController new];
        
        WBListTableViewController *wbVC = [WBListTableViewController new];
        
        WBListTableViewController *videoVC = [WBListTableViewController new];
        
        WBListTableViewController *storyVC = [WBListTableViewController new];
        
        _childVCs = @[homeVC, wbVC, videoVC, storyVC];
    }
    return _childVCs;
}

- (UIImageView *)headerBgImgView{
    if (!_headerBgImgView) {
        _headerBgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wy_bg"]];
        _headerBgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headerBgImgView.clipsToBounds = YES;
    }
    return _headerBgImgView;
}

- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:eff];
        _effectView.alpha = 0.f;
    }
    return _effectView;
}

@end
