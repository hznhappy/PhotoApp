#import "DeleteMeController.h"
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"
#import "DBOperation.h"
#import "User.h"
#import "AssetTablePicker.h"
#import "ContactsController.h"
@implementation DeleteMeController
//@synthesize myPickerView,  pickerViewArray;
@synthesize list;
@synthesize button;
//@synthesize toolBar;
@synthesize tableView,tools;
int j=1,count=0;


-(void)viewDidLoad
{       
    bool1 = NO;
    tools = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 100,45)];
    tools.barStyle = UIBarStyleBlack;
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
	
    
    UIBarButtonItem *addButon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toggleAdd:)];
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
    addButon.style = UIBarButtonItemStyleBordered;
    editButton.style = UIBarButtonItemStyleBordered;
	[buttons addObject:editButton];
    [buttons addObject:addButon];
	[tools setItems:buttons animated:NO];
	
	UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
	self.navigationItem.rightBarButtonItem = myBtn;
	[addButon release];
    [buttons release];
    [self creatTable];
    [self nobody];
    	[tools release];
       NSLog(@"xunshu%@",da.orderIdList);
    count = [list count];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table) name:@"add" object:nil];
	[super viewDidLoad];
   	
}
-(void)creatTable
{
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createUserTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY,NAME,COLOR)",UserTable];
    [da createTable:createUserTable];
    NSString *createIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT)",idOrder];//OrderID INTEGER PRIMARY KEY,
    [da createTable:createIdOrder];
    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    [da selectOrderId:selectIdOrder];
    self.list=da.orderIdList;

    [da closeDB];
    }
-(void)nobody
{
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *selectIdOrder1=[NSString stringWithFormat:@"select id from idOrder where id=0"];
    [da selectOrderId:selectIdOrder1];
    if([da.orderIdList count]!=0)
    {
        NSLog(@"DER");
    }
    else
    {
        NSLog(@"no");
        
        NSString *insertUserTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,NAME) VALUES(%d,'%@')",UserTable,0,@"NoBody"];
        NSLog(@"%@",insertUserTable);
        [da insertToTable:insertUserTable];
        
        
        NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",idOrder,0];
        NSLog(@"%@",insertIdOrder);
        [da insertToTable:insertIdOrder];
        
    }
    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    [da selectOrderId:selectIdOrder];
    self.list=da.orderIdList;
    
    [da closeDB];

}
-(NSString*)databasePath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *pathname = [path objectAtIndex:0];
	return [pathname stringByAppendingPathComponent:@"data.db"];
}
-(IBAction)toggleAdd:(id)sender
{   bool1=YES;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release]; 
    //ContactsController * c=[[ContactsController alloc]init];
   // [self.navigationController pushViewController:c animated:YES];
    //[self presentModalViewController:c animated:YES];
    
   } 
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{ da=[[DBOperation alloc]init];
    [da openDB];

       NSString *readName=(NSString *)ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
    
    NSLog(@"%@",readName);
    NSLog(@"%d",recId);
    fid=[NSString stringWithFormat:@"%d",recId];
    fname=[NSString stringWithFormat:@"%@",readName];
    if([list containsObject:fid])
    {
        NSString *message=[[NSString alloc] initWithFormat:
                           @"已经存在"];
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:message
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"确定!",nil];
        [alert show];
        [alert release];
        [message release];
    }
    else
    {
        NSString *insertUserTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,NAME,COLOR) VALUES(%d,'%@','%@')",UserTable,[fid intValue],fname,@"whiteColor"];
        NSLog(@"%@",insertUserTable);
        [da insertToTable:insertUserTable];
        
        
        NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",idOrder,[fid intValue]];
        NSLog(@"%@",insertIdOrder);
        [da insertToTable:insertIdOrder];   
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"add" 
                                                           object:self 
                                                         userInfo:dic1];
        
    }
    [readName release];
    
    [da closeDB];
    [self dismissModalViewControllerAnimated:YES];
    return NO;
    
	
}

-(IBAction)toggleEdit:(id)sender
{
    if (self.tableView.editing) {
        editButton.title = @"Edit";
    }else{
        editButton.title = @"Done";
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
         bool1=NO;
    tools.alpha=1;
    tools.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;    
}
-(void)viewWillDisappear:(BOOL)animated
{   if(bool1==NO)
{
    tools.alpha=0;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
  
} 
}
-(void)table
{
    [self creatTable];
    [self.tableView reloadData];
}
- (void)viewDidUnload
{   //self.toolBar=nil;
    //self.myPickerView=nil;
    self.tableView=nil;
    da=nil;
    //self.pickerViewArray=nil;
	self.list=nil;
    self.button=nil;
	[super viewDidUnload];
	
}

-(void)dealloc
{   
   // [toolBar release];
    [button release];
    [tableView release];
   // [myPickerView release];
    [da release];
    //[pickerViewArray release];
	[list release];
	[super dealloc];
	
}
-(id)initWithDelegate:(id)delegate
{
	if (self==[super init]) {
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return[list count];
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
		
	}
    da=[[DBOperation alloc]init];
    [da openDB];
    User *user1 = [da getUserFromUserTable:[[list objectAtIndex:indexPath.row]intValue]];
    if([user1.id intValue]==0)
    {
        cell.textLabel.textColor=[UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
        

    }
	cell.textLabel.text = [NSString stringWithFormat:@"%@",user1.name];
    [da closeDB];
    return cell; 
    [user1 release];
    
}
#pragma mark -
#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{	
    id1=[NSString stringWithFormat:@"%d",indexPath.row]; 
    [id1 retain];
    da=[[DBOperation alloc]init];
    [da openDB];
     NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [da createTable:createTag];
    NSString *selectTag= [NSString stringWithFormat:@"select * from tag"];
    [da selectFromTAG:selectTag];
    NSMutableArray *listid1=da.tagIdAry;
    if([[self.list objectAtIndex:indexPath.row]intValue]==0)
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"你好" message:@"固有成员,无法删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert1 show];
        [alert1 release];
    }
    else
    {
    if([listid1 containsObject:[list objectAtIndex:indexPath.row]])
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"你好" message:@"此人已作为照片标记使用,是否确定要删除" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        [alert1 addButtonWithTitle:@"YES"];
        [alert1 show];
        [alert1 release];
        
    }
    else
    {
        NSString *deleteIdTable = [NSString stringWithFormat:@"DELETE FROM idOrder WHERE ID='%@'",[self.list objectAtIndex:indexPath.row]];
        NSLog(@"%@",deleteIdTable );
        [da deleteDB:deleteIdTable ];  
        NSString *DeleteUserTable= [NSString stringWithFormat:@"DELETE FROM UserTable WHERE ID='%@'",[self.list objectAtIndex:indexPath.row]];
        [da deleteDB:DeleteUserTable];
        [self creatTable];
        [self.tableView reloadData];
    }
    }
    //[listid1 release];
    [da closeDB];
    
    
}
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)alertView:(UIAlertView *)alert1 didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            NSLog(@"OB");
            da=[[DBOperation alloc]init];
            [da openDB];
            NSString *deleteIdTable= [NSString stringWithFormat:@"DELETE FROM idOrder WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            NSLog(@"%@",deleteIdTable);
            [da deleteDB:deleteIdTable];  
            NSString *deleteUserTable= [NSString stringWithFormat:@"DELETE FROM UserTable WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            [da deleteDB:deleteUserTable];
            NSString *deleteTag= [NSString stringWithFormat:@"DELETE FROM TAG WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            [da deleteDB:deleteTag];
            [da closeDB];
            [self viewDidLoad];
            [self.tableView reloadData];            
            break;
        case 0:
            [self.tableView reloadData];
            break;
    }
    
    
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[self dismissModalViewControllerAnimated:YES];
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    
    NSUInteger fromRow=[fromIndexPath row];
	NSUInteger toRow=[toIndexPath row];
	id object=[[list objectAtIndex:fromRow]retain];
	[list removeObjectAtIndex:fromRow];
	[list insertObject:object atIndex:toRow];
	[object release];
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *deleteIdTable= [NSString stringWithFormat:@"DELETE FROM idOrder"];	
	NSLog(@"%@",deleteIdTable);
    [da deleteDB:deleteIdTable];
    for(int p=0;p<[list count];p++){
        NSString *insertIdTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",idOrder,[[list objectAtIndex:p]intValue]];
        NSLog(@"%@",insertIdTable);
        [da insertToTable:insertIdTable];    
	}
    [da closeDB];
} 

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return 0;
}
@end
