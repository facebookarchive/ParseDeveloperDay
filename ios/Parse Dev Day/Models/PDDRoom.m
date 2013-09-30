//
//  PDDRoom.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDRoom.h"

#import <Parse/PFObject+Subclass.h>

@implementation PDDRoom

@dynamic name;

+ (NSString *)parseClassName {
    return @"Room";
}

@end
