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
//@synthesize dataBase;
@synthesize crwAssets,urlsArray,selectUrls,dateArry;
@synthesize table,val;
@synthesize viewBar,tagBar;
@synthesize save,reset,UserId,UrlList,UserName;
@synthesize images,PLAYID,lock;
@synthesize library;
@synthesize pool;
@synthesize operation1,operation2;
@synthesize operations;
@synthesize operation;

#pragma mark -
#pragma mark UIViewController Methods

-(void)viewDidLoad {
    done = YES;
    NSMutableArray *thumbNailArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<[self.urlsArray count]; i++) {
        [thumbNailArray addObject:[NSNull null]];
    }
    self.crwAssets = thumbNailArray;
    [thumbNailArray release];

   dataBase =[DBOperation getInstance];
    [self creatTable];
    
    
    /*
    ALAssetsLibrary *temLibrary = [[ALAssetsLibrary alloc] init]; 
    self.library = temLibrary;
    NSInteger threadNumber = 5;
    NSInteger countNum = ceil([self.urlsArray count]/threadNumber);
    queue = [[NSOperationQueue alloc]init];
    NSMutableArray *temoperations = [NSMutableArray arrayWithCapacity:threadNumber];
    self.operations = temoperations;
    [temoperations release];
    for (NSInteger i =0; i<threadNumber; i++) {
        NSString *begin = [NSString stringWithFormat:@"%d",i*countNum];
        NSString *end = nil;
        //NSInteger begin = i*countNum;
        //NSInteger end = 0;
        if (i!=threadNumber-1) {
            //end = (i+1)*countNum-1;
           end = [NSString stringWithFormat:@"%d",(i+1)*countNum-1];
            
        }else{
            //end = [self.urlsArray count]-1;
            end = [NSString stringWithFormat:@"%d",[self.urlsArray count]-1];

        }
        //NSArray *array = [NSArray arrayWithObjects:begin,end, nil];
        //MyNSOperation *operation = [[MyNSOperation alloc]initWithBeginIndex:begin endIndex:end storeThumbnails:self.crwAssets urls:self.urlsArray];
        //NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadPhotos:) object:array];
        //[operations addObject:operation];
        //[queue addOperation:operation];
    }
   // self.pool = [[PrepareThumbnail alloc]initWithUrls:self.urlsArray assetLibrary:library];
    
    [temLibrary release];*/
    
    
    //load thumbnails from another thread
    queue = [[NSOperationQueue alloc]init];
    NSInteger startAt = 0;
    NSInteger endAt = [self.urlsArray count]-1;
    MyNSOperation *tempOperation = [[MyNSOperation alloc]initWithBeginIndex:startAt endIndex:endAt storeThumbnails:self.crwAssets urls:self.urlsArray];
    self.operation = tempOperation;
    [tempOperation release];
    [queue addOperation:self.operation];

    NSString *b=NSLocalizedString(@"Back", @"title");
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(huyou) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:b forState:UIControlStateNormal];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =backItem;
    [backItem release];
    
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
    
    
       

    
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    self.images = temp;
    [temp release];
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
      

    alert1 = [[UIAlertView alloc]initWithTitle:@"请输入密码"  message:@"\n" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];  
    passWord = [[UITextField alloc] initWithFrame:CGRectMake(12, 40, 260, 30)];  
    passWord.backgroundColor = [UIColor whiteColor];  
    passWord.secureTextEntry = YES;
    [alert1 addSubview:passWord];  
    ME=NO;
    PASS=NO;
    //[self performSelectorInBackground:@selector(loadPhotos) withObject:nil];
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:.8];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddUrl:) name:@"AddUrl" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemoveUrl:) name:@"RemoveUrl" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddUser:) name:@"AddUser" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setPhotoTag) name:@"setphotoTag" object:nil];
   
}
-(void)loadPhotos:(NSArray *)array{
    NSAutoreleasePool *pools = [[NSAutoreleasePool alloc]init];
    NSDate *star = [NSDate date];
    NSInteger beginIndex = [[array objectAtIndex:0]integerValue];
    NSInteger endIndex = [[array objectAtIndex:1]integerValue];
    NSLog(@"begin index is %d",beginIndex);
    for (NSInteger i = beginIndex; i<=endIndex; i++) {
        ALAssetsLibraryAssetForURLResultBlock assetRseult = ^(ALAsset *result) 
    {
        if (result == nil) 
        {
            return;
        }
        //Thumbnail *thumbNail = [[Thumbnail alloc]initWithAsset:result];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageWithCGImage:[result thumbnail]] forState:UIControlStateNormal];
        [self.crwAssets replaceObjectAtIndex:i withObject:button];        
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                         message:[NSString stringWithFormat:@"Error: %@", [error description]] 
                                                        delegate:nil 
                                               cancelButtonTitle:@"Ok" 
                                               otherButtonTitles:nil];
        [alert show];
        [alert release];
        NSLog(@"A problem occured %@", [error description]);                                     
    };    
    
        
//            if ([op isCancelled]) {
//                NSLog(@"return thread");
//                return;
//        }
        [self.library assetForURL:[self.urlsArray objectAtIndex:i] resultBlock:assetRseult failureBlock:failureBlock];
    }
    [self.table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
   // [self performSelectorOnMainThread:@selector(setPhotoTag) withObject:nil waitUntilDone:NO];
    NSDate *finish = [NSDate date];
    NSTimeInterval excuteTime = [finish timeIntervalSinceDate:star];
    NSLog(@"finish time is %f",excuteTime);
    [pools release];
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
            {
                if(passWord2.text==nil||passWord2.text.length==0)
                {
                }
                else
                {
                NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults]; 
                [defaults1 setObject:passWord2.text forKey:@"name_preference"]; 
                }
                PASS=NO;
            }
            else if([passWord.text isEqualToString:pass])
            { NSString *deletePassTable= [NSString stringWithFormat:@"DELETE FROM PassTable"];	
                NSLog(@"%@",deletePassTable);
                [dataBase deleteDB:deletePassTable];
            
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; 
                [defaults setObject:pass forKey:@"name_preference"];
                 self.lock.title=a;               
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
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [dataBase createTable:createTag]; 
    NSString *createPassTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(LOCK,PASSWORD,PLAYID)",PassTable];
    [dataBase createTable:createPassTable];
    NSString *createUserTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY,NAME)",UserTable];
    [dataBase createTable:createUserTable];
    NSString *createIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY)",idOrder];//OrderID INTEGER PRIMARY KEY,
    [dataBase createTable:createIdOrder];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [dataBase createTable:createPlayTable];

}
-(void)AddUrl:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    NSString *str = [dic objectForKey:@"index"];
    NSLog(@"index:%@",str);
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

-(void)viewWillDisappear:(BOOL)animated{

    self.operation.stopOperation = YES;
    [self.operation cancel];
}
-(void)viewDidDisappear:(BOOL)animated{
//    for (Thumbnail *thub in crwAssets) {
//        [thub setSelectOvlay];
//    }
}
-(void)setPhotoTag{
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG;";
    NSMutableArray *photos = [dataBase selectPhotos:selectSql];
    for (NSString *dataStr in photos) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        for (Thumbnail *thumbnail in self.crwAssets) {
            NSUInteger index = [self.crwAssets indexOfObject:thumbnail];
            NSURL *thumStr = [self.urlsArray objectAtIndex:index];
            if ([dbStr isEqual:thumStr]) {
                NSString *selectTag= [NSString stringWithFormat:@"select count(*) from tag where URL='%@'",dbStr];
                NSInteger count = [[[dataBase selectFromTAG:selectTag]objectAtIndex:0]intValue];               
                NSString *num=[NSString stringWithFormat:@"%d",count];
                [thumbnail setOverlayHidden:num];
                
            }
        }
    } 
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
           UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"密码为空,请设置密码"  message:@"\n" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];  
            passWord2= [[UITextField alloc] initWithFrame:CGRectMake(12, 40, 260, 30)];  
            passWord2.backgroundColor = [UIColor whiteColor];  
            passWord2.secureTextEntry = YES;
            [alert2 addSubview:passWord2];  
            [alert2 show];
            [alert2 release];
        }
        else{
            NSString *deletePassTable= [NSString stringWithFormat:@"DELETE FROM PassTable"];
            [dataBase deleteDB:deletePassTable];
            //for(int i=0;i<[self.urlsArray count];i++)
            // {
            NSString *insertPassTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(LOCK,PASSWORD,PLAYID) VALUES('%@','%@','%@')",PassTable,@"UnLock",val,self.PLAYID];
            [dataBase insertToTable:insertPassTable];

        [lock setTitle:b];
        }
    }
     else
     {   ME=NO;
        [alert1 show];
    }
}
-(void)alert
{
    
}
-(IBAction)saveTags{
    if(UserId==nil)
    {
        ME=YES;
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
    {NSLog(@"JIDSJ%d",[self.UrlList count]);
        for(int i=0;i<[self.UrlList count];i++)
        {     NSString *insertTag= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,URL,NAME) VALUES('%@','%@','%@')",TAG,UserId,[self.UrlList objectAtIndex:i],self.UserName];
            NSLog(@"JJJJ%@",insertTag);
            [dataBase insertToTable:insertTag];
        }
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
    PhotoViewController *playPhotoController = [[PhotoViewController alloc]initWithPhotoSource:self.urlsArray currentPage:0];
    [dataBase getUserFromPlayTable:[PLAYID intValue]];
    [playPhotoController fireTimer:dataBase.Transtion];
    [self.navigationController pushViewController:playPhotoController animated:YES];
    [playPhotoController release];
}

#pragma mark - 
#pragma mark notification method

-(void)setEditOverlay:(NSNotification *)notification{
    
    [self setPhotoTag];
    
}

#pragma mark -
#pragma mark People picker delegate
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    
    NSString *readName=(NSString *)ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
    
    self.UserId=[NSString stringWithFormat:@"%d",recId];
    self.UserName=readName;
    NSString *insertUserTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,NAME) VALUES('%@','%@')",UserTable,self.UserId,readName];
    NSLog(@"%@",insertUserTable);
    [dataBase insertToTable:insertUserTable];
    
    
    NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID) VALUES('%@')",idOrder,self.UserId];
    NSLog(@"%@",insertIdOrder);
    [dataBase insertToTable:insertIdOrder];   
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
    
    return ceil([self.urlsArray count] / 4.0);
    
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
    //NSDate *methodStart = [NSDate date];
    static NSString *CellIdentifier = @"Cell";
    ThumbnailCell *cell = (ThumbnailCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.tagOverlay = mode;
    cell.loadSign = load;
    if (cell == nil) 
    {	
            //cell = [[[ThumbnailCell alloc] initWithThumbnailPool:pool reuseIdentifier:CellIdentifier] autorelease];

            cell = [[[ThumbnailCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier]autorelease];
    }
    else{
        [cell setAssets:[self assetsForIndexPath:indexPath]];
    }
        //[cell prepareThumailIndex:indexPath.row count:4];

   

    cell.allUrls = self.urlsArray;
    cell.passViewController = self;
    //NSDate *methodFinish = [NSDate date];
    //NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    //NSLog(@"CellForRow return UITableViewCell time is %f",executionTime);
   // NSLog(@"-----------------------------------------------------------");
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
- (oneway void)release
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:NO];
    } else {
        [super release];
    }
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
    [crwAssets release];
    [urlsArray release];
    [selectUrls release];
    [dateArry release];
    [UserId release];
    [UserName release];
    [images release];
    [UrlList release];
    [PLAYID release];
    [alert1 release];
    [val release];
    [queue release];
    [operation release];
    [super dealloc];    
}


@end
