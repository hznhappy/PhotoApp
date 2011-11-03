#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "DBOperation.h"
#define UserTable  @"UserTable"
#import "/usr/include/sqlite3.h"
#define idOrder  @"idOrder"
//

//select t.id,orserid from usertable t,idtable where t.id=idtable.id order by orserid asc;

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
    UIToolbar *tools;
    NSMutableArray *pickerViewArray; 
    NSString *idx; 
    NSString *id1;
    IBOutlet UITableView *tableView;
    UIPickerView *myPickerView;
    BOOL bool1;
    UIBarButtonItem *editButton;
}
@property(nonatomic,retain)IBOutlet UITableView *tableView; 
@property (nonatomic, retain)IBOutlet UIPickerView *myPickerView;
@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property(nonatomic,retain)IBOutlet UIToolbar *toolBar;
@property(nonatomic,retain)UIButton *button;
@property(nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)UIToolbar *tools;
-(IBAction)toggleEdit:(id)sender;
-(IBAction)toggleAdd:(id)sender;
-(IBAction) ButtonPressed;
@end
