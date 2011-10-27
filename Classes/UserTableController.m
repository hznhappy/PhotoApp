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
@synthesize tableView,list;
-(void)viewDidLoad
{
   // NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:@"play1",@"play2",@"play3",@"play4",nil];
    
    //self.list=arr;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	UIBarButtonItem *editButton=[[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleAdd:) ];
	self.navigationItem.rightBarButtonItem=editButton;
    [editButton release];
    UIToolbar* tools = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 120,45)];
    tools.barStyle = UIBarStyleBlackTranslucent;
	[tools setTintColor:[self.navigationController.navigationBar tintColor]];
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UITabBarSystemItemContacts  target:self action:@selector(toggleback:)];
	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
	[buttons addObject:anotherButton];
	[anotherButton release];
	[buttons addObject:anotherButton1];
	[anotherButton1 release];
	[tools setItems:buttons animated:NO];
	[buttons release];
	UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
	self.navigationItem.leftBarButtonItem = myBtn;
	da=[[DBOperation alloc]init];
    [da openDB];
    [da createTable3];
    NSString *selectPlay = [NSString stringWithFormat:@"select * from PlayTable"];
    [da selectFromTable3:selectPlay];
    self.list=da.playary;

	[myBtn release];
	[tools release];
    [da closeDB];
	[super viewDidLoad];
    
    
}
-(IBAction)toggleEdit:(id)sender
{
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
    [da createTable3];
    User *user3 = [da getUser3:[list objectAtIndex:indexPath.row]];
    [cell.textLabel setNumberOfLines:10];
    cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
    NSLog(@"%@",user3.name);
    cell.textLabel.text=user3.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [da closeDB];
    return cell;
}
-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"listTitle"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SetTitle" object:self userInfo:dic];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [da openDB];
    User *user3 = [da getUser3:[list objectAtIndex:indexPath.row]];
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
    [self.parentViewController dismissModalViewControllerAnimated:YES];    
}
#pragma mark -
#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{   [da openDB];
    [da createTable3];
    NSString *countSQL = [NSString stringWithFormat:@"DELETE FROM PlayTable WHERE Name='%@'",[list objectAtIndex:indexPath.row]];
    NSLog(@"%@",countSQL);
    [da deleteDB:countSQL];  
    [da closeDB];
    [self viewDidLoad];
    [self.tableView reloadData];
    
}
- (void)dealloc {
    [list release];
    [super dealloc];
}
@end
