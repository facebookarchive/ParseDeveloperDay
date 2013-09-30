//
//  PDDScheduleViewController.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDScheduleViewController.h"
#import "PDDTalkViewController.h"
#import "PDDScheduleView.h"
#import "PDDTalkCell.h"
#import "PDDConstants.h"

#import "PDDTalk.h"

@interface PDDScheduleViewController ()
@property (weak, nonatomic) PDDScheduleView *scheduleView;
@property (strong, nonatomic) NSArray *favoritedTalks;

@end

@implementation PDDScheduleViewController

- (id)init {
    if (self = [super init]) {
        self.title = @"Favorites";
        self.tabBarItem.image = [UIImage imageNamed:@"star"];
    }
    return self;
}

- (void)loadView {
    PDDScheduleView *view = [[PDDScheduleView alloc] init];
    view.dataSource = self;
    view.delegate = self;
    self.view = view;
    self.scheduleView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFavoriteKey];
    [PDDTalk findFavorites:favorites inBackgroundWithBlock:^(NSArray *talks, NSError *error) {
        self.favoritedTalks = talks;
        [self.scheduleView reloadData];
    }];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favoritedTalks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"favorite cell";
    PDDTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[PDDTalkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.sectionType = kPDDTalkSectionByNone;
        [cell.favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    }

    cell.talk = [self talkForIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - PDDBaseListViewController methods
- (PDDTalk *)talkForIndexPath:(NSIndexPath *)indexPath {
    if ([self.favoritedTalks count] == 0) {
        return nil;
    }
    return [self.favoritedTalks objectAtIndex:indexPath.row];
}

- (void)favoriteAdded:(NSNotification *)notification {
    self.favoritedTalks = [PDDTalk sortedTalkArray:[self.favoritedTalks arrayByAddingObject:notification.object]];
    [self.scheduleView reloadData];
}

- (void)favoriteRemoved:(NSNotification *)notification {
    PDDTalk *removedTalk = notification.object;
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(PDDTalk *talk, NSDictionary *bindings) {
        return ![talk.objectId isEqualToString:removedTalk.objectId];
    }];
    self.favoritedTalks = [self.favoritedTalks filteredArrayUsingPredicate:filterPredicate];
    [self.scheduleView reloadData];
}

@end
