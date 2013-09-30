//
//  UIView+ParseDevDay.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "UIView+ParseDevDay.h"

@implementation UIView (ParseDevDay)

+ (BOOL)shouldAdjustForEarlierIOSVersions {
    return floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1;
}

- (void)addForegroundMotionEffects {
    if (![[self class] motionEffectsAvailable]) {
        return;
    }

    #if FB_IOS7_SDK_OR_LATER
    UIInterpolatingMotionEffect *foregroundMotionXEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    foregroundMotionXEffect.maximumRelativeValue = [self foregroundMotionEffectMaximumRelativeValue];
    foregroundMotionXEffect.minimumRelativeValue = [self foregroundMotionEffectMinimumRelativeValue];
    [self addMotionEffect:foregroundMotionXEffect];
    
    UIInterpolatingMotionEffect *foregroundMotionYEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    foregroundMotionYEffect.maximumRelativeValue = [self foregroundMotionEffectMaximumRelativeValue];
    foregroundMotionYEffect.minimumRelativeValue = [self foregroundMotionEffectMinimumRelativeValue];
    [self addMotionEffect:foregroundMotionYEffect];
    #endif
}

- (void)addBackgroundMotionEffects {
    if (![[self class] motionEffectsAvailable]) {
        return;
    }

    #if FB_IOS7_SDK_OR_LATER
    UIInterpolatingMotionEffect *backgroundMotionXEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    backgroundMotionXEffect.maximumRelativeValue = [self backgroundMotionEffectMaximumRelativeValue];
    backgroundMotionXEffect.minimumRelativeValue = [self backgroundMotionEffectMinimumRelativeValue];
    [self addMotionEffect:backgroundMotionXEffect];
    
    UIInterpolatingMotionEffect *backgroundMotionYEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    backgroundMotionYEffect.maximumRelativeValue = [self backgroundMotionEffectMaximumRelativeValue];
    backgroundMotionYEffect.minimumRelativeValue = [self backgroundMotionEffectMinimumRelativeValue];
    [self addMotionEffect:backgroundMotionYEffect];
    #endif
}

#pragma mark - Private methods
+ (BOOL)motionEffectsAvailable {
    if (NSClassFromString(@"UIInterpolatingMotionEffect")) {
        return YES;
    }
    return NO;
}

- (void)addMotionEffectsWithDelta:(NSNumber *)delta {
    if (![[self class] motionEffectsAvailable]) {
        return;
    }

    #if FB_IOS7_SDK_OR_LATER
    UIInterpolatingMotionEffect *holographicMotionXEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    holographicMotionXEffect.maximumRelativeValue = delta;
    holographicMotionXEffect.minimumRelativeValue = @(-1 * [delta floatValue]);
    [self addMotionEffect:holographicMotionXEffect];
    
    UIInterpolatingMotionEffect *holographicMotionYEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    holographicMotionYEffect.maximumRelativeValue = @(-1 * [delta floatValue]);
    holographicMotionYEffect.minimumRelativeValue = delta;
    [self addMotionEffect:holographicMotionYEffect];
    #endif
}

- (NSNumber *)foregroundMotionEffectMinimumRelativeValue {
    return @(-10);
}

- (NSNumber *)foregroundMotionEffectMaximumRelativeValue {
    return @10;
}

- (NSNumber *)backgroundMotionEffectMinimumRelativeValue {
    return @40;
}

- (NSNumber *)backgroundMotionEffectMaximumRelativeValue {
    return @(-40);
}

@end
