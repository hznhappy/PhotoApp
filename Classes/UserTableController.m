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
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createPlayTable];
    NSString *createPlayIdTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [da createTable:createPlayIdTable];
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select id from playIdTable"];
    [da selectOrderId:selectPlayIdOrder];
    NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
    [da selectFromPlayTable:selectPlayTable];
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [da createTable:createRules];
    self.list=da.playIdAry;
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
    da=[[DBOperation alloc]init];
    [da openDB];
    [da selectFromRulesAndTag:[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",da.playlistUrl);
    [da closeDB];
   // select t.url,t.id from tag t,rules r where r.playlist_id=4 and r.user_id=t.id and r.playlist_rules=1 and t.url not in (select t2.url from tag t2,rules r2 where r2.playlist_id=4 and r2.playlist_rules=0 and r2.user_id=t2.id);

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [da openDB];
    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
    TextController *ts=[[TextController alloc]init];
    ts.str1 = user3.name;
    NSLog(@"re%d",[[list objectAtIndex:indexPath.row]intValue]);
    NSString *selectRulesIn = [NSString stringWithFormat:@"select user_name from Rules where playList_id=%d and playList_rules=%d",[[list objectAtIndex:indexPath.row]intValue],1];
    [da selectNameFromRules:selectRulesIn];
    NSLog(@"%@",da.playlist_name);
    for(int i=0;i<[da.playlist_name count];i++)
    {
        if(ts.str2==nil||ts.str2.length==0)
        {
            
            ts.str2=[da.playlist_name objectAtIndex:i];
        }
        else
        {  ts.str2=[ts.str2 stringByAppendingString:@","];
            ts.str2=[ts.str2 stringByAppendingString:[da.playlist_name objectAtIndex:i]];
        }
   
    }
    NSString *selectRulesOut= [NSString stringWithFormat:@"select user_name from Rules where playList_id=%d and playList_rules=%d",[[list objectAtIndex:indexPath.row]intValue],0];
    [da selectNameFromRules:selectRulesOut];
    for(int j=0;j<[da.playlist_name count];j++)
    {
        if(ts.str3==nil||ts.str3.length==0)
        {
            
            ts.str3=[da.playlist_name objectAtIndex:j];
        }
        else
        {  ts.str3=[ts.str3 stringByAppendingString:@","];
            ts.str3=[ts.str3 stringByAppendingString:[da.playlist_name objectAtIndex:j]];
        }
    }
    [da closeDB];
	[self.navigationController pushViewController:ts animated:YES];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[list objectAtIndex:indexPath.row],@"playlist_id",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"edit" 
                                                       object:self 
                                                     userInfo:dic1];
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
    NSString *deletePlayTable = [NSString stringWithFormat:@"DELETE FROM PlayTable WHERE playList_id=%d",[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",deletePlayTable );
    [da deleteDB:deletePlayTable ]; 
    NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playList_id=%d",[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",deleteRules);
    [da deleteDB:deleteRules]; 
    [da closeDB];
    [self viewDidLoad];
    [self.tableView reloadData];
    
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


- (void)dealloc {
    [tableView release];
    [list release];
    [super dealloc];
}
@end
