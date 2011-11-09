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
@synthesize SUM;

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
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray1 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray2 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray3 = [[NSMutableArray alloc]init];
    self.SUM=[[NSMutableSet alloc]init];
    // NSMutableSet *tempArray4 = [[NSMutableSet alloc]init];
   // self.SUM=tempArray4;
   // [SUM R]
    self.allUrl = tempArray1;
    self.unTagUrl = tempArray2;
    self.tagUrl = tempArray3;
    self.assetGroups = tempArray;
    [tempArray release];
    [tempArray1 release];
    [tempArray2 release];
    [tempArray3 release];
    
    [self getAssetGroup];
    [self creatTable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table1) name:@"addplay" object:nil];
	[super viewDidLoad];
}
-(void)creatTable
{
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [da createTable:createPlayIdOrder];
   
    NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
    [da selectFromPlayTable:selectPlayTable];
    NSLog(@"EEEEE%d",[da.playIdAry count]);
  if([da.playIdAry count]<2)
    {
        NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,@"ALL"];
        NSLog(@"%@",insertPlayTable);
        [da insertToTable:insertPlayTable];
        NSString *insertPlayTable1= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,@"UNTAG"];
        NSLog(@"%@",insertPlayTable1);
        [da insertToTable:insertPlayTable1];
        NSString *insertPlayIdOrder= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,1];
        NSLog(@"%@",insertPlayIdOrder);
        [da insertToTable:insertPlayIdOrder];
        NSString *insertPlayIdOrder1= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,2];
        NSLog(@"%@",insertPlayIdOrder1);
        [da insertToTable:insertPlayIdOrder1];

    }
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select * from playIdOrder"];
    [da selectOrderId:selectPlayIdOrder];
    self.list=da.orderIdList;
    NSLog(@"re%d",[list count]);
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [da createTable:createRules];
    
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [da createTable:createTag];
    
    
    [da closeDB];
   

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
                   [self.allUrl removeAllObjects];
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
               
               //NSLog(@"A problem occured %@", [error description]);	                                 
           };	
           
           ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];        
           [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator 
                                failureBlock:assetGroupEnumberatorFailure];
           
           
           [library release];
          // NSLog(@"this is the get AssetGroup method %d",[assetGroups count]);
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
    //NSLog(@"get allurl count is :%d",[allUrl count]);
}

-(void)getUnTagUrls{
    [unTagUrl removeAllObjects];
    for (NSURL *urls in allUrl) {
        if (![tagUrl containsObject:urls]) {
            [unTagUrl addObject:urls];
        }
    }
   // NSLog(@"%d is untag ",[unTagUrl count]);

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
    //NSLog(@"%d is tag",[tagUrl count]);
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
    [self creatTable];
    [self.tableView reloadData];
}
-(IBAction)toggleEdit:(id)sender
{
    if (self.tableView.editing) {
        editButton.title = @"Edit";
               /* [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[list count]+2 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
*/
    }else{
       
      /*  [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[list count]+2 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];*/
        editButton.title = @"Done";
    }
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
}

-(IBAction)toggleAdd:(id)sender
{
   // TextController *ts1=[[TextController alloc]init];
     PlaylistDetailController *detailController = [[PlaylistDetailController alloc]initWithNibName:@"PlaylistDetailController" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

#pragma mark -
#pragma mark TableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ if (self.tableView.editing) {
}


    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    [da openDB];
            User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
        NSLog(@"%@",[list objectAtIndex:indexPath.row]);
    if([[list objectAtIndex:indexPath.row]intValue]<=2)
    {
        cell.textLabel.textColor=[UIColor redColor];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",user3.name];
   
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    [da closeDB];
    return cell;
}
-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"listTitle"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SetTitle" object:self userInfo:dic];
     AssetTablePicker *assetPicker = [[AssetTablePicker alloc]initWithNibName:@"AssetTablePicker" bundle:[NSBundle mainBundle]];
    if ([[list objectAtIndex:indexPath.row]intValue]==2) {
        [self getTagUrls];
        [self getUnTagUrls];
        assetPicker.urlsArray = unTagUrl;
        assetPicker.navigationItem.title = @"UNTAG";
    }
    else if ([[list objectAtIndex:indexPath.row]intValue]==1) {
        assetPicker.urlsArray = allUrl;
        assetPicker.navigationItem.title = @"ALL";
    }
    else
    {
        int row_id=[[list objectAtIndex:indexPath.row]intValue];
       
        [self playlistUrl:row_id];
         assetPicker.urlsArray =dbUrl;
            } 
      [self.navigationController pushViewController:assetPicker animated:YES];
    [assetPicker release];
    [table deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)playlistUrl:(int)row_id
{    [da openDB];
    NSString *selectRules1= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",row_id,1];
    [da selectFromRules:selectRules1];
    SUM=NULL;
    for(int i=0;i<[da.playlist_UserId count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select * from tag where ID=%d",[[da.playlist_UserId objectAtIndex:i]intValue]];
        [da selectFromTAG:selectTag];
        if(SUM==NULL)
        {
            SUM=da.tagUrl;
            continue;
        }
        else
        {
            [SUM intersectSet:da.tagUrl];
        }
    }
    NSString *selectRules2= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",row_id,2];
    [da selectFromRules:selectRules2];
    for(int i=0;i<[da.playlist_UserId count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select * from tag where ID=%d",[[da.playlist_UserId objectAtIndex:i]intValue]];
        [da selectFromTAG:selectTag];
        if(SUM==NULL)
        {
            SUM=da.tagUrl;
        }
        else
        {
            [SUM unionSet:da.tagUrl];
        }
    }
    
    NSString *selectRules0= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",row_id,0];
    [da selectFromRules:selectRules0];
    for(int i=0;i<[da.playlist_UserId count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select * from tag where ID=%d",[[da.playlist_UserId objectAtIndex:i]intValue]];
        [da selectFromTAG:selectTag];
        if(SUM==NULL)
        {
            NSMutableSet *t=[[NSMutableArray alloc]init];
            for (NSURL *url in allUrl) {
                NSString *str= [NSString stringWithFormat:@"%@",url];
                [t addObject:str];
            }
            
            SUM=t;
            for (NSString *data in da.tagUrl)
            {
                if([SUM containsObject:data]) 
                {
                    [SUM removeObject:data];
                }
                
            }
        }
        else
        {
            for (NSString *data in da.tagUrl)
            {
                if([SUM containsObject:data]) 
                {
                    [SUM removeObject:data];
                }
            }
        }
    }
    [da closeDB];
  dbUrl=[[NSMutableArray alloc]init];
    for (NSString *dataStr in SUM) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [dbUrl addObject:dbStr];
    }
   

}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
      [da openDB];
    //NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select playList_id from playTable"];
   // [da selectFromPlayTable:selectPlayIdOrder];
    if([[list objectAtIndex:indexPath.row]intValue]<=2)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"你好" message:@"固有成员,无法编辑" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];

        
    }
   
    else{
    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
    [da closeDB];
    PlaylistDetailController *detailController = [[PlaylistDetailController alloc]initWithNibName:@"PlaylistDetailController" bundle:[NSBundle mainBundle]];
    detailController.listName =[NSString stringWithFormat:@"%@",user3.name];
    detailController.a=[NSString stringWithFormat:@"%@",[list objectAtIndex:indexPath.row]];
    detailController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{   if ([[list objectAtIndex:indexPath.row]intValue]==1||[[list objectAtIndex:indexPath.row]intValue]==2)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"你好" message:@"固有成员,无法删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];

    }
    else
    {
    [da openDB];
    NSString *deletePlayTable = [NSString stringWithFormat:@"DELETE FROM PlayTable WHERE playList_id=%d",[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",deletePlayTable );
    [da deleteDB:deletePlayTable ]; 
    NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playList_id=%d",[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",deleteRules);
    [da deleteDB:deleteRules]; 
    NSString *deleteplayIdOrder= [NSString stringWithFormat:@"DELETE FROM playIdOrder WHERE play_id=%d",[[list objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",deleteplayIdOrder);
    [da deleteDB:deleteplayIdOrder]; 

  
    if (indexPath.row==[list count]||indexPath.row == [list count]+1) {
        return;
    }

    [da closeDB];
    [self creatTable];
    [self.tableView reloadData];
    
    }
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
    NSString *deleteIdOrder= [NSString stringWithFormat:@"DELETE FROM playIdOrder"];	
	NSLog(@"%@",deleteIdOrder);
    [da deleteDB:deleteIdOrder];
    for(int p=0;p<[list count];p++){
        NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(play_id) VALUES(%d)",playIdOrder,[[list objectAtIndex:p]intValue]];
        NSLog(@"%@",insertIdOrder);
        [da insertToTable:insertIdOrder];    
	}
    [da closeDB];
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
    [withlist release];
    [withoutlist release];
    [super dealloc];
}
@end
