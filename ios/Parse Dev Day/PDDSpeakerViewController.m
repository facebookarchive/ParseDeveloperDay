//
//  PDDSpeakerViewController.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDSpeakerViewController.h"

#import "PDDSpeakerView.h"
#import "PDDContentView.h"

@interface PDDSpeakerViewController ()
@property (strong, nonatomic) PDDSpeaker *speaker;
@end

@implementation PDDSpeakerViewController

- (id)initWithSpeaker:(PDDSpeaker *)speaker {
    if (self = [super init]) {
        self.speaker = speaker;
    }
    return self;
}

- (void)loadView {
    PDDContentView *contentView = [[PDDContentView alloc] init];
    PDDSpeakerView *speakerView = [[PDDSpeakerView alloc] initWithSpeaker:self.speaker];
    [contentView addScrollView:speakerView];
    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Speaker Details";
}

@end
