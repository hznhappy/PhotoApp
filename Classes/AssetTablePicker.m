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
#import <AVFoundation/AVFoundation.h>


@implementation AssetTablePicker
@synthesize crwAssets,urlsArray,dateArry;
@synthesize table,val;
@synthesize viewBar,tagBar;
@synthesize save,reset,UserId,UrlList,UserName;
@synthesize images,PLAYID,lock;
@synthesize library;
@synthesize operation1,operation2;
@synthesize operations;
@synthesize operation;
@synthesize tagRow;
@synthesize destinctUrl;
@synthesize photos;
#pragma mark -
#pragma mark UIViewController Methods

-(void)viewDidLoad {
  
    done = YES;
    action=YES;
   dataBase =[DBOperation getInstance];
    [self creatTable];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSMutableArray *array1=[[NSMutableArray alloc]init];
    self.tagRow=array;
    self.photos=array1;
    [array release];
    [array1 release];
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
    alert1 = [[UIAlertView alloc]initWithTitle:@"请输入密码"  message:@"\n" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];  
    passWord = [[UITextField alloc] initWithFrame:CGRectMake(12, 40, 260, 30)];  
    passWord.backgroundColor = [UIColor whiteColor];  
    passWord.secureTextEntry = YES;
    [alert1 addSubview:passWord];  
    ME=NO;
    PASS=NO;
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:.3];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddUser:) name:@"AddUser" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(EditPhotoTag)name:@"EditPhotoTag" object:nil];
    [self setPhotoTag];
}

-(void)getAssets:(ALAsset *)asset{
    [self.crwAssets addObject:asset];
}
-(void)EditPhotoTag
{
    [self setPhotoTag];
    [self.table reloadData];
}
-(void)loadPhotos:(NSArray *)array{
    NSAutoreleasePool *pools = [[NSAutoreleasePool alloc]init];
    NSDate *star = [NSDate date];
    NSInteger beginIndex = [[array objectAtIndex:0]integerValue];
    NSInteger endIndex = [[array objectAtIndex:1]integerValue];
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
    self.operation.stopOperation = YES;
    [self.operation cancel];
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

}
-(void)viewDidDisappear:(BOOL)animated{
}
-(void)setPhotoTag{
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG;";
    self.photos = [dataBase selectPhotos:selectSql];
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
    action=YES;
    [self resetTags];
    
    [self.table reloadData];
}

-(IBAction)actionButtonPressed{
    action=NO;
    NSString *a=NSLocalizedString(@"Lock", @"title");
    if([self.lock.title isEqualToString:a])
    {
    mode = YES;
    save.enabled=YES;
    reset.enabled=YES;
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
    [self.tagRow removeAllObjects];
    [UrlList removeAllObjects];
    [self.table reloadData];
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
    PhotoViewController *playPhotoController = [[PhotoViewController alloc]initWithPhotoSource:self.crwAssets currentPage:0];
    [dataBase getUserFromPlayTable:PLAYID];
    NSLog(@"PLAYID:%@",PLAYID);
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

    if (UIInterfaceOrientationIsLandscape(oritation)) {
        return ceil([self.crwAssets count]/6.0);
    }else
        return ceil([self.crwAssets count]/4.0);    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) 
    {	
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];

    }
     
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGRect frame = CGRectMake(4, 2, 75, 75);
    
    NSInteger loopCount = 0;
    if (UIInterfaceOrientationIsLandscape(oritation)) {
        loopCount = 6;
    }else
        loopCount = 4;
    for (NSInteger i = 0; i<loopCount; i++) {
        NSInteger row = (indexPath.row*4)+i;
        if (row<[self.crwAssets count]) {
            
            ALAsset *asset = [self.crwAssets objectAtIndex:row];
            NSURL *url=[[asset defaultRepresentation]url];
            UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
             
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:frame];
            [button setImage:image forState:UIControlStateNormal];
            [button setTag:row];
            [button addTarget:self action:@selector(viewPhotos:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            frame.origin.x = frame.origin.x + frame.size.width + 4;   
            NSString *ROW=[NSString stringWithFormat:@"%d",row];
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) 
            {
                NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                 forKey:AVURLAssetPreferPreciseDurationAndTimingKey];           
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts]; 
                
                minute = 0, second = 0; 
                second = urlAsset.duration.value / urlAsset.duration.timescale;
                if (second >= 60) {
                    int index = second / 60;
                    minute = index;
                    second = second - index*60;                        
                }    
                [button addSubview:[self CGRectMake2]];
                
            }

            if([self.tagRow containsObject:ROW])
            { [self CGRectMake];
                [button addSubview:[self CGRectMake]]; 
               
            }
            if([photos containsObject:url])
            {   [self CGRectMake1];
                [button addSubview:[self CGRectMake1]];
                NSString *selectTag= [NSString stringWithFormat:@"select count(*) from tag where URL='%@'",url];
                NSInteger count1 = [[[dataBase selectFromTAG:selectTag]objectAtIndex:0]intValue];              
                count.text =[NSString stringWithFormat:@"%d",count1];
                [count release];
               
                
            }

        }
    }
    return cell;
}

-(UIImageView *)CGRectMake
{
    CGRect viewFrames = CGRectMake(0, 0, 75, 75);
   UIImageView *overlayView = [[[UIImageView alloc]initWithFrame:viewFrames]autorelease];
    [overlayView setImage:[UIImage imageNamed:@"selectOverlay.png"]];
    return overlayView;
}
-(UIView *)CGRectMake1
{
    UIView *tagBg =[[[UIView alloc]initWithFrame:CGRectMake(3, 3, 25, 25)]autorelease];
    CGPoint tagBgCenter = tagBg.center;
    tagBg.layer.cornerRadius = 25 / 2.0;
    tagBg.center = tagBgCenter;
    
    UIView *tagCount = [[UIView alloc]initWithFrame:CGRectMake(2.6, 2.2, 20, 20)];
    tagCount.backgroundColor = [UIColor colorWithRed:182/255.0 green:0 blue:0 alpha:1];
    CGPoint saveCenter = tagCount.center;
    tagCount.layer.cornerRadius = 20 / 2.0;
    tagCount.center = saveCenter;
    count= [[UILabel alloc]initWithFrame:CGRectMake(3, 4, 13, 12)];
    count.backgroundColor = [UIColor colorWithRed:182/255.0 green:0 blue:0 alpha:1];
    count.textColor = [UIColor whiteColor];
    count.textAlignment = UITextAlignmentCenter;
    count.font = [UIFont boldSystemFontOfSize:11];
    [tagCount addSubview:count];
    [tagBg addSubview:tagCount];
    [tagCount release];
    return tagBg;
   
}
-(UIView *)CGRectMake2
{UIView *video =[[[UIView alloc]initWithFrame:CGRectMake(0, 54, 74, 16)]autorelease];
    UILabel *length=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 44, 16)];
    UIButton *tu=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 16)];
  //  tu= [UIButton buttonWithType:UIButtonTypeCustom]; 
    UIImage *picture = [UIImage imageNamed:@"VED.png"];
    // set the image for the button
    [tu setBackgroundImage:picture forState:UIControlStateNormal];
    [video addSubview:tu];
    

    [length setBackgroundColor:[UIColor grayColor]];
    length.alpha=0.8;
    NSString *a=[NSString stringWithFormat:@"%d",minute];
     NSString *b=[NSString stringWithFormat:@"%d",second];
    length.text=a;
    length.text=[length.text stringByAppendingString:@":"];
    length.text=[length.text stringByAppendingString:b];
    [video addSubview:length];
    [length release];
    [tu release];
    [video setBackgroundColor:[UIColor grayColor]];
    video.alpha=0.8;
    return video;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}

-(void)viewPhotos:(id)sender{
    
    UIButton *button1= (UIButton *)sender;
    NSLog(@"button tag:%d",button1.tag);
    NSString *row=[NSString stringWithFormat:@"%d",button1.tag];
    ALAsset *asset = [self.crwAssets objectAtIndex:button1.tag];
    NSString *url = [[[asset defaultRepresentation]url] description];
    if(action==YES)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.crwAssets forKey:[NSString stringWithFormat:@"%d",button1.tag]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"viewPhotos" object:nil userInfo:dic];    
    }
    else
    {
        if([self.tagRow containsObject:row])
        {
            [self.UrlList removeObject:url];
            [self.tagRow removeObject:row];
        }
        else
        {   [self.UrlList addObject:url];
            [self.tagRow addObject:row];
        }
    }
    [self.table reloadData];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    oritation = toInterfaceOrientation;
	return (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) || toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    oritation = toInterfaceOrientation;
    if ((UIInterfaceOrientationIsLandscape(oritation) && UIInterfaceOrientationIsLandscape(previousOrigaton))||(UIInterfaceOrientationIsPortrait(oritation)&&UIInterfaceOrientationIsPortrait(previousOrigaton))) {
        return;
    }
    UIEdgeInsets insets = self.table.contentInset;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [self.table setContentInset:UIEdgeInsetsMake(insets.top-10, insets.left, insets.bottom, insets.right)];
    }else{
        [self.table setContentInset:UIEdgeInsetsMake(insets.top+10, insets.left, insets.bottom, insets.right)];
    }
    previousOrigaton = toInterfaceOrientation;
        [self.table reloadData];
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
    self.dateArry = nil;
    self.images = nil;
    [super viewDidUnload];
}


- (void)dealloc
{   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [viewBar release];
    [tagBar release];
    [cancel release];
    [save release];
    [reset release];
    [table release];
    [crwAssets release];
    [urlsArray release];
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
    [tagRow release];
    [photos release];
    [super dealloc];    
}


@end
