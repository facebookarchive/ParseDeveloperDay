//
//  PDDTalk.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <Parse/Parse.h>

@class PDDSlot, PDDRoom;

typedef enum {
    kPDDTalkSectionByTime = 0,
    kPDDTalkSectionByTrack = 1,
    kPDDTalkSectionByNone = 2
} PDDTalkSectionType;

@interface PDDTalk : PFObject<PFSubclassing>
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *abstract;
@property (nonatomic) BOOL alwaysFavorite;
@property (strong, nonatomic) NSArray *speakers;
@property (strong, nonatomic) PDDSlot *slot;
@property (strong, nonatomic) PDDRoom *room;
@property (strong, nonatomic) PFFile *icon;

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
+ (void)findFavorites:(NSArray *)talkIds inBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
+ (NSArray *)sortedTalkArray:(NSArray *)talks;
+ (NSString *)stringTime:(NSDate *)startTime;
- (NSString *)talkTime;
- (void)toggleFavorite:(BOOL)isFavorite;
- (BOOL)isFavorite;
@end
