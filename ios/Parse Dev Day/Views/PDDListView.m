//
//  PDDListView.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDListView.h"
#import "PDDTalk.h"

@implementation PDDListView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG"]];
        bgView.contentMode = UIViewContentModeCenter;
        self.backgroundView = bgView;
    }
    return self;
}

@end
