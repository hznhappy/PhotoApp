//
//  UserTableController.h
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOperation.h"
#define TableName3 @"PlayTable"
@interface UserTableController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tableView;
    NSMutableArray *list;
    DBOperation *da;
    UIToolbar *tools;
    UIBarButtonItem *editButton;
}
@property(nonatomic,retain)UIToolbar *tools;
@property(nonatomic,retain)IBOutlet UITableView *tableView; 
@property(nonatomic,retain)NSMutableArray *list;
@end
