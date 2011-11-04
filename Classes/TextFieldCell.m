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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

-(IBAction)hideKeyBoard:(id)sender{
    [sender resignFirstResponder];
}

-(void)dealloc{
    [super dealloc];
    [myTextField release];
}
@end
