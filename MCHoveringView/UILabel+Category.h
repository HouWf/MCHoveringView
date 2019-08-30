//
//  UILabel+Category.h
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Category)

+ (UILabel *)labelWithSize:(UIFont *)fontSize
                 textColor:(UIColor *)textColor
             textAlignment:(NSTextAlignment)textAlignment;
@end

NS_ASSUME_NONNULL_END
