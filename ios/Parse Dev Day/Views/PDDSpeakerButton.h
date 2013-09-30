//
//  PDDSpeakerButton.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

@class PDDSpeaker;

@interface PDDSpeakerButton : UIControl
- (id)initWithSpeaker:(PDDSpeaker *)speaker;

@property (strong, nonatomic) PDDSpeaker *speaker;
@end
