#import "DeleteMeController.h"
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"
#import "DBOperation.h"
#import "User.h"
#import "AssetTablePicker.h"
@implementation DeleteMeController
@synthesize myPickerView,  pickerViewArray;
@synthesize list;
@synthesize button;
@synthesize toolBar;
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
    
	[tools release];
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createUserTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY,NAME,COLOR)",UserTable];
    [da createTable:createUserTable];
    NSString *createIdTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT)",idOrder];//OrderID INTEGER PRIMARY KEY,
    [da createTable:createIdTable];
    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    [da selectOrderId:selectIdOrder];
    self.list=da.orderIdList;
    NSLog(@"xunshu%@",da.orderIdList);
    count = [list count];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:@"redColor",@"yellowColor",@"greenColor",@"grayColor",@"whiteColor",@"blueColor",nil];
    self.pickerViewArray=arr;
    [da closeDB];
    [arr release];
    myPickerView.hidden = YES;
    toolBar.hidden =YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table) name:@"add" object:nil];
	[super viewDidLoad];
   	
}

-(IBAction) ButtonPressed
{
    
    da=[[DBOperation alloc]init];
    [da openDB];
    NSInteger row=[myPickerView selectedRowInComponent:0];
    fcolor=[pickerViewArray objectAtIndex:row]; 
	
    
    
    
    NSString *message=[[NSString alloc] initWithFormat:
					   @"选取的是：%@!",fcolor];
	
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"提示"
						  message:message
						  delegate:self
						  cancelButtonTitle:nil
						  otherButtonTitles:@"确定!",nil];
    [alert show];
	[alert release];
    
	[message release];
    
    [UIView animateWithDuration:0.8 
                     animations:^{
                         //myPickerView.frame = CGRectMake(0, 210, 310,180);
                         myPickerView.alpha = 0;
                         toolBar.alpha=0;
                     }];
    j=j+1;
    
    
    
    num=idx;
    int new=[num intValue];
    // new=new+1;
    NSLog(@"%d",new);
    NSLog(@"%@",fcolor);
	NSString *updateUserTable= [NSString stringWithFormat:@"UPDATE %@ SET COLOR='%@' WHERE ID='%@'",UserTable,fcolor,[list objectAtIndex:new]];
	NSLog(@"%@",updateUserTable);
	[da insertToTable:updateUserTable];
    [da closeDB];
    [self viewDidLoad];
    [self.tableView reloadData];
    
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
   } 
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
    da=[[DBOperation alloc]init];
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
        
        
        NSString *insertIdTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",idOrder,[fid intValue]];
        NSLog(@"%@",insertIdTable);
        [da insertToTable:insertIdTable];   
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"add" 
                                                           object:self 
                                                         userInfo:dic1];
        
    }
    
    
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
    [self viewDidLoad];
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark UIPickerViewDataSource
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)] autorelease];
    
    [label setText:[pickerViewArray objectAtIndex:row]];
    [label setTextAlignment:UITextAlignmentCenter];
    return label;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (void)viewDidUnload
{   self.toolBar=nil;
    self.myPickerView=nil;
    self.tableView=nil;
    da=nil;
    self.pickerViewArray=nil;
	self.list=nil;
    self.button=nil;
	[super viewDidUnload];
	
}

-(void)dealloc
{   
    [toolBar release];
    [button release];
    [tableView release];
    [myPickerView release];
    [da release];
    [pickerViewArray release];
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
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Class theClass = NSClassFromString(@"UIGlassButton");
    button = [[theClass alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [button addTarget:self action:@selector(btnClicked:event:)forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"color" forState:UIControlStateNormal];
    
    
    cell.accessoryView=button;           
    [button setValue:[UIColor whiteColor] forKey:@"tintColor"];  
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createUserTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY,NAME,COLOR)",UserTable];
    [da createTable:createUserTable];
    User *user1 = [da getUserFromUserTable:[[list objectAtIndex:indexPath.row]intValue]];
	cell.textLabel.text = [NSString stringWithFormat:@"%@",user1.name];
    if([user1.color isEqualToString:@"greenColor"])
        [button setValue:[UIColor greenColor] forKey:@"tintColor"];
    else if([user1.color isEqualToString:@"redColor"])
        [button setValue:[UIColor redColor] forKey:@"tintColor"];
    else if([user1.color isEqualToString:@"grayColor"])
        [button setValue:[UIColor grayColor] forKey:@"tintColor"];
    else if([user1.color isEqualToString:@"yellowColor"])
        [button setValue:[UIColor yellowColor] forKey:@"tintColor"];
    else if([user1.color isEqualToString:@"whiteColor"])
        [button setValue:[UIColor whiteColor] forKey:@"tintColor"];
    else if([user1.color isEqualToString:@"blueColor"])
        [button setValue:[UIColor blueColor] forKey:@"tintColor"];  
    [da closeDB];
    
	return cell; 
    [user1 release];
    
}

-( void )tableView:( UITableView *) table accessoryButtonTappedForRowWithIndexPath:( NSIndexPath *)indexPath{
    idx=[NSString stringWithFormat:@"%d",indexPath.row]; 
    [idx retain];
    if(j%2!=0)
    {       // myPickerView.frame =CGRectMake(0, 200, 310, 180);
        self.myPickerView.hidden = NO;
        toolBar.hidden = NO;
        [UIView animateWithDuration:0.8 
                         animations:^{
                             myPickerView.alpha = 1;
                             toolBar.alpha=1;
                         }];
        
        
    }
	
	if(j%2==0)
	{   //self.myPickerView.hidden = YES;
        [UIView animateWithDuration:0.8 
                         animations:^{
                             myPickerView.alpha = 0;
                             toolBar.alpha=0;
                         }];
	}
	j++;
	
    
}
- ( void )btnClicked:( id )sender event:( id )event

{
    
    NSSet *touches = [event allTouches ];
    
    UITouch *touch = [touches anyObject ];
    
    CGPoint currentTouchPosition = [touch locationInView:self.tableView ];
    
    NSIndexPath *indexPath = [ self.tableView indexPathForRowAtPoint : currentTouchPosition];
    
    if (indexPath!= nil )
        
    {
        
        [ self tableView :self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
	
	
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
    NSMutableArray *listid1=[NSMutableArray arrayWithCapacity:100];
    listid1=da.tagIdAry;
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
        [self viewDidLoad];
        [self.tableView reloadData];
    }
    
    
    [da closeDB];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)alertView:(UIAlertView *)alert1 didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            
            
            int i=[id1 intValue];
            
            
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
            NSLog(@"%d",[id1 intValue]);
            NSLog(@"www%d",i);
            NSLog(@"cance");
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
