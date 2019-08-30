//
//  WBHeaderView.h
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kHeaderHeight Main_Screen_Width * 385.0f / 704.0f

@interface WBHeaderView : UIView

- (void)scrollViewDidScroll:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
