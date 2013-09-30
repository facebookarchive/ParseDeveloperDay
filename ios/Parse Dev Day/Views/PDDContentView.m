//
//  PDDContentView.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDContentView.h"

#import "UIView+ParseDevDay.h"

@implementation PDDContentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG"]];
        CGFloat yOffset = FB_IOS7_SDK_OR_LATER ? -40 : -104;
        bgView.frame = CGRectMake(-40, yOffset, bgView.bounds.size.width, bgView.bounds.size.height);
        [self addSubview:bgView];
    }
    return self;
}

- (void)addScrollView:(UIScrollView *)scrollView {
    [self addSubview:scrollView];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];

#if FB_IOS7_SDK_OR_LATER
    if (![UIView shouldAdjustForEarlierIOSVersions]) {
        // Ensures that the content starts below the UINavigationBar, while
        // still allowing content to go behind the UINavigationBar when
        // scrolled down.
        // When this is set as the UIViewController's root view, this is all
        // handled for us by default.
        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0);
    }
#endif
}

@end
