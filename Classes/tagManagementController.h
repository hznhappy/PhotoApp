#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "DBOperation.h"
#define UserTable  @"UserTable"
#import "/usr/include/sqlite3.h"
#define idOrder  @"idOrder"
//

//select t.id,orserid from usertable t,idtable where t.id=idtable.id order by orserid asc;

@interface tagManagementController :UIViewController <UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate>

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
    UIToolbar *tools;
    NSString *idx; 
    NSString *id1;
    UITableView *tableView;
    BOOL bool1;
    UIBarButtonItem *editButton;
}
@property(nonatomic,retain)IBOutlet UITableView *tableView; 
@property(nonatomic,retain)UIButton *button;
@property(nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)UIToolbar *tools;
-(IBAction)toggleEdit:(id)sender;
-(IBAction)toggleAdd:(id)sender;
-(void)creatTable;
-(void)nobody;
@end
