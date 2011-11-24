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
@synthesize images,PLAYID,lock;

#pragma mark -
#pragma mark UIViewController Methods
-(void)viewDidLoad {
   
    
    
    NSString *b=NSLocalizedString(@"Back", @"title");
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(huyou) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:b forState:UIControlStateNormal];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =backItem;
    [backItem release];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(0, 0, 37.0f, 37.0f);
    activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    self.navigationItem.titleView = activityView;
    _activityView = [activityView retain];
    [activityView release];
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
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    self.images = temp;
    [temp release];
    NSMutableArray *thumbNailArray = [[NSMutableArray alloc] init];
    NSMutableArray *temArray = [[NSMutableArray alloc] init];
    self.crwAssets = thumbNailArray;
    self.assetArrays = temArray;
    [thumbNailArray release];
    [temArray release];
    NSString *a=NSLocalizedString(@"Cancel", @"title");
    cancel = [[UIBarButtonItem alloc]initWithTitle:a style:UIBarButtonItemStyleDone target:self action:@selector(cancelTag)];
    
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
    alert1 = [[UIAlertView alloc]initWithTitle:@"请输入密码"  message:@"\n" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];  
    passWord = [[UITextField alloc] initWithFrame:CGRectMake(12, 40, 260, 30)];  
    passWord.backgroundColor = [UIColor whiteColor];  
    passWord.secureTextEntry = YES;
    [alert1 addSubview:passWord];  
    ME=NO;
    PASS=NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddUrl:) name:@"AddUrl" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemoveUrl:) name:@"RemoveUrl" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddUser:) name:@"AddUser" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setPhotoTag) name:@"setphotoTag" object:nil];
}
-(void)huyou
{
    NSString *a=NSLocalizedString(@"Lock", @"title");
 if([self.lock.title isEqualToString:a])
 {
     [self.navigationController popViewControllerAnimated:YES];
 }
 else
 {  
     [alert1 show];
     ME=NO;
 }
}
-(void)alertView:(UIAlertView *)alert1 didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *pass=[NSString stringWithFormat:@"%@",val];
       NSString *a=NSLocalizedString(@"Lock", @"title");
    NSString *b=NSLocalizedString(@"note", @"title");
    NSString *c=NSLocalizedString(@"ok", @"title");
    NSString *d=NSLocalizedString(@"The password is wrong", @"title");
    if(ME==NO)
    {
    switch (buttonIndex) {
        case 0:
            if(PASS==YES)
            {NSLog(@"FRF");
                NSLog(@"KKK%@",passWord2.text);
                if(passWord2.text==nil||passWord2.text.length==0)
                {
                    NSLog(@"KKK");
                }
                else
                {
                    NSLog(@"BULLL");
                NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults]; 
                [defaults1 setObject:passWord2.text forKey:@"name_preference"]; 
                }
                PASS=NO;
            }
            else if([passWord.text isEqualToString:pass])
            { 
            
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; 
                [defaults setObject:pass forKey:@"name_preference"];
                 self.lock.title=a;
                //[val release];
               
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:b
                                      message:d
                                      delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:c,nil];
                [alert show];
                [alert release];
                ME=YES;
               
            }
    }
    passWord.text=nil;
    }
}

-(void)creatTable
{
    [dataBase openDB];
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [dataBase createTable:createTag];  
    NSString *createUserTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY,NAME)",UserTable];
    [dataBase createTable:createUserTable];
    NSString *createIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT)",idOrder];//OrderID INTEGER PRIMARY KEY,
    [dataBase createTable:createIdOrder];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [dataBase createTable:createPlayTable];

    [dataBase closeDB];
}
-(void)AddUrl:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    NSString *str = [dic objectForKey:@"index"];
    [UrlList addObject:[self.urlsArray objectAtIndex:[str integerValue]]];
    if([UrlList count]!=0)
    {
        save.enabled = YES;
        reset.enabled = YES;
    }
}
-(void)RemoveUrl:(NSNotification *)note
{
    NSDictionary *dic = [note userInfo];
    NSString *str = [dic objectForKey:@"Removeurl"];
    [UrlList removeObject:[self.urlsArray objectAtIndex:[str integerValue]]];
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
    self.UserName=[dic objectForKey:@"UserName"];
    
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
        ALAssetsLibraryAssetForURLResultBlock assetRseult = ^(ALAsset *result) 
        {
            if (result == nil) 
            {
                return;
            }
            thuView = [[Thumbnail alloc] initWithAsset:result];
            thuView.fatherController = self;
            
            [self.crwAssets addObject:thuView];
            NSUInteger thumIndex = [self.crwAssets indexOfObject:thuView];
            
            thuView.index = thumIndex;
            thuView.assetArray = self.urlsArray;
            [dataBase openDB];
            
            NSString *resultUrl = [NSString stringWithFormat:@"%@",[[result defaultRepresentation]url]];

            NSString *selectTag= [NSString stringWithFormat:@"select * from tag where URL='%@'",resultUrl];
            [dataBase selectFromTAG:selectTag];
            
            NSInteger count = [dataBase.tagIdAry count];
            
            NSString *num=[NSString stringWithFormat:@"%d", count];

            if (count > 0) {
                [thuView setOverlayHidden:num];

            }
            [dataBase closeDB];
            
            [thuView release];
            //[self.assetArrays addObject:result];
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
            
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
    for (NSURL *assetUrl in self.urlsArray) {
        [assetUrl retain];
        [library assetForURL:assetUrl resultBlock:assetRseult failureBlock:failureBlock];
    }
    [library release];
    //[self setPhotoTag];
	[self.table reloadData];     
    [pool release];
}
-(void)setPhotoTag{
    
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
    NSString *a=NSLocalizedString(@"Lock", @"title");
    if([self.lock.title isEqualToString:a])
    {
    mode = YES;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = cancel;
    viewBar.hidden = YES;
    tagBar.hidden = NO;
    [self.table reloadData];
    }
    else
    {
        ME=NO;
        [alert1 show];
    }
}
-(IBAction)lockButtonPressed{
   
     NSString *a=NSLocalizedString(@"Lock", @"button");
    NSString *b=NSLocalizedString(@"UnLock", @"button");
    if([self.lock.title isEqualToString:a])
    { NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; 
        val=[[defaults objectForKey:@"name_preference"]retain];
        if(val==nil)
        { PASS=YES;
            NSLog(@"KO");
           UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"密码为空,请设置密码"  message:@"\n" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];  
            passWord2= [[UITextField alloc] initWithFrame:CGRectMake(12, 40, 260, 30)];  
            passWord2.backgroundColor = [UIColor whiteColor];  
            passWord2.secureTextEntry = YES;
            [alert2 addSubview:passWord2];  
            NSLog(@"UUUU%@",passWord2);
           
            [alert2 show];
            [alert2 release];
           
           // ME=YES;
        }
        else{
        [lock setTitle:b];
        }
    }
     else
     {   ME=NO;
        [alert1 show];
    }
   // [UIApplication sharedApplication].idleTimerDisabled = YES;
}
-(void)alert
{
    
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
    {
        [dataBase openDB];
        for(int i=0;i<[UrlList count];i++)
        {     NSString *insertTag= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,URL,NAME) VALUES('%@','%@','%@')",TAG,UserId,[UrlList objectAtIndex:i],self.UserName];
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
    [navController release];
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
    [dataBase openDB];
    PhotoViewController *playPhotoController = [[PhotoViewController alloc]initWithPhotoSource:self.urlsArray];
    playPhotoController._pageIndex = 0;
    //playPhotoController.photos = self.images;
     [dataBase getUserFromPlayTable:[PLAYID intValue]];
    [playPhotoController fireTimer:dataBase.Transtion];
    [self.navigationController pushViewController:playPhotoController animated:YES];
    [playPhotoController release];
    [dataBase closeDB];
}

#pragma mark - 
#pragma mark notification method

-(void)setEditOverlay:(NSNotification *)notification{
    //for (Thumbnail *thumbnail in self.crwAssets) {
    //  [thumbnail setOverlayHidden:YES];
    //}
    
    [self setPhotoTag];
    
}

-(void)getSelectedUrls:(NSNotification *)note{
    
}
#pragma mark -
#pragma mark People picker delegate
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    
    NSString *readName=(NSString *)ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
    
    self.UserId=[NSString stringWithFormat:@"%d",recId];
    self.UserName=readName;
    [dataBase openDB];
    NSString *insertUserTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,NAME) VALUES('%@','%@')",UserTable,self.UserId,readName];
    NSLog(@"%@",insertUserTable);
    [dataBase insertToTable:insertUserTable];
    
    
    NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES('%@')",idOrder,self.UserId];
    NSLog(@"%@",insertIdOrder);
    [dataBase insertToTable:insertIdOrder];   
    [dataBase openDB];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.UserId,@"UserId",readName,@"UserName",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddContact" 
                                                       object:self 
                                                     userInfo:dic];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ceil([crwAssets count] / 4.0);
    
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
    cell.loadSign = load;
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
    self.images = nil;
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
    [_activityView release], _activityView=nil;
    [images release];
    [UrlList release];
    [PLAYID release];
    [alert1 release];
    [val release];
    [super dealloc];    
}


@end
