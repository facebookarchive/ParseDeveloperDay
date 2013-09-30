//
//  PDDPhotoView.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDPhotoView.h"

#import <QuartzCore/QuartzCore.h>
#import "UIColor+ParseDevDay.h"

@interface PDDPhotoView ()
- (void)_setImage:(UIImage *)image inRect:(CGRect)rect;
@end

@implementation PDDPhotoView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (void)layoutSubviews {
    // redraw if necessary
    [self _setImage:self.image inRect:self.bounds];
}

- (void)setImage:(UIImage *)image {
    [self _setImage:image inRect:self.bounds];
}

#pragma mark - Private
- (void)_setImage:(UIImage *)image inRect:(CGRect)rect {
    if (CGRectEqualToRect(rect, CGRectZero)) {
        [super setImage:image];
        return;
    }

    // Do the image processing here, so we don't have to rely on cornerRadius
    // and clipsToBounds
    CGFloat scale = [UIScreen mainScreen].scale;
    rect = CGRectMake(0, 0, rect.size.width * scale, rect.size.height * scale);

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);

    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    CGContextDrawImage(ctx, rect, image.CGImage);

    // Draw border
    CGContextSetLineWidth(ctx, scale);
    CGContextSetStrokeColorWithColor(ctx, [UIColor pddGreyBlueColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, rect);
    CGContextRestoreGState(ctx);
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [super setImage:roundImage];
}

@end
