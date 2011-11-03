//
//  SwitchButtonCell.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwitchButtonCell : UITableViewCell {
    UISwitch *mySwitch;
    UILabel *myLabel;
}
@property(nonatomic,retain)IBOutlet UISwitch *mySwitch;
@property(nonatomic,retain)IBOutlet UILabel *myLabel;

@end
