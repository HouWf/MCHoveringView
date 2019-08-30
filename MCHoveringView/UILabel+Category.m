//
//  UILabel+Category.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

+ (UILabel *)labelWithSize:(UIFont *)fontSize textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] init];
    label.font = fontSize;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    return label;
}

@end
