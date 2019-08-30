//
//  WYHeaderView.h
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/28.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kHeaderHeight (kScreenW * 500.0f / 750.0f - kNavBarHeight)

@interface WYHeaderView : UIView

@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
