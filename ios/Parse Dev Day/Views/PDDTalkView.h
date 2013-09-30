//
//  PDDTalkView.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

@class PDDTalk;

@interface PDDTalkView : UIScrollView
@property (weak, nonatomic) UIButton *favoriteButton;
@property (strong, nonatomic) NSArray *speakerButtons;

- (id)initWithTalk:(PDDTalk *)talk;

@end
