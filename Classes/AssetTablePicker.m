//
//  AssetTablePicker.m
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AssetTablePicker.h"
#import "ThumbnailCell.h"
#import "AlbumController.h"
#import "PhotoViewController.h"
#import "tagManagementController.h"
@implementation AssetTablePicker
@synthesize assetGroup;
@synthesize dataBase;
@synthesize crwAssets,assetArrays,urlsArray,selectUrls,dateArry;
@synthesize table;
@synthesize viewBar,tagBar;
@synthesize save,reset,UserId,UrlList,UserName;

#pragma mark -
#pragma mark UIViewController Methods
-(void)viewDidLoad {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.UrlList=tempArray;
    [tempArray release];
    self.table.delegate = self;
    self.table.maximumZoomScale = 2;
    self.table.minimumZoomScale = 1;
    self.table.contentSize = CGSizeMake(self.table.frame.size.width, self.table.frame.size.height);
    mode = NO;
    tagBar.hidden = YES;
    save.enabled = NO;
    reset.enabled = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.table setSeparatorColor:[UIColor clearColor]];
	[self.table setAllowsSelection:NO];
    [self setWantsFullScreenLayout:YES];
    
    DBOperation *db = [[DBOperation alloc]init];
    self.dataBase = db;
    [db release];
    
    NSMutableArray *thumbNailArray = [[NSMutableArray alloc] init];
    NSMutableArray *temArray = [[NSMutableArray alloc] init] ;
    self.crwAssets = thumbNailArray;
    self.assetArrays = temArray;
    [thumbNailArray release];
    [temArray release];

    cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelTag)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(setEditOverlay:) 
                                                name:@"Set Overlay" 
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(getSelectedUrls:) 
                                                name:@"selectedUrls" 
                                              object:nil];
    [self creatTable];
    [self performSelectorInBackground:@selector(loadPhotos) withObject:nil];
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:.5];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddUrl:) name:@"AddUrl" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemoveUrl:) name:@"RemoveUrl" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddUser:) name:@"AddUser" object:nil];
}
-(void)creatTable
{
    dataBase=[[DBOperation alloc]init];
    [dataBase openDB];
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [dataBase createTable:createTag];  
    [dataBase closeDB];
}
-(void)AddUrl:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    [UrlList addObject:[dic objectForKey:@"url"]];
    NSLog(@"JJJ%@",UrlList);
    if([UrlList count]!=0)
    {
        save.enabled = YES;
        reset.enabled = YES;
    }
}
-(void)RemoveUrl:(NSNotification *)note
{
    NSDictionary *dic = [note userInfo];
    [UrlList removeObject:[dic objectForKey:@"Removeurl"]];
    NSLog(@"JJJ%@",UrlList);
    if([UrlList count]==0)
    {
        save.enabled = NO;
        reset.enabled = NO;
    }


}
-(void)AddUser:(NSNotification *)note
{
    NSDictionary *dic = [note userInfo];
    self.UserId=[dic objectForKey:@"UserId"];
    UserName=[dic objectForKey:@"UserName"];
    NSLog(@"JJJ%@",UserId);
    NSLog(@"JJJ%@",UserName);
    
}
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;

}
-(void)viewDidDisappear:(BOOL)animated{
    for (Thumbnail *thub in crwAssets) {
        [thub setSelectOvlay];
    }
}

-(void)loadPhotos {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (NSURL *assetUrl in self.urlsArray) {
        void (^assetRseult)(ALAsset *) = ^(ALAsset *result) 
        {
            if (result == nil) 
            {
                return;
            }
            thuView = [[Thumbnail alloc] initWithAsset:result];
            thuView.fatherController = self;
            thuView.overlay = mode;
            [self.crwAssets addObject:thuView];
            [thuView release];
            [self.assetArrays addObject:result];
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
        [library assetForURL:assetUrl resultBlock:assetRseult failureBlock:failureBlock];
        [library release];
    }
    [self setPhotoTag];
    //prepare ALAsset for ThumbnailView to init PhotoViewController to display Photo;
    for (Thumbnail *thumbnail in self.crwAssets) {
        for (id asset in self.assetArrays) {
            [thumbnail.assetArray addObject:asset];
        }
    }
	[self.table reloadData];           
    [pool release];

	
}

-(void)setPhotoTag{
    [dataBase openDB];
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG;";
    NSMutableArray *photos = [dataBase selectPhotos:selectSql];
    for (NSString *dataStr in photos) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        for (Thumbnail *thumbnail in self.crwAssets) {
            NSURL *thumStr = [[thumbnail.asset defaultRepresentation]url];
            if ([dbStr isEqual:thumStr]) {
                NSLog(@"FD");
                NSString *selectTag= [NSString stringWithFormat:@"select * from tag where URL='%@'",dataStr];
                [dataBase selectFromTAG:selectTag];
                NSLog(@"KOKO%@",dataBase.tagIdAry);
                NSString *num=[NSString stringWithFormat:@"%d",[dataBase.tagIdAry count]];
                [thumbnail setOverlayHidden:num];
                
            }
        }
    } 
    [dataBase closeDB];
}


#pragma mark -
#pragma mark ButtonAction Methods
-(void)cancelTag{
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.rightBarButtonItem = nil;
    tagBar.hidden = YES;
    viewBar.hidden = NO;
    mode = NO;
    save.enabled=NO;
    reset.enabled=NO;
    [self resetTags];
    [self.table reloadData];
}

-(IBAction)actionButtonPressed{
    mode = YES;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = cancel;
    viewBar.hidden = YES;
    tagBar.hidden = NO;
    [self.table reloadData];
}
-(IBAction)lockButtonPressed{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}
-(IBAction)saveTags{
    if(UserId==nil)
    {
        
        NSString *message=[[NSString alloc] initWithFormat:
                           @"please select tag name"];
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"note"
                              message:message
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK!",nil];
        [alert show];
        [alert release];
        [message release];

    }
    else
    {NSLog(@"JEJE");
         
        NSLog(@"nm%@",UserName);
       NSLog(@"nid%@",self.UserId);
       

    [dataBase openDB];
    for(int i=0;i<[UrlList count];i++)
    {     NSString *insertTag= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,URL,NAME) VALUES('%@','%@','%@')",TAG,UserId,[UrlList objectAtIndex:i],UserName];
    [dataBase insertToTable:insertTag];
    }
    [dataBase closeDB];
    [self cancelTag];
    [self setPhotoTag];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                           object:self 
                                                         userInfo:dic1];
        

    }
}
-(IBAction)resetTags{
    for (Thumbnail *thum in self.crwAssets) {
        if ([thum tagOverlay]) {
            [thum setTagOverlayHidden:YES];
        }
    }
    [UrlList removeAllObjects];
}
-(IBAction)selectFromFavoriteNames{
    tagManagementController *nameController = [[tagManagementController alloc]init];
    nameController.bo=[NSString stringWithFormat:@"yes"];
	UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:nameController];
	[self presentModalViewController:navController animated:YES];
    [nameController release];
}
-(IBAction)selectFromAllNames{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [picker release]; 
}
-(IBAction)playPhotos{
    PhotoViewController *playPhotoController = [[PhotoViewController alloc]initWithPhotoSource:self.assetArrays];
    playPhotoController._pageIndex = 0;
    [playPhotoController fireTimer:@"cube"];
    [self.navigationController pushViewController:playPhotoController animated:YES];
    [playPhotoController release];
}

#pragma mark - 
#pragma mark notification method

-(void)setEditOverlay:(NSNotification *)notification{
    for (Thumbnail *thumbnail in self.crwAssets) {
        [thumbnail setOverlayHidden:YES];
    }
    
    [self setPhotoTag];
    
}

-(void)getSelectedUrls:(NSNotification *)note{
    
}
#pragma mark -
#pragma mark People picker delegate
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{

    
    NSString *readName=(NSString *)ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
    
    NSLog(@"readName:%@",readName);
    NSLog(@"recId:%d",recId);
  self.UserId=[NSString stringWithFormat:@"%d",recId];
   // NSLog(@"ID:%@",Id);
    UserName=readName;
  // NSLog(@"UserID%@",UserId);
  //  NSLog(@"Uname%@",UserName);
    //UserName=[NSString stringWithFormat:@"%@",readName];
   /* NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:Id,@"UserId",readName,@"UserName",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddUser" 
                                                     object:self 
                                                     userInfo:dic1];*/
   [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
#pragma mark -
#pragma mark UITableViewDataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([dateArry count]==0)
    {
        return 1;
    }
    else
    {
        return [dateArry count];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

		return ceil([crwAssets count] / 4.0);

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([dateArry count] == 0) {
        return nil;
    }else{
        return [dateArry objectAtIndex:section];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return dateArry;
}
-(NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);

    if(maxIndex < [self.crwAssets count]) {
        
        return [NSArray arrayWithObjects:[self.crwAssets objectAtIndex:index],
                [self.crwAssets objectAtIndex:index+1],
                [self.crwAssets objectAtIndex:index+2],
                [self.crwAssets objectAtIndex:index+3],
                nil];
    }
    
    else if(maxIndex-1 < [self.crwAssets count]) {
        
        return [NSArray arrayWithObjects:[self.crwAssets objectAtIndex:index],
                [self.crwAssets objectAtIndex:index+1],
                [self.crwAssets objectAtIndex:index+2],
                nil];
    }
    
    else if(maxIndex-2 < [self.crwAssets count]) {
        
        return [NSArray arrayWithObjects:[self.crwAssets objectAtIndex:index],
                [self.crwAssets objectAtIndex:index+1],
                nil];
    }
    
    else if(maxIndex-3 < [self.crwAssets count]) {
        
        return [NSArray arrayWithObject:[self.crwAssets objectAtIndex:index]];
    }
    
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ThumbnailCell *cell = (ThumbnailCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.tagOverlay = mode;
    if (cell == nil) 
    {		        
        cell = [[[ThumbnailCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] 
									 reuseIdentifier:CellIdentifier] autorelease];

    }	
	else 
    {		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) || toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma  mark -
#pragma  mark Memory management
-(void)viewDidUnload{
    self.table = nil;
    self.crwAssets = nil;
    self.assetArrays = nil;
    self.dataBase = nil;
    self.urlsArray = nil;
    self.viewBar = nil;
    self.tagBar = nil;
    self.save = nil;
    self.reset = nil;
    self.selectUrls = nil;
    self.dateArry = nil;
    [super viewDidUnload];
}

- (void)dealloc
{   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [selectName release];
    [viewBar release];
    [tagBar release];
    [cancel release];
    [save release];
    [reset release];
    [table release];
	[thuView release];
    [crwAssets release];
    [assetArrays release];
    [dataBase release];
    [urlsArray release];
    [selectUrls release];
    [dateArry release];
    [UserId release];
    [UserName release];
    [super dealloc];    
}


@end
