//
//  TextController.h
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOperation.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#define PlayTable @"PlayTable" 
@interface TextController : UIViewController<ABPeoplePickerNavigationControllerDelegate> {
    DBOperation *da;
    
    UITextField *listName;
    UITextField *nameIn;
    UITextField *nameOut;
    NSString *str1;
    NSString *str2;
    NSString *str3;
    BOOL bo;
}
@property(nonatomic,retain)IBOutlet UITextField *listName;
@property(nonatomic,retain)IBOutlet UITextField *nameIn;
@property(nonatomic,retain)IBOutlet UITextField *nameOut;
@property(nonatomic,assign)NSString *str1;
@property(nonatomic,assign)NSString *str2;
@property(nonatomic,assign)NSString *str3;
-(IBAction)save:(id)sender;
-(IBAction)cance:(id)sender;
-(IBAction)addWith:(id)sender;
-(IBAction)addWithout:(id)sender;

@end
