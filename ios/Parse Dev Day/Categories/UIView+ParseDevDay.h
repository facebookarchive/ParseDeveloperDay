//
//  UIView+ParseDevDay.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ParseDevDay)

+ (BOOL)shouldAdjustForEarlierIOSVersions;
- (void)addForegroundMotionEffects;
- (void)addBackgroundMotionEffects;

@end
