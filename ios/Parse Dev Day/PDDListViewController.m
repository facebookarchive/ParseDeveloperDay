//
//  PDDListViewController.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDListViewController.h"
#import "PDDListView.h"
#import "PDDTalkCell.h"

#import "PDDTalk.h"
#import "PDDSlot.h"
#import "PDDRoom.h"

#import "UIColor+ParseDevDay.h"

#import <Parse/Parse.h>

@interface PDDListViewController()
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *rawTalks;
@property (strong, nonatomic) NSDictionary *dataBySection;
@property (strong, nonatomic) NSArray *sortedSections;
@property (nonatomic) PDDTalkSectionType currentSectionSort;

- (void)changeSections:(id)sender;

- (void)_reorderTableViewSections;
- (void)_reorderTableViewSectionsByTime;
- (void)_reorderTableViewSectionsByTrack;
- (void)_setObject:(id)object inArray:(id)key inDictionary:(NSMutableDictionary *)dict;
- (BOOL)_isSortByTime;
- (void)_reloadVisibleRows;
- (BOOL)_isLastSection:(NSInteger)sectionIndex;
- (BOOL)_isLastRow:(NSIndexPath *)indexPath;
@end

@implementation PDDListViewController

- (id)init {
    if (self = [super init]) {
        self.title = @"All Talks";
        self.tabBarItem.image = [UIImage imageNamed:@"talks"];
        self.currentSectionSort = kPDDTalkSectionByTime;
    }
    return self;
}

- (void)loadView {
    PDDListView *listView = [[PDDListView alloc] init];
    listView.delegate = self;
    listView.dataSource = self;
    self.tableView = listView;
    self.view = listView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [PDDTalk findAllInBackgroundWithBlock:^(NSArray *talks, NSError *error) {
        self.rawTalks = talks;
        [self _reorderTableViewSections];
    }];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionKey = [self.sortedSections objectAtIndex:section];
    return [[self.dataBySection objectForKey:sectionKey] count] + ([self _isLastSection:section] ? 1 : 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedSections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] > 1) {
        return [[self.sortedSections objectAtIndex:section] description];
    } else if (section == 0) {
        return @"Morning Sessions";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kReuseIdentifier = @"schedule cell";
    PDDTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (cell == nil) {
        cell = [[PDDTalkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
        [cell.favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.sectionType = self.currentSectionSort;

    if ([self _isLastRow:indexPath]) {
        [cell setAsToggleSortCell];
    } else {
        [cell setTalk:[self talkForIndexPath:indexPath]];
    }

    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self _isLastRow:indexPath]) {
        self.currentSectionSort = (self.currentSectionSort == kPDDTalkSectionByTime) ? kPDDTalkSectionByTrack : kPDDTalkSectionByTime;
        [self _reorderTableViewSections];
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - PDDBaseListViewController methods
- (PDDTalk *)talkForIndexPath:(NSIndexPath *)indexPath {
    id sectionKey = [self.sortedSections objectAtIndex:indexPath.section];
    NSArray *sectionData = [self.dataBySection objectForKey:sectionKey];
    if (indexPath.row < [sectionData count]) {
        return [sectionData objectAtIndex:indexPath.row];
    }
    return nil;
}

- (void)favoriteAdded:(NSNotification *)notification {
    [self _reloadVisibleRows];
}

- (void)favoriteRemoved:(NSNotification *)notification {
    [self _reloadVisibleRows];
}

#pragma mark - PDDListViewController methods
- (void)changeSections:(id)sender {
    UISegmentedControl *control = sender;
    if (self.currentSectionSort == control.selectedSegmentIndex) {
        return;
    }
    self.currentSectionSort = control.selectedSegmentIndex;
    [self _reorderTableViewSections];
}

#pragma mark - Private methods
- (void)_reorderTableViewSections {
    if ([self _isSortByTime]) {
        [self _reorderTableViewSectionsByTime];
    } else {
        [self _reorderTableViewSectionsByTrack];
    }
    [self.tableView reloadData];
}

- (void)_reorderTableViewSectionsByTime {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self.rawTalks enumerateObjectsUsingBlock:^(PDDTalk *talk, NSUInteger idx, BOOL *stop) {
        id groupKey = talk.slot.startTime;
        [self _setObject:talk inArray:groupKey inDictionary:dictionary];
    }];

    NSArray *sortedKeys = [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    // a little extra conversion necessary
    NSMutableArray *dateStrings = [NSMutableArray arrayWithCapacity:[sortedKeys count]];
    [sortedKeys enumerateObjectsUsingBlock:^(NSDate *date, NSUInteger idx, BOOL *stop) {
        NSString *string = [PDDTalk stringTime:date];
        [dateStrings addObject:string];
        [dictionary setObject:[dictionary objectForKey:date] forKey:string];
        [dictionary removeObjectForKey:date];
    }];
    self.dataBySection = dictionary;
    self.sortedSections = dateStrings;
}

- (void)_reorderTableViewSectionsByTrack {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self.rawTalks enumerateObjectsUsingBlock:^(PDDTalk *talk, NSUInteger idx, BOOL *stop) {
        if (talk.alwaysFavorite) {
            // Skip always-favorited talks in the Track view
            return;
        }
        id groupKey = talk.room.name;
        [self _setObject:talk inArray:groupKey inDictionary:dictionary];
    }];

    NSArray *sortedKeys = [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.dataBySection = dictionary;
    self.sortedSections = sortedKeys;
}

- (void)_setObject:(id)object inArray:(id)key inDictionary:(NSMutableDictionary *)dict {
    NSArray *sectionTalks = [dict objectForKey:key];
    if (sectionTalks) {
        [dict setObject:[sectionTalks arrayByAddingObject:object] forKey:key];
    } else {
        [dict setObject:@[ object ] forKey:key];
    }
}

- (BOOL)_isSortByTime {
    return self.currentSectionSort == kPDDTalkSectionByTime;
}

- (void)_reloadVisibleRows {
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)_isLastSection:(NSInteger)sectionIndex {
    return sectionIndex == [self.sortedSections count] - 1;
}

- (BOOL)_isLastRow:(NSIndexPath *)indexPath {
    if (![self _isLastSection:indexPath.section]) {
        return NO;
    }
    id sectionKey = [self.sortedSections objectAtIndex:indexPath.section];
    return indexPath.row == [[self.dataBySection objectForKey:sectionKey] count];
}

@end
