//
//  PlaylistDetailController.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property(nonatomic,assign)BOOL mySwc;
@property(nonatomic,retain)NSString *listName;
@property(nonatomic,retain)NSString *a;
-(IBAction)hideKeyBoard:(id)sender;
-(IBAction)updateTable:(id)sender;
@end
