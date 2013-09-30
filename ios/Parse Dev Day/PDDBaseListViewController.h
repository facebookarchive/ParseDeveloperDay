//
//  PDDBaseListViewController.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

@class PDDTalk;

@interface PDDBaseListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (void)favorite:(id)sender;
- (PDDTalk *)talkForIndexPath:(NSIndexPath *)indexPath;

- (void)favoriteAdded:(NSNotification *)notification;
- (void)favoriteRemoved:(NSNotification *)notification;
@end
