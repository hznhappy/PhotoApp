#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "DBOperation.h"
#define TableName1  @"UserTable"
#import "/usr/include/sqlite3.h"
#define TableName2  @"idTable"



@interface DeleteMeController :UIViewController <UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource> 

{
    NSString *fid;
    NSString *fname;
    NSString *fcolor;
    DBOperation *da;
    NSString *num;
    NSString *selected;	
	UIButton *button;
	sqlite3 *db;	
	NSMutableArray *list;
    UIToolbar *toolBar;
    UIPickerView		*myPickerView; 
    NSMutableArray			*pickerViewArray; 
    DeleteMeController *d;
    NSString *idx; 
    NSString *id1;
    IBOutlet UITableView *tableView;
}
@property(nonatomic,retain)IBOutlet UITableView *tableView; 
@property(nonatomic,retain)NSMutableDictionary *content;
@property(nonatomic,retain)NSArray *keys;
@property(nonatomic,retain)NSString *fcolor;
@property(nonatomic,retain)NSString *fid;
@property(nonatomic,retain)NSString *fname;
@property (nonatomic, retain) UIPickerView *myPickerView;
@property (nonatomic,retain)DeleteMeController *d;
@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property (nonatomic,retain)UIToolbar *toolBar;
@property (nonatomic,retain) NSString *selected;
@property (nonatomic,retain)NSString *num;
@property(nonatomic,retain)UIButton *button;
@property(nonatomic,retain)NSString *idx;
@property(nonatomic,retain)NSString *id1;
@property(nonatomic,retain)NSMutableArray *list;
@end
