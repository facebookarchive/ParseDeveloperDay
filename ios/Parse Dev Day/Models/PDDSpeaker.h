//
//  PDDSpeaker.h
//  Parse Dev Day
//
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <Parse/Parse.h>

@interface PDDSpeaker : PFObject<PFSubclassing>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *twitter;
@property (strong, nonatomic) PFFile *photo;
@end
