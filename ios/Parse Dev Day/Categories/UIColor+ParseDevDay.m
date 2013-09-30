//
//  UIColor+ParseDevDay.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "UIColor+ParseDevDay.h"

@implementation UIColor (ParseDevDay)

// actual colors

+ (UIColor *)pddGreyBlueColor {
    return [[self class] colorWithIntRed:115 intGreen:151 intBlue:168];
}

+ (UIColor *)pddTextColor {
    return [[self class] colorWithIntRed:63 intGreen:88 intBlue:100];
}

+ (UIColor *)pddSubtitleColor {
    return [[self class] colorWithIntRed:118 intGreen:130 intBlue:140];
}

+ (UIColor *)pddBackgroundColor {
    return [[self class] colorWithIntRed:222 intGreen:233 intBlue:236];
}

+ (UIColor *)pddBreakTextColor {
    return [[self class] colorWithIntRed:100 intGreen:122 intBlue:140];
}

+ (UIColor *)pddOverlayColor {
    return [[self class] colorWithIntRed:238 intGreen:240 intBlue:242 alpha:0.9];
}

// bullshit colors

+ (UIColor *)pddParseBlueColor {
    return [[self class] colorWithHex:0x0076B0];
}

+ (UIColor *)pddAccentBlueColor {
    return [[self class] colorWithIntRed:0 intGreen:156 intBlue:235];
}

+ (UIColor *)pddOrangeColor {
    return [[self class] colorWithIntRed:255 intGreen:147 intBlue:0];
}

+ (UIColor *)colorWithHex:(long)hexColor {
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorWithIntRed:(NSInteger)red intGreen:(NSInteger)green intBlue:(NSInteger)blue {
    return [[self class] colorWithIntRed:red intGreen:green intBlue:blue alpha:1];
}

+ (UIColor *)colorWithIntRed:(NSInteger)red intGreen:(NSInteger)green intBlue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


@end
