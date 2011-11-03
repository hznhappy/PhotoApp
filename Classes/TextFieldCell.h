//
//  TextFieldCell.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldCell : UITableViewCell {
    UITextField *myTextField;
}
@property(nonatomic,retain)IBOutlet UITextField *myTextField;
@end
