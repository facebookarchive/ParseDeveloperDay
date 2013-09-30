//
//  PDDTalkCell.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDTalk.h"

@interface PDDTalkCell : UITableViewCell
@property (nonatomic) PDDTalkSectionType sectionType;
@property (weak, nonatomic) UIButton *favoriteButton;

@property (strong, nonatomic) PDDTalk *talk;

- (void)setAsToggleSortCell;
@end
