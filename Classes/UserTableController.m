//
//  UserTableController.m
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "UserTableController.h"
#import "TextController.h"
@implementation UserTableController
@synthesize tableView,list,tools,withlist,withoutlist;
-(void)viewDidLoad
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
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
    [editButton release];
    [buttons release];
	da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createSQL3= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createSQL3];
    NSString *selectPlay = [NSString stringWithFormat:@"select * from PlayTable"];
    [da selectFromPlayTable:selectPlay];
    self.list=da.playary;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table1) name:@"addplay" object:nil];
	[myBtn release];
	[tools release];
    [da closeDB];
	[super viewDidLoad];
    
    
}
-(void)table1
{
    [self viewDidLoad];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    tools.alpha=1;
    tools.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
}
-(void)viewWillDisappear:(BOOL)animated
{       tools.alpha=0;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
 
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

-(IBAction)toggleAdd:(id)sender
{
    TextController *ts=[[TextController alloc]init];
	[self.navigationController pushViewController:ts animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return[self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    da=[[DBOperation alloc]init];
    [da openDB];
     NSString *createSQL3= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createSQL3];
    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",[list objectAtIndex:indexPath.row]);
    [cell.textLabel setNumberOfLines:10];
    cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
    cell.textLabel.text=[NSString stringWithFormat:@"%@",user3.name];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [da closeDB];
    return cell;
}
-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"listTitle"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SetTitle" object:self userInfo:dic];
    for(int i=0;i<[withlist count];i++)
    {
        NSString *countSQL = [NSString stringWithFormat:@"select * FROM TAG WHERE NAME='%@'",[list objectAtIndex:indexPath.row]];
        [da selectFromTAG:countSQL];
        NSMutableArray *pid;
        pid=da.tagary;
        
    }
    [da closeDB];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [da openDB];
    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
    TextController *ts=[[TextController alloc]init];
    ts.str1 = user3.name;
    ts.str2 = user3.with;
    ts.str3 =user3.without; 
    [da closeDB];
    
	[self.navigationController pushViewController:ts animated:YES];
}
-(IBAction)toggleback:(id)sender
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{   [da openDB];
    NSString *createSQL3= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createSQL3];
    NSString *countSQL = [NSString stringWithFormat:@"DELETE FROM PlayTable WHERE playList_id=%d",[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",countSQL);
    [da deleteDB:countSQL];  
    [da closeDB];
    [self viewDidLoad];
    [self.tableView reloadData];
    
}
- (void)dealloc {
    [tableView release];
    [list release];
    [super dealloc];
}
@end
