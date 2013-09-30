//
//  UILabel+ParseDevDay.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "UILabel+ParseDevDay.h"

@implementation UILabel (ParseDevDay)
+ (UILabel *)autolayoutLabel {
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.backgroundColor = [UIColor clearColor];
    return label;
}
@end
