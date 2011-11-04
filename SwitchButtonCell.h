//
//  SwitchButtonCell.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwitchButtonCell : UITableViewCell {
    UISwitch *myCellSwitch;
    UILabel *myLabel;
}
@property(nonatomic,retain)IBOutlet UISwitch *myCellSwitch;
@property(nonatomic,retain)IBOutlet UILabel *myLabel;

@end
