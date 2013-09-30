//
//  PDDTalk.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDTalk.h"
#import "PDDSlot.h"
#import "PDDRoom.h"
#import "PDDSpeaker.h"
#import "PDDConstants.h"

#import <Parse/PFObject+Subclass.h>

@interface PDDTalk ()
+ (NSDateFormatter *)_dateFormatter;
+ (NSComparator)_orderByTimeThenRoomComparator;
@end

@implementation PDDTalk

@dynamic title;
@dynamic abstract;
@dynamic alwaysFavorite;
@dynamic speakers;
@dynamic slot;
@dynamic room;
@dynamic icon;

+ (NSString *)parseClassName {
    return @"Talk";
}

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [PDDTalk query];
    [query includeKey:@"room"];
    [query includeKey:@"slot"];
    [query includeKey:@"speakers"];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *talks, NSError *error) {
        resultBlock([[self class] sortedTalkArray:talks], error);
    }];
}

+ (void)findFavorites:(NSArray *)talkIds inBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [PDDTalk query];
    [query whereKey:@"alwaysFavorite" equalTo:@(YES)];
    if (talkIds) {
        PFQuery *favoriteQuery = [PDDTalk query];
        [favoriteQuery whereKey:@"objectId" containedIn:talkIds];
        query = [PFQuery orQueryWithSubqueries:@[ query, favoriteQuery ]];
    }
    [query includeKey:@"room"];
    [query includeKey:@"slot"];
    [query includeKey:@"speakers"];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *talks, NSError *error) {
        resultBlock([[self class] sortedTalkArray:talks], error);
    }];
}

+ (NSArray *)sortedTalkArray:(NSArray *)talks {
    return [talks sortedArrayUsingComparator:[[self class] _orderByTimeThenRoomComparator]];
}

+ (NSString *)stringTime:(NSDate *)startTime {
    return [[[self class] _dateFormatter] stringFromDate:startTime];
}

- (NSString *)talkTime {
    return [[self class] stringTime:self.slot.startTime];
}

- (void)toggleFavorite:(BOOL)isFavorite {
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFavoriteKey];
    BOOL contains = [self isFavorite];

    if (!(contains ^ isFavorite)) {
        return; // status quo is fine, the UI shouldn't have allowed this case in the first place
    }

    NSNotification *notification;
    if (isFavorite) {
        if (favorites == nil) {
            favorites = @[ self.objectId ];
        } else {
            favorites = [favorites arrayByAddingObject:self.objectId];
        }
        notification = [NSNotification notificationWithName:PDDTalkFavoriteTalkAddedNotification object:self];
    } else {
        favorites = [favorites filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *objectId, NSDictionary *bindings) {
            return ![objectId isEqualToString:self.objectId];
        }]];
        notification = [NSNotification notificationWithName:PDDTalkFavoriteTalkRemovedNotification object:self];
    }
    [[NSUserDefaults standardUserDefaults] setObject:favorites forKey:kDefaultsFavoriteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (BOOL)isFavorite {
    NSSet *favorites = [NSSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFavoriteKey]];
    return [favorites containsObject:self.objectId];
}

- (NSString *)description {
    return self.title;
}

#pragma mark - Private methods
+ (NSDateFormatter *)_dateFormatter {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm"];
    }
    return formatter;
}

+ (NSComparator)_orderByTimeThenRoomComparator {
    return ^NSComparisonResult(PDDTalk *talk1, PDDTalk *talk2) {
        NSComparisonResult timeResult = [talk1.slot.startTime compare:talk2.slot.startTime];
        if (timeResult != NSOrderedSame) {
            return timeResult;
        }
        return [talk1.room.name compare:talk2.room.name];
    };
}

@end
