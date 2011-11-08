//
//  PlaylistDetailController.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MUST     @"Must"
#define EXCLUDE  @"Exclude"
#define OPTIONAL @"Optional"
@class DBOperation;
@interface PlaylistDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    UITableView *listTable;
    UITableViewCell *textFieldCell;
    UITableViewCell *switchCell;
    UITableViewCell *tranCell;
    UITableViewCell *musicCell;
    UILabel *tranLabel;
    UILabel *musicLabel;
    UITextField *textField;
    UISwitch *mySwitch;
    UIImage *selectImg;
    UIImage *unselectImg;
    
    NSMutableArray *userNames;
    UILabel *state;
    BOOL mySwc;
    NSString *listName;
    NSString *a;
    DBOperation *dataBase;

}
@property(nonatomic,retain)IBOutlet UITableView *listTable;
@property(nonatomic,retain)IBOutlet UITableViewCell *textFieldCell;
@property(nonatomic,retain)IBOutlet UITableViewCell *switchCell;
@property(nonatomic,retain)IBOutlet UITableViewCell *tranCell;
@property(nonatomic,retain)IBOutlet UITableViewCell *musicCell;
@property(nonatomic,retain)IBOutlet UILabel *tranLabel;
@property(nonatomic,retain)IBOutlet UILabel *musicLabel;
@property(nonatomic,retain)IBOutlet UITextField *textField;
@property(nonatomic,retain)IBOutlet UISwitch *mySwitch;
@property(nonatomic,retain)IBOutlet UILabel *state;

@property(nonatomic,retain)NSMutableArray *userNames;
@property(nonatomic,assign)BOOL mySwc;
@property(nonatomic,retain)NSString *listName;
@property(nonatomic,retain)NSString *a;
-(IBAction)hideKeyBoard:(id)sender;
-(IBAction)updateTable:(id)sender;
-(IBAction)resetAll;
-(UIButton *)getStateButton;
@end
