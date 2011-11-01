//
//  UserTableController.h
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOperation.h"
#define PlayTable @"PlayTable"
@interface UserTableController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tableView;
    NSMutableArray *list;
    DBOperation *da;
    UIToolbar* tools;
    NSMutableArray *withlist;
    NSMutableArray *withoutlist;
    UIBarButtonItem *editButton;
}
@property(nonatomic,retain)IBOutlet UITableView *tableView; 
@property(nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)NSMutableArray *withlist;
@property(nonatomic,retain)NSMutableArray *withoutlist;
@property(nonatomic,retain) UIToolbar* tools;
@end
