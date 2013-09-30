//
//  PDDSpeakerButton.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDSpeakerButton.h"
#import "PDDSpeaker.h"
#import "PDDPhotoView.h"

#import "UIColor+ParseDevDay.h"
#import "UILabel+ParseDevDay.h"

#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface PDDSpeakerButton ()
@property (weak, nonatomic) PDDPhotoView *photoView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *companyLabel;
@property (weak, nonatomic) UILabel *twitterLabel;
@end

@implementation PDDSpeakerButton

- (id)initWithSpeaker:(PDDSpeaker *)speaker {
    if (self = [super initWithFrame:CGRectZero]) {
        _speaker = speaker;
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.backgroundColor = [UIColor pddOverlayColor];

        PDDPhotoView *photoView = [[PDDPhotoView alloc] init];
        [self addSubview:photoView];
        self.photoView = photoView;

        UIView *detailView = [[UIView alloc] init];
        detailView.userInteractionEnabled = NO;
        [detailView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:detailView];

        UILabel *nameLabel = [UILabel autolayoutLabel];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        nameLabel.textColor = [UIColor pddTextColor];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        [detailView addSubview:nameLabel];
        self.nameLabel = nameLabel;

        UILabel *companyLabel = [UILabel autolayoutLabel];
        companyLabel.textColor = [UIColor pddTextColor];
        companyLabel.font = [UIFont systemFontOfSize:13];
        companyLabel.preferredMaxLayoutWidth = 200;
        companyLabel.numberOfLines = 0;
        [detailView addSubview:companyLabel];
        self.companyLabel = companyLabel;

        UILabel *twitterLabel = [UILabel autolayoutLabel];
        twitterLabel.textColor = [UIColor pddGreyBlueColor];
        twitterLabel.font = [UIFont systemFontOfSize:13];
        [detailView addSubview:twitterLabel];
        self.twitterLabel = twitterLabel;

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[photoView(80)]-10-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(photoView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[photoView(80)]-[detailView]-5-|"
                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(photoView, detailView)]];
        [detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel][companyLabel][twitterLabel]|"
                                                                     options:NSLayoutFormatAlignAllLeft
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(nameLabel, companyLabel, twitterLabel)]];

        // Fill in data
        self.photoView.file = speaker.photo;
        [self.photoView loadInBackground];
        self.nameLabel.text = speaker.name;
        self.companyLabel.text = [NSString stringWithFormat:@"%@ @ %@", speaker.title, speaker.company];
        self.twitterLabel.hidden = !speaker.twitter;
        self.twitterLabel.text = [NSString stringWithFormat:@"@%@", speaker.twitter];
    }
    return self;
}

@end
