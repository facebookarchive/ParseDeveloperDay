//
//  UIColor+ParseDevDay.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ParseDevDay)

+ (UIColor *)pddGreyBlueColor;
+ (UIColor *)pddTextColor;
+ (UIColor *)pddSubtitleColor;
+ (UIColor *)pddBackgroundColor;
+ (UIColor *)pddBreakTextColor;
+ (UIColor *)pddOverlayColor;

// bullshit colors
+ (UIColor *)pddParseBlueColor;

+ (UIColor *)pddAccentBlueColor;
+ (UIColor *)pddOrangeColor;

+ (UIColor *)colorWithHex:(long)hexColor;

@end
