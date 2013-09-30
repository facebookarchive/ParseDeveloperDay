//
//  PDDTalkView.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDTalkView.h"
#import "PDDTalk.h"
#import "PDDRoom.h"
#import "PDDSpeaker.h"
#import "PDDFavoriteButton.h"
#import "PDDSpeakerButton.h"

#import "UIColor+ParseDevDay.h"
#import "UILabel+ParseDevDay.h"

@implementation PDDTalkView

- (id)initWithTalk:(PDDTalk *)talk {
    if (self = [super initWithFrame:CGRectZero]) {
        self.alwaysBounceVertical = YES;
        
        UIView *headerView = [[UIView alloc] init];
        [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        headerView.backgroundColor = [UIColor pddOverlayColor];
        
        UILabel *titleLabel = [UILabel autolayoutLabel];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [UIColor pddTextColor];
        titleLabel.preferredMaxLayoutWidth = 220;
        titleLabel.numberOfLines = 0;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [headerView addSubview:titleLabel];
        
        PDDFavoriteButton *favoriteButton = [[PDDFavoriteButton alloc] init];
        [favoriteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:favoriteButton];
        self.favoriteButton = favoriteButton;

        UIImageView *timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
        [timeIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:timeIcon];
        
        UILabel *timeLabel = [UILabel autolayoutLabel];
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.textColor = [UIColor pddSubtitleColor];
        [headerView addSubview:timeLabel];

        UIImageView *roomIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        [roomIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:roomIcon];
        
        UILabel *roomLabel = [UILabel autolayoutLabel];
        roomLabel.font = [UIFont systemFontOfSize:15];
        roomLabel.textColor = [UIColor pddSubtitleColor];
        [headerView addSubview:roomLabel];
        
        [self addSubview:headerView];

        UILabel *abstractLabel = [UILabel autolayoutLabel];
        abstractLabel.font = [UIFont systemFontOfSize:14];
        abstractLabel.textColor = [UIColor pddTextColor];
        abstractLabel.preferredMaxLayoutWidth = 280;
        abstractLabel.numberOfLines = 0;
        [self addSubview:abstractLabel];

        [favoriteButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[favoriteButton(37)]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(favoriteButton)]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[titleLabel]-(>=10)-[favoriteButton(37)]-|"
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(titleLabel, favoriteButton)]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[timeIcon]-5-[timeLabel]-40-[roomIcon]-5-[roomLabel]"
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(timeIcon, timeLabel, roomIcon, roomLabel)]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[titleLabel]-[timeIcon]-|"
                                                                           options:NSLayoutFormatAlignAllLeft
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(titleLabel, timeIcon)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[abstractLabel]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(abstractLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[headerView(320)]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(headerView)]];

        // Set Talk data
        titleLabel.text = talk.title;
        timeLabel.text = [talk talkTime];
        roomLabel.text = talk.room.name;
        abstractLabel.text = talk.abstract;
        self.favoriteButton.hidden = talk.alwaysFavorite;
        self.favoriteButton.selected = [talk isFavorite];

        NSMutableDictionary *viewDict = [NSMutableDictionary dictionaryWithDictionary:NSDictionaryOfVariableBindings(headerView, abstractLabel)];
        __block NSMutableArray *speakerFormats = [NSMutableArray array];
        [talk.speakers enumerateObjectsUsingBlock:^(PDDSpeaker *speaker, NSUInteger idx, BOOL *stop) {
            PDDSpeakerButton *button = [[PDDSpeakerButton alloc] initWithSpeaker:speaker];
            [self addSubview:button];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[button]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(button)]];
            NSString *idString = [NSString stringWithFormat:@"speaker%d", idx];
            viewDict[idString] = button;
            [speakerFormats addObject:[NSString stringWithFormat:@"[%@]", idString]];
        }];
        self.speakerButtons = [[viewDict allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
            return ![obj isEqual:headerView] && ![obj isEqual:abstractLabel];
        }]];
        NSString *formatString = [NSString stringWithFormat:@"V:|[headerView]-20-[abstractLabel]-20-%@|", [speakerFormats componentsJoinedByString:@""]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString
                                                                     options:NSLayoutFormatAlignAllCenterX
                                                                     metrics:nil
                                                                       views:viewDict]];
    }
    return self;
}

@end
