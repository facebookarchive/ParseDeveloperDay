//
//  PDDSplashViewController.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDSplashViewController.h"
#import "PDDConstants.h"
#import "PDDSplashView.h"

#import <Parse/Parse.h>

@interface PDDSplashViewController ()
- (void)skip:(id)sender;
@end

@implementation PDDSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    PDDSplashView *view = [[PDDSplashView alloc] init];
    [view.goButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    self.view = view;
}

#pragma mark - PDDSplashViewController methods
- (void)skip:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDefaultsSplashSeenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}


@end
