//
//  User.m
//  PhotoApp
//
//  Created by apple on 11-9-29.
//  Copyright 2011年 chinarewards. All rights reserved.
//
#import "User.h"
@implementation User
@synthesize name;
@synthesize Transtion;
//@synthesize Uid;

-(void)dealloc{
    [name release];
    [Transtion release];
   // [Uid release];
    [super dealloc];
}
@end
