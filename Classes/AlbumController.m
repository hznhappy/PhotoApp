//
//  AlbumController.m
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "AlbumController.h"
#import "AssetTablePicker.h"
#import "PlaylistDetailController.h"
@implementation AlbumController
@synthesize tableView,list;
@synthesize assetGroups;
@synthesize allUrl;
@synthesize unTagUrl,dbUrl;
@synthesize playListUrl;
@synthesize tagUrl;
@synthesize SUM,img;

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
    date = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray1 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray2 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray3 = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray4 = [[NSMutableArray alloc]init];
    self.allUrl = tempArray1;
    self.unTagUrl = tempArray2;
    self.tagUrl = tempArray3;
    self.assetGroups = tempArray;
    self.dbUrl=tempArray4;
    [tempArray release];
    [tempArray1 release];
    [tempArray2 release];
    [tempArray3 release];
    [tempArray4 release];
    [self setWantsFullScreenLayout:YES];
	[self.navigationItem setTitle:@"Loading..."];
    [self getAssetGroup];
    NSString *bu=NSLocalizedString(@"Edit", @"button");
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *addButon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toggleAdd:)];
    editButton = [[UIBarButtonItem alloc] initWithTitle:bu style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
    addButon.style = UIBarButtonItemStyleBordered;
    editButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem = addButon;
    [addButon release];
    [editButton release];
    da=[DBOperation getInstance];
    [self creatTable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table1) name:@"addplay" object:nil];
    NSString *selectPassTable = [NSString stringWithFormat:@"select LOCK from PassTable where ID=1"];
    NSMutableArray *PA=[da selectFromPassTable:selectPassTable];
    if([PA count]>0)
    {
    if([[PA objectAtIndex:0] isEqualToString:@"UnLock"])
    {
       // [self play];
   [self performSelector:@selector(play) withObject:nil afterDelay:0];
    }
    }
	[super viewDidLoad];
}
-(void)creatTable
{
    
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [da createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT PRIMARY KEY)",playIdOrder];
    [da createTable:createPlayIdOrder];
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [da createTable:createRules];
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [da createTable:createTag];
    NSString *createPassTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INTEGER PRIMARY KEY,LOCK,PASSWORD,URL)",PassTable];
    [da createTable:createPassTable];
    NSString *selectPlayTable = [NSString stringWithFormat:@"select count(*) from PlayTable"];
     NSInteger count=[[[da selectFromPlayTable:selectPlayTable]objectAtIndex:0]intValue];
  if(count==0)
  {   NSLog(@"OK");
        [self Special];
    }
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select play_id from playIdOrder"];
    self.list=[da selectOrderId:selectPlayIdOrder];
   
}
-(void)Special
{NSString *u=NSLocalizedString(@"ALL", @"title");
    NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,u];
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
                   NSLog(@"KO");
                   [self performSelectorOnMainThread:@selector(getAllUrls) withObject:nil waitUntilDone:YES];
                   [self deleteUnExitUrls];
                   return;
               }               
               [self.assetGroups addObject:group];
               [group numberOfAssets];
               [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
           };
           
           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
               
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:[NSString stringWithFormat:@"Error: %@", [error description]] 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
               [alert show];
               [alert release];                                 
           };	
           
           ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];        
           [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator 
                                failureBlock:assetGroupEnumberatorFailure];
           
           [library release];
           [pool release];
       });
}

-(void)getAllUrls{
    [self.allUrl removeAllObjects];
    for (ALAssetsGroup *group in self.assetGroups) {
        [group setAssetsFilter:[ALAssetsFilter allAssets]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
        {         
            if(result == nil) 
            {
                return;
            }
            [self.allUrl addObject:[[result defaultRepresentation]url]];
        }];
    }
   // NSLog(@"LLL%@",allUrl);
}

-(void)getUnTagUrls{
    [unTagUrl removeAllObjects];
    for (NSURL *urls in allUrl) {
        if (![tagUrl containsObject:urls]) {
            [unTagUrl addObject:urls];
        }
    }
}

-(void)getTagUrls{
    [tagUrl removeAllObjects];
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG;";
    NSMutableArray *photos = [da selectPhotos:selectSql];
    for (NSString *dataStr in photos) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [self.tagUrl addObject:dbStr];
    } 
}

-(void)deleteUnExitUrls{
    [self getTagUrls];
    for (NSURL *tagurl in tagUrl){
        if (![allUrl containsObject:tagurl]) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM TAG WHERE URL='%@'",tagurl];
            [da updateTable:sql];
        }
    }    
}
-(void)reloadTableView {
	NSString *a=NSLocalizedString(@"Albums", @"title");
	[self.tableView reloadData];
	[self.navigationItem setTitle:a];
}
#pragma mark -
#pragma Button Action
-(void)table1
{
    [self creatTable];
    [self.tableView reloadData];
}
-(IBAction)toggleEdit:(id)sender
{NSString *c=NSLocalizedString(@"Done", @"button");
    NSString *d=NSLocalizedString(@"Edit", @"button");
    if (self.tableView.editing) {
        editButton.title = d;
        }
    else{
       
        editButton.title = c;
    }
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
}

-(IBAction)toggleAdd:(id)sender
{
     PlaylistDetailController *detailController = [[PlaylistDetailController alloc]initWithNibName:@"PlaylistDetailController" bundle:[NSBundle mainBundle]];
    detailController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

#pragma mark -
#pragma mark TableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
   if([assetGroups count]==0)
   {
        return[assetGroups count];
    }
    else
    {
    return [list count];
    }
}


-(void)loadPhotos:(NSURL *)url 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    void (^assetRseult)(ALAsset *) = ^(ALAsset *result) 
    {
        if (result == nil) 
        {
            return;
        }
        self.img=result;
           
    };
 
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        
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
    [library assetForURL:url resultBlock:assetRseult failureBlock:failureBlock];
    [library release];
    [pool release];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
    if([[self.list objectAtIndex:indexPath.row]intValue]==1)
    {
        ALAssetsGroup *group = (ALAssetsGroup*)[assetGroups objectAtIndex:0];
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        //NSInteger gCount = [group numberOfAssets];
        cell.textLabel.textColor=[UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
        NSString *u=NSLocalizedString(@"ALL", @"title");
        cell.textLabel.text=[NSString stringWithFormat:@"%@ (%d)",u,[allUrl count]];
        [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:0] posterImage]]];
        
    }
    else if([[self.list objectAtIndex:indexPath.row]intValue]==2)
    {
        [self getTagUrls];
        [self getUnTagUrls];
        [self loadPhotos:[self.unTagUrl objectAtIndex:0]];
        [cell.imageView setImage:[UIImage imageWithCGImage:[self.img thumbnail]]];
        cell.textLabel.textColor=[UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
        NSString *u=NSLocalizedString(@"UNTAG", @"title");
        cell.textLabel.text=[NSString stringWithFormat:@"%@ (%d)",u,[unTagUrl count]];
    }
    else
    {
        
        
        int row=[[self.list objectAtIndex:indexPath.row]intValue];
        [self playlistUrl:row];
        if([dbUrl count]==0)
        {
            [cell.imageView setImage:[UIImage imageNamed:@"empty1.png"]];
        }
        else
        {
            [self loadPhotos:[self.dbUrl objectAtIndex:0]];
            [cell.imageView setImage:[UIImage imageWithCGImage:[self.img thumbnail]]];
            
        }
        cell.textLabel.text=[NSString stringWithFormat:@"%@ (%d)",da.name,[dbUrl count]];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}
-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"listTitle"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SetTitle" object:self userInfo:dic];
     AssetTablePicker *assetPicker = [[AssetTablePicker alloc]initWithNibName:@"AssetTablePicker" bundle:[NSBundle mainBundle]];
    assetPicker.hidesBottomBarWhenPushed = YES;
    if ([[list objectAtIndex:indexPath.row]intValue]==2) {
        [self getTagUrls];
        [self getUnTagUrls];
        assetPicker.urlsArray = unTagUrl;
          NSString *u=NSLocalizedString(@"UNTAG", @"title");
        assetPicker.navigationItem.title = u;
    }
    else if ([[list objectAtIndex:indexPath.row]intValue]==1) {
        assetPicker.urlsArray = allUrl;
          NSString *u=NSLocalizedString(@"ALL", @"title");
        assetPicker.navigationItem.title = u;
    }
    else
    {
        int row_id=[[list objectAtIndex:indexPath.row]intValue];
        [self playlistUrl:row_id];
         assetPicker.urlsArray =dbUrl;
    } 
    assetPicker.PLAYID=[list objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:assetPicker animated:YES];
    [assetPicker release];
    [table deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)play
{
    AssetTablePicker *assetPicker = [[AssetTablePicker alloc]init];
      assetPicker.hidesBottomBarWhenPushed = YES;
    NSString *selectPassTable = [NSString stringWithFormat:@"select URL from PassTable"];
   NSMutableArray *url=[da selectFromPassTable:selectPassTable];
    NSMutableArray *ok=[[NSMutableArray alloc]init];
    for (NSString *dataStr in url) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [ok addObject:dbStr];
    }
    assetPicker.urlsArray=ok;
    [ok release];
    NSString *selectPassTable1 = [NSString stringWithFormat:@"select PASSWORD from PassTable where ID=1"];
    NSMutableArray *password=[da selectFromPassTable:selectPassTable1];
    assetPicker.val=[password objectAtIndex:0];
    NSLog(@"VAL:%@",assetPicker.val);
     [self.navigationController pushViewController:assetPicker animated:YES];
    NSString *b=NSLocalizedString(@"UnLock", @"button");
    assetPicker.lock.title=b;
    [assetPicker release];
    
}
-(void)playlistUrl:(int)row_id
{    
    [SUM removeAllObjects];
    [dbUrl removeAllObjects];
    NSString *selectRules0= [NSString stringWithFormat:@"select user_id from rules where playlist_id=%d and playlist_rules=%d",row_id,0];
    NSMutableArray *playlist_UserId0=[da selectFromRules:selectRules0];
    for(int i=0;i<[playlist_UserId0 count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select URL from tag where ID=%d",[[playlist_UserId0 objectAtIndex:i]intValue]];
        NSMutableSet *play_url0=[da selectFromTAG1:selectTag];
        if([self.SUM count]==0)
        {
            NSLog(@"0A");
            NSMutableSet *t=[[NSMutableSet alloc]init];
            for (NSURL *url in allUrl) {
                NSString *str= [NSString stringWithFormat:@"%@",url];
                [t addObject:str];
            }
            
            self.SUM=t;
            [t release];
            for (NSString *data in play_url0)
            {
                if([self.SUM containsObject:data]) 
                {
                    [self.SUM removeObject:data];
                }
                
            }
        }
        else
        {
            for (NSString *data in play_url0)
            {
                if([self.SUM containsObject:data]) 
                {
                    
                    [self.SUM removeObject:data];
                }
            }
        }
    }
    
    NSString *selectRules1= [NSString stringWithFormat:@"select user_id from rules where playlist_id=%d and playlist_rules=%d",row_id,1];
     NSMutableArray *playlist_UserId1=[da selectFromRules:selectRules1];
    for(int i=0;i<[playlist_UserId1 count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select URL from tag where ID=%d",[[playlist_UserId1 objectAtIndex:i]intValue]];
        NSMutableSet *play_url1=[da selectFromTAG1:selectTag];
        if([play_url1 count]==0)
        {
            [SUM removeAllObjects];
            break;
        }
        else
        {
            if([self.SUM count]==0)
            {
                self.SUM=play_url1;
                
            }
            else
            {
                [self.SUM intersectSet:play_url1];
            }
        }
    }
    NSString *selectRules2= [NSString stringWithFormat:@"select user_id from rules where playlist_id=%d and playlist_rules=%d",row_id,2];
    NSMutableArray *playlist_UserId2=[da selectFromRules:selectRules2];
    for(int i=0;i<[playlist_UserId2 count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select URL from tag where ID=%d",[[playlist_UserId2 objectAtIndex:i]intValue]];
         NSMutableSet *play_url2=[da selectFromTAG1:selectTag];
        
        NSLog(@"WE%@",playlist_UserId2);
        if([self.SUM count]==0)
            
        {
            self.SUM=play_url2;
        }
        else
        {
            [SUM unionSet:play_url2];
        }
    }
    
    
    
    for (NSString *dataStr in self.SUM) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [dbUrl addObject:dbStr];
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if([[list objectAtIndex:indexPath.row]intValue]<=2)
    {
          NSString *a=NSLocalizedString(@"hello", @"title");
        NSString *b=NSLocalizedString(@"Inherent members, can not be edited", @"title");
        NSString *c=NSLocalizedString(@"ok", @"title");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:a message:b delegate:self cancelButtonTitle:c otherButtonTitles:nil];
        [alert show];
        [alert release];

        
    }
   
    else{
        NSLog(@"wwji");
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"playListedit" 
                                                           object:self 
                                                         userInfo:dic1];

    [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
   
    PlaylistDetailController *detailController = [[PlaylistDetailController alloc]initWithNibName:@"PlaylistDetailController" bundle:[NSBundle mainBundle]];
    detailController.listName =[NSString stringWithFormat:@"%@",da.name];
    detailController.Transtion=[NSString stringWithFormat:@"%@",da.Transtion];    
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
        NSString *a=NSLocalizedString(@"hello", @"title");
        NSString *b=NSLocalizedString(@"Inherent members, can not be deleted", @"title");
        NSString *c=NSLocalizedString(@"ok", @"title");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:a message:b delegate:self cancelButtonTitle:c otherButtonTitles:nil];
        [alert show];
        [alert release];

    }
    else
    {
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
    da=[DBOperation getInstance];
    NSString *deleteIdOrder= [NSString stringWithFormat:@"DELETE FROM playIdOrder"];	
	NSLog(@"%@",deleteIdOrder);
    [da deleteDB:deleteIdOrder];
    for(int p=0;p<[list count];p++){
        NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(play_id) VALUES(%d)",playIdOrder,[[list objectAtIndex:p]intValue]];
        NSLog(@"%@",insertIdOrder);
        [da insertToTable:insertIdOrder];    
	}
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
    [SUM release];
    [dbUrl release];
    [img release];
    [super dealloc];
}
@end
