//
//  PlaylistDetailController.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistDetailController.h"
#import "TextController.h"
#import "User.h"
#import "DBOperation.h"
#import "AnimaSelectController.h"

@implementation PlaylistDetailController
@synthesize listTable;
@synthesize textFieldCell,switchCell,tranCell,musicCell;
@synthesize tranLabel,musicLabel;
@synthesize textField;
@synthesize mySwitch;
@synthesize listName;
@synthesize mySwc,a;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [musicLabel release];
    [tranLabel release];
    [mySwitch release];
    [textField release];
    [textFieldCell release];
    [switchCell release];
    [tranCell release];
    [musicCell release];
    [listTable release];
    [dataBase release];
    [listName release];
    [a release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{ 
    mySwc = YES;
    dataBase=[[DBOperation alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTransitionAccessoryLabel:) name:@"changeTransitionLabel" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMusicAccessoryLabel:) name:@"changeMusicLabel" object:nil];
    [super viewDidLoad];
}


#pragma mark -
#pragma mark UITableView Delegate method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (mySwc) {
        return 4;
    }
    else{
        return 3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int rowNum=indexPath.row;
    UITableViewCell *cell = nil;
    switch (rowNum) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
            if (cell == nil) {
                cell = self.textFieldCell;
            }
            self.textField.text = listName;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"transitionsCell"];
            if (cell == nil) {
                cell = self.tranCell;
            }
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"playMusicCell"];
            if (cell == nil) {
                cell = self.switchCell;
            }
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell"];
            if (cell == nil) {
                cell = self.musicCell;
            }
            break;
        default:
            cell = nil;
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        AnimaSelectController *animateController = [[AnimaSelectController alloc]init];
        animateController.tranStyle = self.tranLabel.text;
        [self.navigationController pushViewController:animateController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [animateController release];
    }
    [self.textField resignFirstResponder];
}
-(void)creatTable
{
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [dataBase createTable:createPlayTable];
    NSString *createPlayIdTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [dataBase createTable:createPlayIdTable];
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select id from playIdOrder"];
    [dataBase selectOrderId:selectPlayIdOrder];
    
    NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
    [dataBase selectFromPlayTable:selectPlayTable];
    //self.list=da.playIdAry;
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [dataBase createTable:createRules];
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    [dataBase openDB];
    [self creatTable];
    User *user3 = [dataBase getUserFromPlayTable:[a intValue]];
    TextController *ts=[[TextController alloc]init];
    ts.str1 = user3.name;
    NSString *selectRulesIn= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],1];
    [dataBase selectFromRules:selectRulesIn];
    for(int i=0;i<[dataBase.playlist_UserName count];i++)
    {
        if(ts.str2==nil||ts.str2.length==0)
        {
            ts.str2=[dataBase.playlist_UserName objectAtIndex:i];
        }
        else
        {  ts.str2=[ts.str2 stringByAppendingString:@","];
            ts.str2=[ts.str2 stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:i]];
        }
        
    }
    NSString *selectRulesOut= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],0];
    [dataBase selectFromRules:selectRulesOut];
    for(int j=0;j<[dataBase.playlist_UserName count];j++)
    {
        if(ts.str3==nil||ts.str3.length==0)
        {
            
            ts.str3=[dataBase.playlist_UserName objectAtIndex:j];
        }
        else
        {  
            ts.str3=[ts.str3 stringByAppendingString:@","];
            ts.str3=[ts.str3 stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:j]];
        }
    }
    NSString *selectRulesOr= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],2];
    [dataBase selectFromRules:selectRulesOr];
    for(int k=0;k<[dataBase.playlist_UserName count];k++)
    {
        if(ts.str4==nil||ts.str4.length==0)
        {
            
            ts.str4=[dataBase.playlist_UserName objectAtIndex:k];
        }
        else
        {  ts.str4=[ts.str4 stringByAppendingString:@","];
            ts.str4=[ts.str4 stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:k]];
        }
    }

    [dataBase closeDB];
    [self.navigationController pushViewController:ts animated:YES];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:a,@"playlist_id",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"edit" 
                                                       object:self 
                                                     userInfo:dic1];
}
#pragma mark -
#pragma mark IBAction method
-(IBAction)hideKeyBoard:(id)sender{
    [sender resignFirstResponder];
}

-(IBAction)updateTable:(id)sender{
    UISwitch *newSwitcn  = (UISwitch *)sender;
    mySwc = newSwitcn.on;
    if (newSwitcn.on) {
        [listTable beginUpdates];
        [listTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [listTable endUpdates];
    }else{
        [listTable beginUpdates];
        [listTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [listTable endUpdates];
    }
}

#pragma mark -
#pragma mark Notification method
-(void)changeTransitionAccessoryLabel:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    NSString *labelText = [dic objectForKey:@"tranStyle"];
    self.tranLabel.text = labelText;
}

-(void)changeMusicAccessoryLabel:(NSNotification *)note{
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    textFieldCell = nil;
    textField = nil;
    tranCell = nil;
    tranLabel = nil;
    switchCell = nil;
    mySwitch = nil;
    musicCell = nil;
    musicLabel = nil;
    a = nil;
    dataBase = nil;
    listTable =nil;
    listName = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (UIInterfaceOrientationIsPortrait(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
