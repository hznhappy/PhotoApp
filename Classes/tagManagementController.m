#import "tagManagementController.h"
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"
#import "DBOperation.h"
#import "AssetTablePicker.h"
@implementation tagManagementController
@synthesize list;
@synthesize button;
@synthesize tableView,tools,bo;
int j=1,count=0;


-(void)viewDidLoad
{       
    bool1 = NO;
    
   	NSLog(@"tonzghi");
    
    if(bo!=nil)
    {  
        [self creatButton];
    }
    if(bo==nil)
    {
        [self creatButton1];
    }
    da=[DBOperation getInstance];
    [self creatTable];
    [self nobody];
    count = [list count];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table) name:@"add" object:nil];
	[super viewDidLoad];
   	
}
-(void)creatButton
{
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    tools = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 100,45)];
    tools.barStyle = UIBarStyleBlack;
    NSString *a=NSLocalizedString(@"Back", @"button");
    NSString *b=NSLocalizedString(@"Edit", @"button");
    UIBarButtonItem *BackButton=[[UIBarButtonItem alloc]initWithTitle:a style:UIBarButtonItemStyleBordered target:self action:@selector(toggleback)];
    self.navigationItem.leftBarButtonItem=BackButton;
    UIBarButtonItem *addButon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toggleAdd:)];
    editButton = [[UIBarButtonItem alloc] initWithTitle:b style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
    addButon.style = UIBarButtonItemStyleBordered;
    editButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:editButton];
    [buttons addObject:addButon];
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = myBtn;
    [myBtn release];
    [editButton release];
    [BackButton release];
    [addButon release];
    [buttons release];
    [tools release];
    
}
-(void)creatButton1
{
    NSString *b=NSLocalizedString(@"Edit", @"button");
    UIBarButtonItem *addButon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toggleAdd:)];
    editButton = [[UIBarButtonItem alloc] initWithTitle:b style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
    addButon.style = UIBarButtonItemStyleBordered;
    editButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = addButon;
    self.navigationItem.leftBarButtonItem = editButton;
    [addButon release];
    [editButton release];
    
}
-(void)creatTable
{
   
    NSString *createUserTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY,NAME)",UserTable];
    [da createTable:createUserTable];
    NSString *createIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY)",idOrder];//OrderID INTEGER PRIMARY KEY,
    [da createTable:createIdOrder];
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [da createTable:createTag];
    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    self.list=[da selectOrderId:selectIdOrder];
}
-(void)nobody
{
    
    NSString *selectIdOrder1=[NSString stringWithFormat:@"select id from idOrder where id=0"];
   NSMutableArray *IDList=[da selectOrderId:selectIdOrder1];
    if([IDList count]==0)
    {
        NSString *insertUserTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,NAME) VALUES(%d,'%@')",UserTable,0,@"NoBody"];
        NSLog(@"%@",insertUserTable);
        [da insertToTable:insertUserTable];
        NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",idOrder,0];
        NSLog(@"%@",insertIdOrder);
        [da insertToTable:insertIdOrder];

    }
    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    self.list=[da selectOrderId:selectIdOrder];

}
-(IBAction)toggleAdd:(id)sender
{  bool1=YES;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release]; 
} 
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{

       NSString *readName=(NSString *)ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
    
    NSLog(@"%@",readName);
    NSLog(@"%d",recId);
    fid=[NSString stringWithFormat:@"%d",recId];
    fname=[NSString stringWithFormat:@"%@",readName];
    if([list containsObject:fid])
    {
        NSString *b=NSLocalizedString(@"Already exists", @"button");
        NSString *a=NSLocalizedString(@"note", @"button");
         NSString *c=NSLocalizedString(@"ok", @"button");
            
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:a
                              message:b
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:c,nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString *insertUserTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,NAME) VALUES(%d,'%@')",UserTable,[fid intValue],fname];
        NSLog(@"%@",insertUserTable);
        [da insertToTable:insertUserTable];
        
        
        NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",idOrder,[fid intValue]];
        NSLog(@"%@",insertIdOrder);
        [da insertToTable:insertIdOrder];   
        [self table];
        
    }
    [readName release];
    
    [self dismissModalViewControllerAnimated:YES];
    return NO;
    
	
}

-(IBAction)toggleEdit:(id)sender
{ NSString *a=NSLocalizedString(@"Edit", @"title");
     NSString *b=NSLocalizedString(@"Done", @"title");
    if (self.tableView.editing) {
        editButton.title = a;
    }else{
        editButton.title = b;
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
}
-(void)toggleback
{
    [self dismissModalViewControllerAnimated:YES];
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
{
    self.tableView=nil;
    da=nil;
	self.list=nil;
    self.button=nil;
	[super viewDidUnload];
	
}

-(void)dealloc
{   
    [bo release];
    [button release];
    [tableView release];
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
      
        if([[self.list objectAtIndex:indexPath.row]intValue]==0)
    {
        cell.textLabel.textColor=[UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
    }
    cell.textLabel.text =[da getUserFromUserTable:[[list objectAtIndex:indexPath.row]intValue]];
       //[NSString stringWithFormat:@"%@",da.name];

    
    return cell; 
}
#pragma mark -
#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{	
    id1=[NSString stringWithFormat:@"%d",indexPath.row]; 
    [id1 retain];
     
    NSString *selectTag= [NSString stringWithFormat:@"select ID from tag"];
    
    NSMutableArray *listid1=[da selectFromTAG:selectTag];
    if([[self.list objectAtIndex:indexPath.row]intValue]==0)
    {
        NSString *a=NSLocalizedString(@"hello", @"title");
        NSString *b=NSLocalizedString(@"Inherent members, can not be deleted", @"title");
        NSString *c=NSLocalizedString(@"ok", @"title");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:a message:b delegate:self cancelButtonTitle:c otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
    if([listid1 containsObject:[list objectAtIndex:indexPath.row]])
    {
        NSString *a=NSLocalizedString(@"hello", @"title");
        NSString *b=NSLocalizedString(@"This person has been used as a photo tag, you sure you want to delete it", @"title");
        NSString *c=NSLocalizedString(@"NO", @"title");
        NSString *d=NSLocalizedString(@"YES", @"title");

        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:a message:b delegate:self cancelButtonTitle:c otherButtonTitles:nil];
        [alert1 addButtonWithTitle:d];
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
  }
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString *name=[da getUserFromUserTable:[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@" UserName : %@",name);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[self.list objectAtIndex:indexPath.row],@"UserId",name,@"UserName",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddUser" 
                                                       object:self 
                                                     userInfo:dic];

     [self dismissModalViewControllerAnimated:YES];
    [table deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)alertView:(UIAlertView *)alert1 didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            NSLog(@"OB");
            NSString *deleteIdTable= [NSString stringWithFormat:@"DELETE FROM idOrder WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            NSLog(@"%@",deleteIdTable);
            [da deleteDB:deleteIdTable];  
            NSString *deleteUserTable= [NSString stringWithFormat:@"DELETE FROM UserTable WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            [da deleteDB:deleteUserTable];
            NSString *deleteTag= [NSString stringWithFormat:@"DELETE FROM TAG WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            [da deleteDB:deleteTag];
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
    NSString *deleteIdTable= [NSString stringWithFormat:@"DELETE FROM idOrder"];	
	NSLog(@"%@",deleteIdTable);
    [da deleteDB:deleteIdTable];
    for(int p=0;p<[list count];p++){
        NSString *insertIdTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",idOrder,[[list objectAtIndex:p]intValue]];
        NSLog(@"%@",insertIdTable);
        [da insertToTable:insertIdTable];    
	}
} 

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return 0;
}
@end
