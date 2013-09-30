//
//  PDDTalkCell.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDTalkCell.h"
#import "PDDRoom.h"
#import "PDDSlot.h"
#import "PDDSpeaker.h"
#import "PDDFavoriteButton.h"
#import "PDDPhotoView.h"

#import "UIColor+ParseDevDay.h"
#import "UILabel+ParseDevDay.h"

@interface PDDTalkCell ()
@property (weak, nonatomic) UIView *talkView;
@property (weak, nonatomic) PFImageView *photoImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *roomLabel;

@property (weak, nonatomic) UIView *breakView;
@property (weak, nonatomic) PFImageView *breakIcon;
@property (weak, nonatomic) UILabel *breakLabel;

- (void)_configureAsTalk;
- (void)_configureAsBreak;
@end

@implementation PDDTalkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
        self.textLabel.textColor = [UIColor pddTextColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;

        UIView *talkView = [[UIView alloc] initWithFrame:self.bounds];
        talkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        PDDPhotoView *imageView = [[PDDPhotoView alloc] init];
        [talkView addSubview:imageView];
        self.photoImageView = imageView;

        UIView *detailView = [[UIView alloc] init];
        [detailView setTranslatesAutoresizingMaskIntoConstraints:NO];

        UILabel *titleLabel = [UILabel autolayoutLabel];
        titleLabel.font = self.textLabel.font;
        titleLabel.textColor = [UIColor pddTextColor];
        [detailView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
        [timeIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [detailView addSubview:timeIcon];

        UILabel *timeLabel = [UILabel autolayoutLabel];
        timeLabel.font = [UIFont boldSystemFontOfSize:13];
        timeLabel.textColor = [UIColor pddSubtitleColor];
        [detailView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIImageView *roomIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        [roomIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [detailView addSubview:roomIcon];

        UILabel *roomLabel = [UILabel autolayoutLabel];
        roomLabel.font = [UIFont boldSystemFontOfSize:13];
        roomLabel.textColor = [UIColor pddSubtitleColor];
        [detailView addSubview:roomLabel];
        self.roomLabel = roomLabel;

        [talkView addSubview:detailView];

        PDDFavoriteButton *favoriteButton = [[PDDFavoriteButton alloc] init];
        [favoriteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [talkView addSubview:favoriteButton];
        self.favoriteButton = favoriteButton;

        [self.contentView addSubview:talkView];
        self.talkView = talkView;

        NSDictionary *views = NSDictionaryOfVariableBindings(imageView, detailView, titleLabel, timeIcon, timeLabel, roomIcon, roomLabel, favoriteButton);
        [detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-2-[timeIcon(9)]|"
                                                                           options:NSLayoutFormatAlignAllLeft
                                                                           metrics:nil
                                                                             views:views]];
        [detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[titleLabel]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        [detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[timeIcon(9)]-3-[timeLabel(35)]-10-[roomIcon(5)]-3-[roomLabel]-(>=10)-|"
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:nil
                                                                             views:views]];
        [talkView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[imageView(44)]-10-[detailView]-(>=10)-[favoriteButton(37)]-8-|"
                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                 metrics:nil
                                                                                   views:views]];
        // Mugh. Explicit size-setting, because AutoLayout is annoying
        [talkView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[imageView(44)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [talkView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[favoriteButton(37)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[roomIcon(9)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];

        // Now set up the layout for Break cells
        UIView *breakView = [[UIView alloc] init];
        [breakView setTranslatesAutoresizingMaskIntoConstraints:NO];

        PFImageView *breakIcon = [[PFImageView alloc] init];
        [breakIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [breakView addSubview:breakIcon];
        self.breakIcon = breakIcon;

        UILabel *breakLabel = [UILabel autolayoutLabel];
        breakLabel.font = [UIFont systemFontOfSize:14];
        breakLabel.textColor = [UIColor pddBreakTextColor];
        breakLabel.textAlignment = NSTextAlignmentCenter;
        [breakView addSubview:breakLabel];
        self.breakLabel = breakLabel;

        [self.contentView addSubview:breakView];
        self.breakView = breakView;

        // Center breakView within self
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:breakView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:breakView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

        // Mugh. Explicit size-setting, because AutoLayout is annoying
        [breakView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[breakIcon(18)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(breakIcon, breakLabel)]];
        [breakView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[breakIcon(18)]-5-[breakLabel]|"
                                                                          options:NSLayoutFormatAlignAllCenterY
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(breakIcon, breakLabel)]];
        [breakView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[breakLabel]|"
                                                                          options:NSLayoutFormatAlignAllCenterX
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(breakLabel)]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // do nothing, short-circuit super behavior
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
   // do nothing, short-circuit super behavior
}

- (void)prepareForReuse {
    self.photoImageView.image = nil;
}

#pragma mark - PDDTalkCell methods
- (void)setTalk:(PDDTalk *)talk {
    _talk = talk;

    if (talk.alwaysFavorite) {
        [self _configureAsBreak];
    } else {
        [self _configureAsTalk];
    }
    self.textLabel.hidden = YES;
    self.talkView.hidden = talk.alwaysFavorite;
    self.breakView.hidden = !talk.alwaysFavorite;
}

- (void)setAsToggleSortCell {
    self.textLabel.hidden = NO;
    self.talkView.hidden = YES;
    self.breakView.hidden = YES;

    if (self.sectionType == kPDDTalkSectionByTime) {
        self.textLabel.text = @"Sort by Track";
    } else {
        self.textLabel.text = @"Sort by Time";
    }
}

#pragma mark - Private methods
- (void)_configureAsTalk {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.talk.title;
    self.timeLabel.text = [self.talk talkTime];
    self.roomLabel.text = self.talk.room.name;

    if ([self.talk.speakers count] > 0) {
        PDDSpeaker *firstSpeaker = [self.talk.speakers objectAtIndex:0];
        [self.photoImageView setFile:firstSpeaker.photo];
        [self.photoImageView loadInBackground];
    }
    self.favoriteButton.selected = [self.talk isFavorite];
}

- (void)_configureAsBreak {
    self.contentView.backgroundColor = [UIColor pddBackgroundColor];
    self.breakLabel.text = self.talk.title;
    self.breakIcon.file = self.talk.icon;
    [self.breakIcon loadInBackground];
}

@end
