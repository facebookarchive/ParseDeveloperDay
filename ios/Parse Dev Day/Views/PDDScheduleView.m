//
//  PDDScheduleView.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDScheduleView.h"

@interface PDDScheduleView()
@property (weak, nonatomic) UIView *emptyView;
@end

@implementation PDDScheduleView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG"]];
        bgView.contentMode = UIViewContentModeCenter;
        self.backgroundView = bgView;
    }
    return self;
}

@end
