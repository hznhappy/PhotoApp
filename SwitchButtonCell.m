//
//  SwitchButtonCell.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "SwitchButtonCell.h"


@implementation SwitchButtonCell
@synthesize mySwitch;
@synthesize myLabel;

-(void)dealloc{
    [super dealloc];
    [mySwitch release];
    [myLabel release];
}

@end
