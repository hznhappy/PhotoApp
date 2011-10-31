#import "DeleteMeController.h"
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"
#import "DBOperation.h"
#import "User.h"
@implementation DeleteMeController
@synthesize myPickerView,  pickerViewArray;
@synthesize list;
@synthesize button;
@synthesize toolBar;
//@synthesize d;
@synthesize tableView,tools;
int j=1,count=0;
-(IBAction) ButtonPressed
{
    
    da=[[DBOperation alloc]init];
    [da openDB];
    [da createTable1];
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
	    //alert.backgroundColor=[UIColor orangeColor];
    //[alert setBackgroundColor:[UIColor orangeColor]];

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
	NSString *insertUser2 = [NSString stringWithFormat:@"UPDATE %@ SET COLOR='%@' WHERE ID='%@'",TableName1,fcolor,[list objectAtIndex:new]];
	NSLog(@"%@",insertUser2);
	[da insertToTable:insertUser2];
    [da closeDB];
    [self viewDidLoad];
    [self.tableView reloadData];
    
}


-(IBAction)toggleAdd:(id)sender
{ 
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    addSign = YES;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release]; 
   
} 
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
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
        NSString *insertUsername = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,NAME,COLOR) VALUES(%d,'%@','%@')",TableName1,[fid intValue],fname,@"whiteColor"];
        NSLog(@"%@",insertUsername);
        [da insertToTable:insertUsername];
        
        
        NSString *insertUser = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",TableName2,[fid intValue]];
        NSLog(@"%@",insertUser);
        [da insertToTable:insertUser];   
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

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||
 interfaceOrientation==UIInterfaceOrientationLandscapeRight);
 }*/
-(void)viewDidLoad
{       
    
    addSign = NO;
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
    [da createTable2];
    [da createTable1];
    NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM idTable"];
    NSLog(@"%@",countSQL);  
    [da selectFromTable2:countSQL];
    self.list=da.ary;
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
-(void)viewWillAppear:(BOOL)animated
{
    addSign = NO;
    self.tools.alpha = 1;
    tools.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (!addSign) {
        self.tools.alpha = 0;
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
{   
    tools=nil;
    toolBar=nil;
    myPickerView=nil;
    tableView=nil;
    da=nil;
    pickerViewArray=nil;
	list=nil;
    button=nil;
	[super viewDidUnload];
	
}

-(void)dealloc
{   
    [editButton release];
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
    [da createTable1];  
    User *user1 = [da getUser:[[list objectAtIndex:indexPath.row]intValue]];
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
                             //myPickerView.frame = CGRectMake(0, 210, 310, 180);
                             myPickerView.alpha = 1;
                             toolBar.alpha=1;
                         }];
        
        
    }
	
	if(j%2==0)
	{   //self.myPickerView.hidden = YES;
        [UIView animateWithDuration:0.8 
                         animations:^{
                             //myPickerView.frame = CGRectMake(0, 210, 310,180);
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
    
    // NSLog(@"%@",[list objectAtIndex:indexPath.row]);
    id1=[NSString stringWithFormat:@"%d",indexPath.row]; 
    [id1 retain];
    da=[[DBOperation alloc]init];
    [da openDB];
    [da createTAG];
    NSString *selectSql1 = [NSString stringWithFormat:@"select * from tag"];
    [da selectFromTAG:selectSql1];
    NSMutableArray *listid1=[NSMutableArray arrayWithCapacity:100];
    listid1=da.tagary;
    if([listid1 containsObject:[list objectAtIndex:indexPath.row]])
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"你好" message:@"此人已作为照片标记使用,是否确定要删除" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        [alert1 addButtonWithTitle:@"YES"];
        [alert1 show];
        [alert1 release];
        
    }
    else
    {
        NSString *countSQL2 = [NSString stringWithFormat:@"DELETE FROM idTable WHERE ID='%@'",[self.list objectAtIndex:indexPath.row]];
        NSLog(@"%@",countSQL2);
        [da deleteDB:countSQL2];  
        NSString *countSQL = [NSString stringWithFormat:@"DELETE FROM UserTable WHERE ID='%@'",[self.list objectAtIndex:indexPath.row]];
        [da deleteDB:countSQL];
        [self viewDidLoad];
        [self.tableView reloadData];
        editButton.title = @"Done";
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
            NSString *countSQL1 = [NSString stringWithFormat:@"DELETE FROM idTable WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            NSLog(@"%@",countSQL1);
            [da deleteDB:countSQL1];  
            NSString *countSQL2 = [NSString stringWithFormat:@"DELETE FROM UserTable WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            [da deleteDB:countSQL2];
            NSString *countSQL3 = [NSString stringWithFormat:@"DELETE FROM TAG WHERE ID='%@'",[list objectAtIndex:[id1 intValue]]];
            [da deleteDB:countSQL3];
            [da closeDB];
            [self viewDidLoad];
            [self.tableView reloadData];
            editButton.title = @"Done";
            
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
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
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
    [da createTable2];
    NSString *insertUser1 = [NSString stringWithFormat:@"DELETE FROM idTable"];	
	NSLog(@"%@",insertUser1);
    [da deleteDB:insertUser1];
    for(int p=0;p<[list count];p++){
        NSString *insertUser = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES(%d)",TableName2,[[list objectAtIndex:p]intValue]];
        NSLog(@"%@",insertUser);
        [da insertToTable:insertUser];    
	}
    [da closeDB];
} 

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return 0;
}
@end
