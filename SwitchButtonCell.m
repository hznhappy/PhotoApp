//
//  SwitchButtonCell.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "SwitchButtonCell.h"


@implementation SwitchButtonCell
@synthesize myCellSwitch;
@synthesize myLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [myCellSwitch release];
    [myLabel release];
}

@end
