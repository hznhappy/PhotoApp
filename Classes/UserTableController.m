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
@synthesize tableView,list,tools;

-(void)viewWillAppear:(BOOL)animated
{
    self.tools.alpha = 1;
    tools.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tools.alpha = 0;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
}

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
    [da createTable3];
    NSString *selectPlay = [NSString stringWithFormat:@"select * from PlayTable"];
    [da selectFromTable3:selectPlay];
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
    //[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    editButton.title = @"Done";
    [self.tableView reloadData];
    
}
- (void)dealloc {
    [list release];
    [super dealloc];
}
@end
