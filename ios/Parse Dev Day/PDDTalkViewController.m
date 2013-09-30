//
//  PDDTalkViewController.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDTalkViewController.h"
#import "PDDTalk.h"
#import "PDDSpeakerViewController.h"

#import "PDDContentView.h"
#import "PDDTalkView.h"
#import "PDDSpeakerButton.h"

@interface PDDTalkViewController ()
@property (strong, nonatomic) PDDTalk *talk;
@property (weak, nonatomic) PDDTalkView *talkView;

- (void)favorite:(id)sender;
- (void)showSpeaker:(id)sender;
@end

@implementation PDDTalkViewController

- (id)initWithTalk:(PDDTalk *)talk {
    if (self = [super init]) {
        self.talk = talk;
    }
    return self;
}

- (void)loadView {
    PDDContentView *contentView = [[PDDContentView alloc] init];
    PDDTalkView *talkView = [[PDDTalkView alloc] initWithTalk:self.talk];
    [talkView.favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    for (UIControl *button in talkView.speakerButtons) {
        [button addTarget:self action:@selector(showSpeaker:) forControlEvents:UIControlEventTouchUpInside];
    }
    [contentView addScrollView:talkView];
    self.talkView = talkView;
    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Talk Details";
}

#pragma mark - PDDTalkViewController methods
- (void)favorite:(id)sender {
    BOOL newFavorite = ![self.talk isFavorite];
    [self.talk toggleFavorite:newFavorite];
    [self.talkView.favoriteButton setSelected:newFavorite];
}

- (void)showSpeaker:(id)sender {
    PDDSpeakerButton *button = sender;
    PDDSpeakerViewController *speakerViewController = [[PDDSpeakerViewController alloc] initWithSpeaker:button.speaker];
    [self.navigationController pushViewController:speakerViewController animated:YES];
}

@end
