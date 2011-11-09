//
//  ContactsController.h
//  PhotoApp
//
//  Created by apple on 11-11-8.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *ContactTable;
    NSMutableArray *list;
    //NSDictionary *names;
    
    NSMutableDictionary *names;  
    NSArray *keys;  
    NSArray *array;
    NSMutableArray *fu;
}  
@property (nonatomic, retain) NSMutableDictionary *names;  
@property (nonatomic, retain) NSArray *keys; 
@property (nonatomic, retain) NSArray *array; 
@property (nonatomic, retain) NSMutableArray *fu;
-(void)logContact:(id)person;
-(void)logGroups:(id)group;
@property(nonatomic,retain)IBOutlet UITableView *ContractTable;
@property(nonatomic,retain)NSMutableArray *list;
-(IBAction)back;
@end
