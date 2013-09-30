//
//  PDDSpeaker.m
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PDDSpeaker.h"

#import <Parse/PFObject+Subclass.h>

@implementation PDDSpeaker
@dynamic name;
@dynamic company;
@dynamic title;
@dynamic bio;
@dynamic twitter;
@dynamic photo;

+ (NSString *)parseClassName {
    return @"Speaker";
}

- (NSString *)description {
    return self.name;
}

@end
