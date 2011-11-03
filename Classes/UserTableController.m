//
//  UserTableController.m
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "UserTableController.h"
#import "TextController.h"
#import "AssetTablePicker.h"
#import "PlaylistDetailController.h"
@implementation UserTableController
@synthesize tableView,list,tools,withlist,withoutlist;
@synthesize assetGroups;
@synthesize allUrl;
@synthesize unTagUrl;
@synthesize playListUrl;
@synthesize tagUrl;

#pragma mark -
#pragma mark UIViewController method
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
}

-(void)viewWillDisappear:(BOOL)animated
{       
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    
}

-(void)viewDidLoad
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *addButon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toggleAdd:)];
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
    addButon.style = UIBarButtonItemStyleBordered;
    editButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem = addButon;
    [addButon release];
    [editButton release];
    
	da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createSQL3= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createSQL3];
    NSString *selectPlay = [NSString stringWithFormat:@"select * from PlayTable"];
    [da selectFromPlayTable:selectPlay];
    self.list=da.playary;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];

    NSMutableArray *tempArray1 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray2 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray3 = [[NSMutableArray alloc]init];
    
    self.allUrl = tempArray1;
    self.unTagUrl = tempArray2;
    self.tagUrl = tempArray3;
    [tempArray1 release];
    [tempArray2 release];
    [tempArray3 release];
    
    [self getAssetGroup];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table1) name:@"addplay" object:nil];
    [da closeDB];
   
	[super viewDidLoad];
    
    
}
#pragma mark -
#pragma mark get URL method
-(void)getAssetGroup{
    dispatch_async(dispatch_get_main_queue(), ^
       {
           NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
           
           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
           {
               if (group == nil) 
               {
                   [self performSelectorOnMainThread:@selector(getAllUrls) withObject:nil waitUntilDone:YES];
                   [self deleteUnExitUrls];
                   return;
               }               
               [self.assetGroups addObject:group];
               [group numberOfAssets];
           };
           
           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
               
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:[NSString stringWithFormat:@"Error: %@", [error description]] 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
               [alert show];
               [alert release];
               
               NSLog(@"A problem occured %@", [error description]);	                                 
           };	
           
           ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];        
           [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator 
                                failureBlock:assetGroupEnumberatorFailure];
           
           
           [library release];
           NSLog(@"this is the get AssetGroup method %d",[assetGroups count]);
           [pool release];
       });
}

-(void)getAllUrls{
    [self.allUrl removeAllObjects];
    for (ALAssetsGroup *group in self.assetGroups) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
        {         
            if(result == nil) 
            {
                return;
            }
            [self.allUrl addObject:[[result defaultRepresentation]url]];
        }];

    }
    NSLog(@"get allurl count is :%d",[allUrl count]);
}

-(void)getUnTagUrls{
    [unTagUrl removeAllObjects];
    for (NSURL *urls in allUrl) {
        if (![tagUrl containsObject:urls]) {
            [unTagUrl addObject:urls];
        }
    }
    NSLog(@"%d is untag ",[unTagUrl count]);

}

-(void)getTagUrls{
    [tagUrl removeAllObjects];
    [da openDB];
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG;";
    NSMutableArray *photos = [da selectPhotos:selectSql];
    [da closeDB];
    for (NSString *dataStr in photos) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [self.tagUrl addObject:dbStr];
    } 
    NSLog(@"%d is tag",[tagUrl count]);
}

-(void)deleteUnExitUrls{
    [self getTagUrls];
    for (NSURL *tagurl in tagUrl){
        if (![allUrl containsObject:tagurl]) {
            [da openDB];
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM TAG WHERE URL='%@'",tagurl];
            [da updateTable:sql];
            [da closeDB];
        }
    }    
}

#pragma mark -
#pragma Button Action
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

#pragma mark -
#pragma mark TableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return ([list count]+2);
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    [cell.textLabel setNumberOfLines:10];
    cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
    
    if (indexPath.row == [list count]) {
        cell.textLabel.text = @"UNTAG";
    }
    else if (indexPath.row == [list count]+1) {
        cell.textLabel.text = @"ALL";
    }else{
        da=[[DBOperation alloc]init];
        [da openDB];
        NSString *createSQL3= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
        [da createTable:createSQL3];
        User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
        NSLog(@"%@",[list objectAtIndex:indexPath.row]);
    cell.textLabel.text=[NSString stringWithFormat:@"%@",user3.name];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [da closeDB];
    }
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
    
    AssetTablePicker *assetPicker = [[AssetTablePicker alloc]initWithNibName:@"AssetTablePicker" bundle:[NSBundle mainBundle]];
    if (indexPath.row == [list count]) {
        [self getTagUrls];
        [self getUnTagUrls];
        assetPicker.urlsArray = unTagUrl;
    }
    else if (indexPath.row == [list count]+1) {
        assetPicker.urlsArray = allUrl;
    }
    else
    assetPicker.urlsArray = playListUrl;
    [self.navigationController pushViewController:assetPicker animated:YES];
    [assetPicker release];
    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [da openDB];
    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
    [da closeDB];
    PlaylistDetailController *detailController = [[PlaylistDetailController alloc]initWithNibName:@"PlaylistDetailController" bundle:[NSBundle mainBundle]];
    detailController.listName = user3.name;
	[self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}
-(IBAction)toggleback:(id)sender
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if (indexPath.row==[list count]||indexPath.row == [list count]+1) {
        return;
    }
    [da openDB];
    NSString *createSQL3= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createSQL3];
    NSString *countSQL = [NSString stringWithFormat:@"DELETE FROM PlayTable WHERE playList_id=%d",[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",countSQL);
    [da deleteDB:countSQL];  
    [da closeDB];
    [self viewDidLoad];
    [self.tableView reloadData];
    
}
#pragma mark -
#pragma mark memory method
- (void)dealloc {
    [allUrl release];
    [unTagUrl release];
    [tagUrl release];
    [playListUrl release];
    [tableView release];
    [list release];
    [super dealloc];
}
@end
