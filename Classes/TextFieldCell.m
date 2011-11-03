//
//  TextFieldCell.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "TextFieldCell.h"


@implementation TextFieldCell
@synthesize myTextField;

-(void)dealloc{
    [super dealloc];
    [myTextField release];
}
@end
