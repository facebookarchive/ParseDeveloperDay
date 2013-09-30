//
//  PDDBaseListViewController.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDBaseListViewController.h"
#import "PDDTalkViewController.h"
#import "PDDConstants.h"

#import "PDDTalkCell.h"
#import "UIColor+ParseDevDay.h"

@interface PDDBaseListViewController ()

@end

@implementation PDDBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favoriteAdded:)
                                                 name:PDDTalkFavoriteTalkAddedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favoriteRemoved:)
                                                 name:PDDTalkFavoriteTalkRemovedNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PDDTalkFavoriteTalkAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PDDTalkFavoriteTalkRemovedNotification object:nil];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PDDTalkViewController *talkViewController = [[PDDTalkViewController alloc] initWithTalk:[self talkForIndexPath:indexPath]];
    [self.navigationController pushViewController:talkViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDDTalk *talk = [self talkForIndexPath:indexPath];
    return talk.alwaysFavorite ? 35 : 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    return sectionTitle ? 40 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    if (!title) {
        return nil;
    }
    static NSString *reuseHeaderIdentifier = @"section header";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:reuseHeaderIdentifier];
        headerView.textLabel.textColor = [UIColor pddTextColor];
        headerView.backgroundView = [[UIView alloc] init];
        headerView.backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
    }
    headerView.textLabel.text = [NSString stringWithFormat:@"    %@", title];

    return headerView;
}

#pragma mark - PDDBaseListViewController methods
- (void)favorite:(id)sender {
    UIView *target = sender;
    PDDTalkCell *talkCell;
    while ([target superview]) {
        if ([[target superview] isKindOfClass:[PDDTalkCell class]]) {
            talkCell = (PDDTalkCell *)[target superview];
        }
        target = [target superview];
    }

    BOOL newFavorite = ![talkCell.talk isFavorite];
    [talkCell.talk toggleFavorite:newFavorite];
}

- (PDDTalk *)talkForIndexPath:(NSIndexPath *)indexPath {
    [NSException raise:NSGenericException format:@"Not implemented by subclass"];
    return nil;
}

- (void)favoriteAdded:(NSNotification *)notification {
    [NSException raise:NSGenericException format:@"Not implemented by subclass"];
}

- (void)favoriteRemoved:(NSNotification *)notification {
    [NSException raise:NSGenericException format:@"Not implemented by subclass"];
}

@end
