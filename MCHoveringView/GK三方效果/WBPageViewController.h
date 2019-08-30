//
//  WBPageViewController.h
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBPageViewControllerScrollDelegate <NSObject>
@optional

- (void)pageScrollViewWillBeginScroll;
- (void)pageScrollViewDidEndedScroll;

@end

@interface WBPageViewController : WMPageController

@property (nonatomic, weak) id<WBPageViewControllerScrollDelegate> scrollDelegate;

@property (nonatomic, strong) UIView    *lineView;

@end

NS_ASSUME_NONNULL_END
