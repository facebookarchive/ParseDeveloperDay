//
//  PDDAppDelegate.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDAppDelegate.h"

#import "PDDScheduleViewController.h"
#import "PDDListViewController.h"
#import "PDDSplashViewController.h"

#import "PDDTalk.h"
#import "PDDSpeaker.h"
#import "PDDRoom.h"
#import "PDDSlot.h"
#import "PDDConstants.h"

#import "UIColor+ParseDevDay.h"

#import <Parse/Parse.h>

@interface PDDAppDelegate ()
- (void)_customizeAppearance;
- (void)_scheduleLocalNotification:(NSNotification *)notification;
- (void)_unscheduleLocalNotification:(NSNotification *)notification;
- (UILocalNotification *)_localNotificationForTalk:(PDDTalk *)talk;
@end

@implementation PDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PDDTalk registerSubclass];
    [PDDSpeaker registerSubclass];
    [PDDRoom registerSubclass];
    [PDDSlot registerSubclass];
    [Parse setApplicationId:@"NN83LGZybDxGCxmGyA2b063eaYrLvCb2UUlJV7WB"
                  clientKey:@"sOgFGHbUYc2CoQ50aLYJ9ayA79ExSPT6553tVA3h"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *listViewController = [[PDDListViewController alloc] init];
    UIViewController *favViewController = [[PDDScheduleViewController alloc] init];

    UINavigationController *listNavViewController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    listNavViewController.navigationBarHidden = YES;
    UINavigationController *favNavViewController = [[UINavigationController alloc] initWithRootViewController:favViewController];
    favNavViewController.navigationBarHidden = YES;

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[ listNavViewController, favNavViewController ];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_scheduleLocalNotification:)
                                                 name:PDDTalkFavoriteTalkAddedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_unscheduleLocalNotification:)
                                                 name:PDDTalkFavoriteTalkRemovedNotification
                                               object:nil];

    if (![PFUser currentUser] && ![[NSUserDefaults standardUserDefaults] boolForKey:kDefaultsSplashSeenKey]) {
        PDDSplashViewController *splashViewController = [[PDDSplashViewController alloc] init];
        [self.tabBarController presentViewController:splashViewController animated:NO completion:nil];
    }
    
    [self _customizeAppearance];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Clears fired notifications from the Notification Center
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if (application.applicationState != UIApplicationStateActive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)_customizeAppearance {
    [[UISegmentedControl appearance] setTintColor:[UIColor pddParseBlueColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor pddParseBlueColor]];
}

- (void)_scheduleLocalNotification:(NSNotification *)notification {
    PDDTalk *talk = (PDDTalk *)notification.object;
    if ([self _localNotificationForTalk:talk]) {
        // We should never be double-scheduling local notifications, but just in
        // case one already exists for this talk,
        return;
    }

    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-7 * 60 * 60]; // PDT is GMT-700
    notif.alertAction = @"OK";
    notif.alertBody = [NSString stringWithFormat:@"%@ starting in 5 minutes in %@!", talk.title, talk.room.name];
    notif.userInfo = @{ PDDTalkObjectIdKey: talk.objectId };
    notif.fireDate = [talk.slot.startTime dateByAddingTimeInterval:-5 * 60];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

- (void)_unscheduleLocalNotification:(NSNotification *)notification {
    PDDTalk *talk = (PDDTalk *)notification.object;
    UILocalNotification *notif = [self _localNotificationForTalk:talk];
    if (notif) {
        [[UIApplication sharedApplication] cancelLocalNotification:notif];
    }
}

- (UILocalNotification *)_localNotificationForTalk:(PDDTalk *)talk {
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSInteger idx = [notifs indexOfObjectPassingTest:^BOOL(NSNotification *not, NSUInteger idx, BOOL *stop) {
        return [[not.userInfo objectForKey:PDDTalkObjectIdKey] isEqualToString:talk.objectId];
    }];
    if (idx == NSNotFound) {
        return nil;
    }
    return [notifs objectAtIndex:idx];
}

@end
