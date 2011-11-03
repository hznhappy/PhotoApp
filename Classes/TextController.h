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
#define Rules @"Rules"
@interface TextController : UIViewController<ABPeoplePickerNavigationControllerDelegate> {
    DBOperation *da;
    IBOutlet UITextField *listName;
    IBOutlet UITextField *nameIn;
    IBOutlet UITextField *nameOut;
    NSString *str1;
    NSString *str2;
    NSString *str3;
    BOOL bo;
    NSMutableArray *listUserNameIn;
    NSMutableArray *listUserIdIn;
    NSMutableArray *listUserNameOut;
    NSMutableArray *listUserIdOut;
    NSMutableArray *list;
    NSString *readName;
    NSString *fid;
    BOOL e;
    NSString * playlist_id;
    
}
@property(nonatomic,retain)IBOutlet UITextField *listName;
@property(nonatomic,retain)IBOutlet UITextField *nameIn;
@property(nonatomic,retain)IBOutlet UITextField *nameOut;
@property(nonatomic,assign)NSString *str1;
@property(nonatomic,assign)NSString *str2;
@property(nonatomic,assign)NSString *str3;
@property(nonatomic,assign)NSString *readName;
@property(nonatomic,assign)NSString *fid;
@property(nonatomic,retain)NSMutableArray *listUserNameIn;
@property(nonatomic,retain)NSMutableArray *listUserIdIn;
@property(nonatomic,retain)NSMutableArray *listUserNameOut;
@property(nonatomic,retain)NSMutableArray *listUserIdOut;
@property(nonatomic,retain)NSMutableArray *list;
-(IBAction)save:(id)sender;
-(IBAction)cance:(id)sender;
-(IBAction)addWith:(id)sender;
-(IBAction)addWithout:(id)sender;
-(void)EDIT;
@end
