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
-(void)setLock
{
    NSLog(@"COCO");
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
}

-(void)viewWillDisappear:(BOOL)animated
{       
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    
}

-(void)viewDidLoad
{/*NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; 
    NSNumber *val=[defaults objectForKey:@"pa"];
    NSLog(@"KKKK%@",val);
    [defaults setObject:@"shan" forKey:@"pa"];*/
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
    //UIImage *buttonUpImage = [UIImage imageNamed:@"empty1.png"];
    
    //[editButton setImage:buttonUpImage];
    //[editButton setTitle:@"edit"];
    editButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem = addButon;
    [addButon release];
    [editButton release];
    [self creatTable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(table1) name:@"addplay" object:nil];
	[super viewDidLoad];
}
-(void)creatTable
{
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [da createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [da createTable:createPlayIdOrder];
   
    NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
    [da selectFromPlayTable:selectPlayTable];
  if([da.playIdAry count]==0)
    {   
        [self Special];
    }
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select * from playIdOrder"];
    [da selectOrderId:selectPlayIdOrder];
    self.list=da.orderIdList;
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [da createTable:createRules];
    
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [da createTable:createTag];
    [da closeDB];
   

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
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
        {         
            if(result == nil) 
            {
                return;
            }
            [self.allUrl addObject:[[result defaultRepresentation]url]];
            // [self getDate:result];
        }];
    }
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
    [da openDB];
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG;";
    NSMutableArray *photos = [da selectPhotos:selectSql];
    [da closeDB];
    for (NSString *dataStr in photos) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [self.tagUrl addObject:dbStr];
    } 
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
-(void)reloadTableView {
	NSString *a=NSLocalizedString(@"Albums", @"title");
	[self.tableView reloadData];
	[self.navigationItem setTitle:a];
}


/*-(void)getDate:(ALAsset*)rule
{   
    NSDictionary *dic = [[rule defaultRepresentation]metadata];
    id dateTime = [[dic objectForKey:@"{TIFF}"]objectForKey:@"DateTime"];
    if (dateTime!=nil) {
        NSArray *time = [dateTime componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *dataStr = [time objectAtIndex:0];
        if (![date containsObject:dataStr]) {
            [date addObject:[time objectAtIndex:0]];
        }
    }

}
*/
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
   // nicshanController *detailController=[[nicshanController alloc]init];
    detailController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

#pragma mark -
#pragma mark TableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
   //return [list count];
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
    
    [da openDB];
    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
    if([[list objectAtIndex:indexPath.row]intValue]==1)
    {
        ALAssetsGroup *group = (ALAssetsGroup*)[assetGroups objectAtIndex:0];
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSInteger gCount = [group numberOfAssets];
        cell.textLabel.textColor=[UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
        NSString *u=NSLocalizedString(@"ALL", @"title");
        cell.textLabel.text=[NSString stringWithFormat:@"%@ (%d)",u,gCount];
        [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:0] posterImage]]];
        
    }
    else if([[list objectAtIndex:indexPath.row]intValue]==2)
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
        
        
        int row=[[list objectAtIndex:indexPath.row]intValue];
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
        cell.textLabel.text=[NSString stringWithFormat:@"%@ (%d)",user3.name,[dbUrl count]];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    [da closeDB];
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
       // assetPicker.dateArry=date;
       
    }
    else
    {
        int row_id=[[list objectAtIndex:indexPath.row]intValue];
        [da openDB];
        [self playlistUrl:row_id];
          [da closeDB];
         assetPicker.urlsArray =dbUrl;
    } 
    assetPicker.PLAYID=[list objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:assetPicker animated:YES];
    [assetPicker release];
    [table deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)playlistUrl:(int)row_id
{    
    [SUM removeAllObjects];
    [dbUrl removeAllObjects];
    NSString *selectRules1= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",row_id,1];
    [da selectFromRules:selectRules1];
     for(int i=0;i<[da.playlist_UserId count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select * from tag where ID=%d",[[da.playlist_UserId objectAtIndex:i]intValue]];
        [da selectFromTAG:selectTag];
        if([self.SUM count]==0)
        {
           self.SUM=da.tagUrl;
        
        }
        else
        {
            [self.SUM intersectSet:da.tagUrl];
        }
    }
    NSString *selectRules2= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",row_id,2];
    [da selectFromRules:selectRules2];
    for(int i=0;i<[da.playlist_UserId count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select * from tag where ID=%d",[[da.playlist_UserId objectAtIndex:i]intValue]];
        [da selectFromTAG:selectTag];

        NSLog(@"WE%@",da.playlist_UserId);
        if([self.SUM count]==0)

        {
            self.SUM=da.tagUrl;
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
            for (NSString *data in da.tagUrl)
            {
                if([self.SUM containsObject:data]) 
                {
                    [self.SUM removeObject:data];
                }
                
            }
        }
        else
        {
            for (NSString *data in da.tagUrl)
            {
                if([self.SUM containsObject:data]) 
                {

                    [self.SUM removeObject:data];
                }
            }
        }
    }
  
  
    for (NSString *dataStr in self.SUM) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [dbUrl addObject:dbStr];
    }
   
    //[SUM release];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
      [da openDB];
    //NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select playList_id from playTable"];
   // [da selectFromPlayTable:selectPlayIdOrder];
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

    User *user3 = [da getUserFromPlayTable:[[list objectAtIndex:indexPath.row]intValue]];
   
    PlaylistDetailController *detailController = [[PlaylistDetailController alloc]initWithNibName:@"PlaylistDetailController" bundle:[NSBundle mainBundle]];
    detailController.listName =[NSString stringWithFormat:@"%@",user3.name];
    detailController.Transtion=[NSString stringWithFormat:@"%@",user3.Transtion];    
    detailController.a=[NSString stringWithFormat:@"%@",[list objectAtIndex:indexPath.row]];
    detailController.hidesBottomBarWhenPushed = YES;
     [da closeDB];    

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
    [SUM release];
    [dbUrl release];
    [img release];
    [super dealloc];
}
@end
