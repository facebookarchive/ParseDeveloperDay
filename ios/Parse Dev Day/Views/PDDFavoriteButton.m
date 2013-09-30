//
//  PDDFavoriteButton.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDFavoriteButton.h"

#import "UIColor+ParseDevDay.h"

@implementation PDDFavoriteButton

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 37, 37)]) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"star_filled"] forState:UIControlStateSelected];
        self.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

@end
