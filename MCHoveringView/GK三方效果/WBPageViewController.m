//
//  WBPageViewController.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "WBPageViewController.h"

@interface WBPageViewController ()

@end

@implementation WBPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.menuView) {
        [self.menuView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.menuView);
            make.height.mas_equalTo(0.5f);
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    
    if ([self.scrollDelegate respondsToSelector:@selector(pageScrollViewWillBeginScroll)]) {
        [self.scrollDelegate pageScrollViewWillBeginScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [super scrollViewDidEndDecelerating:scrollView];
    
    if ([self.scrollDelegate respondsToSelector:@selector(pageScrollViewDidEndedScroll)]) {
        [self.scrollDelegate pageScrollViewDidEndedScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if ([self.scrollDelegate respondsToSelector:@selector(pageScrollViewDidEndedScroll)]) {
        [self.scrollDelegate pageScrollViewDidEndedScroll];
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

@end
