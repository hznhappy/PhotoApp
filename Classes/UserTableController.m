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

    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];

    NSMutableArray *tempArray1 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray2 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray3 = [[NSMutableArray alloc]init];
    self.SUM=[[NSMutableSet alloc]init];
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
    TextController *ts1=[[TextController alloc]init];
	[self.navigationController pushViewController:ts1 animated:YES];
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
    da=[[DBOperation alloc]init];
    [da openDB];
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
    {
        da=[[DBOperation alloc]init];
        [da openDB];
        NSString *createRules1=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
        [da createTable:createRules1];
        NSLog(@"%d",[[list objectAtIndex:indexPath.row]intValue]);
        NSString *selectRules= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",[[list objectAtIndex:indexPath.row]intValue],1];
        [da selectFromRules:selectRules];
        NSLog(@"RRERRE");
        NSLog(@"%@",da.playlist_UserId);
         SUM=[[NSMutableSet alloc]init];
        SUM=NULL;
       for(int i=0;i<[da.playlist_UserId count];i++)
        {
            NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
            [da createTable:createTag];
            NSLog(@"CHAXUN");
            NSString *selectTag= [NSString stringWithFormat:@"select * from tag where ID=%d",[[da.playlist_UserId objectAtIndex:i]intValue]];
            [da selectFromTAG:selectTag];
            NSLog(@"%@",da.tagUrl);
            if(SUM==NULL)
            {
                
                SUM=da.tagUrl;
                NSLog(@"WEEWEW");
                NSLog(@"DIYICI %@",SUM);
                continue;
                
            }
            else
            {
                [SUM intersectSet:da.tagUrl];
                NSLog(@"DIERCI %@",SUM);
                
            }
            NSLog(@"我%@",SUM);
        }
        
       NSString *selectRules0= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",[[list objectAtIndex:indexPath.row]intValue],0];
        [da selectFromRules:selectRules0];
        NSLog(@"WITHOUT%@",da.playlist_UserId);
        for(int i=0;i<[da.playlist_UserId count];i++)
        {
        
            NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
            [da createTable:createTag];
            NSLog(@"CHAXUN");
            NSString *selectTag= [NSString stringWithFormat:@"select * from tag where ID=%d",[[da.playlist_UserId objectAtIndex:i]intValue]];
            [da selectFromTAG:selectTag];
            NSLog(@"%@",da.tagUrl);
            if(SUM==NULL)
            {
                  NSMutableSet *t=[[NSMutableArray alloc]init];
                for (NSURL *url in allUrl) {
                    NSString *str= [NSString stringWithFormat:@"%@",url];
                    NSLog(@"DDDDD%@",str);
                  
                     [t addObject:str];
                    
                    NSLog(@"1111%@",t);
                }
               SUM=t;
                 for (NSString *data in da.tagUrl)
                {
                   if([SUM containsObject:data]) 
                   {
                       [SUM removeObject:data];
                   }
                       
                }
                NSLog(@"EE%@",SUM);
                
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
            NSLog(@"我%@",SUM);
        }

        [da closeDB];
        NSLog(@"还%@",SUM);
        NSLog(@"%d",[SUM count]);
        NSMutableArray *dbUrl=[[NSMutableArray alloc]init];
        for (NSString *dataStr in SUM) {
            NSURL *dbStr = [NSURL URLWithString:dataStr];
            [dbUrl addObject:dbStr];
        }
            assetPicker.urlsArray =dbUrl;
            NSLog(@"777%@",assetPicker.urlsArray);
        


        } 
      [self.navigationController pushViewController:assetPicker animated:YES];
    [assetPicker release];
    

}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
   [da openDB];
    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];

    TextController *ts=[[TextController alloc]init];
     ts.str1 = user3.name;
     NSLog(@"re%d",[[list objectAtIndex:indexPath.row]intValue]);
     NSString *selectRulesIn= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[[list objectAtIndex:indexPath.row]intValue],1];
     [da selectFromRules:selectRulesIn];
     NSLog(@"%@",da.playlist_UserName);
     for(int i=0;i<[da.playlist_UserName count];i++)
     {
     if(ts.str2==nil||ts.str2.length==0)
     {
     
     ts.str2=[da.playlist_UserName objectAtIndex:i];
     }
     else
     {  ts.str2=[ts.str2 stringByAppendingString:@","];
     ts.str2=[ts.str2 stringByAppendingString:[da.playlist_UserName objectAtIndex:i]];
     }
     
     }
     NSString *selectRulesOut= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[[list objectAtIndex:indexPath.row]intValue],0];
     [da selectFromRules:selectRulesOut];
     for(int j=0;j<[da.playlist_UserName count];j++)
     {
     if(ts.str3==nil||ts.str3.length==0)
     {
     
     ts.str3=[da.playlist_UserName objectAtIndex:j];
     }
     else
     {  ts.str3=[ts.str3 stringByAppendingString:@","];
     ts.str3=[ts.str3 stringByAppendingString:[da.playlist_UserName objectAtIndex:j]];
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

  
    if (indexPath.row==[list count]||indexPath.row == [list count]+1) {
        return;
    }

    [da closeDB];
    [self viewDidLoad];
    [self.tableView reloadData];
    
}



/*-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
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

*/

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
