//
//  PDDSplashView.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDSplashView.h"

#import "UIView+ParseDevDay.h"
#import "UIColor+ParseDevDay.h"

@implementation PDDSplashView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(-40, -40, imageView.bounds.size.width, imageView.bounds.size.height);
        [self addSubview:imageView];
        
        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        [logoView setTranslatesAutoresizingMaskIntoConstraints:NO];
        logoView.contentMode = UIViewContentModeCenter;
        [self addSubview:logoView];
        
        UIButton *goButton = [[UIButton alloc] init];
        [goButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [goButton setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [self addSubview:goButton];
        self.goButton = goButton;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[logoView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(logoView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-120-[logoView]-(>=20)-[goButton]-40-|"
                                                                     options:NSLayoutFormatAlignAllCenterX
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(logoView, goButton)]];
        
        [imageView addBackgroundMotionEffects];
        [logoView addForegroundMotionEffects];
        [goButton addForegroundMotionEffects];
    }
    return self;
}

@end
