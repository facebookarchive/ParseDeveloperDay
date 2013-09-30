//
//  PDDSpeakerView.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDSpeakerView.h"
#import "PDDSpeaker.h"
#import "PDDSpeakerButton.h"

#import "UIColor+ParseDevDay.h"
#import "UILabel+ParseDevDay.h"

#import <Parse/Parse.h>

@implementation PDDSpeakerView

- (id)initWithSpeaker:(PDDSpeaker *)speaker {
    if (self = [super initWithFrame:CGRectZero]) {
        self.alwaysBounceVertical = YES;

        PDDSpeakerButton *speakerButton = [[PDDSpeakerButton alloc] initWithSpeaker:speaker];
        speakerButton.enabled = NO;
        [self addSubview:speakerButton];

        UILabel *bioLabel = [UILabel autolayoutLabel];
        bioLabel.preferredMaxLayoutWidth = 280;
        bioLabel.numberOfLines = 0;
        bioLabel.font = [UIFont systemFontOfSize:14];
        bioLabel.textColor = [UIColor pddTextColor];
        [self addSubview:bioLabel];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[speakerButton]-20-[bioLabel]-(>=10)-|"
                                                                     options:NSLayoutFormatAlignAllCenterX
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(speakerButton, bioLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[speakerButton]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(speakerButton)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[bioLabel]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(bioLabel)]];
        bioLabel.text = speaker.bio;
    }
    return self;
}

@end
