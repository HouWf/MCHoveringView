//
//  DYHeaderView.h
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/30.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDYHeaderHeight (kScreenW * 375.0f / 345.0f)
#define kDYBgImgHeight  (kScreenW * 110.0f / 345.0f)

NS_ASSUME_NONNULL_BEGIN

@interface DYHeaderView : UIView

- (void)scrollViewDidScroll:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
