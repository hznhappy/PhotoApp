//
//  PlaylistDetailController.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#define MUST     @"Must"
#define EXCLUDE  @"Exclude"
#define OPTIONAL @"Optional"
#define Rules    @"Rules"
@class DBOperation;
@interface PlaylistDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource,MPMediaPickerControllerDelegate> {
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
    NSMutableArray *selectedIndexPaths;
    UILabel *state;
    BOOL mySwc;
    NSString *listName;
    NSString *a;
    DBOperation *dataBase;
    NSMutableArray *playrules_idList;
    NSMutableArray *playIdList;
    NSMutableArray *orderList;
    UIButton *stateButton;
    int key;
    NSMutableArray *photos;
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
@property(nonatomic,retain)NSMutableArray *photos;
@property(nonatomic,retain)NSMutableArray *selectedIndexPaths;
@property(nonatomic,retain)NSMutableArray *userNames;
@property(nonatomic,assign)BOOL mySwc;
@property(nonatomic,retain)NSString *listName;
@property(nonatomic,retain)NSString *a;
@property(nonatomic,retain)NSMutableArray *playrules_idList;
@property(nonatomic,retain)NSMutableArray *playIdList;
@property(nonatomic,retain)NSMutableArray *orderList;
@property(nonatomic,retain)UIButton *stateButton;
-(IBAction)hideKeyBoard:(id)sender;
-(IBAction)updateTable:(id)sender;
-(IBAction)resetAll;
-(UIButton *)getStateButton;
//-(IBAction)save;
-(void)insert:(NSInteger)Row playId:(int)playId;
-(void)deletes:(NSInteger)Row playId:(int)playId;
-(void)creatTable;
-(void)update:(NSInteger)Row rule:(int)rule playId:(int)playId;
-(void)international;
@end
