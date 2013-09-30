//
//  PDDSlot.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <Parse/Parse.h>

@class PDDTalk;

@interface PDDSlot : PFObject<PFSubclassing>
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSArray *talks;
@end
