//
//  PhotoViewController.m
//  PhotoApp
//
//  Created by Andy on 10/12/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PhotoViewController.h"
#import "PopupPanelView.h"
#import "tagManagementController.h"
#import "PhotoImageView.h"
#import "CropView.h"
#import "AssetRef.h"
#import "PhotoSource.h"




@interface PhotoViewController (Private)
- (void)loadScrollViewWithPage:(NSInteger)page;
- (void)layoutScrollViewSubviews;
- (void)setupScrollViewContentSize;
- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex;
- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (NSInteger)centerPhotoIndex;
- (void)setupToolbar;
- (void)setupEditToolbar;
- (void)setViewState;
- (void)autosizePopoverToImageSize:(CGSize)imageSize photoImageView:(PhotoImageView*)photoImageView;
@end

@implementation UIImage (Crop)

- (UIImage *)crop:(CGRect)rect {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    if (scale>1.0) {        
        rect = CGRectMake(rect.origin.x*scale , rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);        
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    return result;
}

@end

@implementation PhotoViewController
//@synthesize listid;
@synthesize ppv;
@synthesize scrollView=_scrollView;
@synthesize photoSource; 
@synthesize photoViews=_photoViews;
@synthesize _pageIndex;
@synthesize fullScreenPhotos;
@synthesize video;
@synthesize cropView;

- (id)initWithPhotoSource:(NSArray *)aSource currentPage:(NSInteger)page{
	if ((self = [super init])) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleBarsNotification:) name:@"PhotoViewToggleBars" object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewDidFinishLoading:) name:@"PhotoDidFinishLoading" object:nil];
		
		self.hidesBottomBarWhenPushed = YES;
		self.wantsFullScreenLayout = YES;		
		photoSource = [aSource retain];
        self._pageIndex = page;
//        NSMutableArray *temp = [[NSMutableArray alloc] init];
//        for (unsigned i = 0; i < [self.photoSource count]; i++) {
//            [temp addObject:[NSNull null]];
//        }
//        self.fullScreenPhotos = temp;
//        [temp release];
	}
//    NSString *pageIndex = [NSString stringWithFormat:@"%d",self._pageIndex];
//	[self performSelectorOnMainThread:@selector(readPhotoFromALAssets:) withObject:pageIndex waitUntilDone:NO];
    
    return self;
}
-(void)play:(CGRect)framek
{
        
   
    playButton.frame =framek;
        [self.scrollView addSubview:playButton];
    


}
-(void)CFG
{
    db=[DBOperation getInstance];
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [db createTable:createTag];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [db createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT PRIMARY KEY)",playIdOrder];
    [db createTable:createPlayIdOrder];
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [db createTable:createRules];
    favorite=[[UIView alloc]initWithFrame:CGRectMake(1,160,80,150)];
    [favorite setBackgroundColor:[UIColor grayColor]];
   favorite.alpha=0.6;
    UIImage *bubble = [UIImage imageNamed:@"bubble.png"];
	bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];

    bubbleImageView.frame = CGRectMake(0,0,80,150);
    //[favorite addSubview:bubbleImageView];

    UILabel *note=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
    [note setBackgroundColor:[UIColor clearColor]];
    note.numberOfLines = 10;  
    note.text = @"Do you like it?";
   
    //note.baselineAdjustment = UIBaselineAdjustmentNone; 
    //note.highlighted = YES;       

    //note.highlightedTextColor = [UIColor whiteColor];      
    note.textColor = [UIColor whiteColor];
    note.font = [UIFont boldSystemFontOfSize:18];
     //[note setText:@"do you like it?"];
    CGSize size = CGSizeMake(60, 1000);
    CGSize labelSize = [note.text sizeWithFont:note.font 
                              constrainedToSize:size
                                  lineBreakMode:UILineBreakModeClip];
    note.frame = CGRectMake(note.frame.origin.x, note.frame.origin.y,
                             note.frame.size.width,labelSize.height);
   [favorite addSubview:note];
    [note release];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom]; 
    button1.frame = CGRectMake(10, 80, 60, 30);
    [button1 setBackgroundColor:[UIColor clearColor]]; 
    [button1 setTitle:@"YES" forState:UIControlStateNormal];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom]; 
    button2.frame = CGRectMake(10, 115, 60, 30);
    [button2 setBackgroundColor:[UIColor clearColor]]; 
    [button2 setTitle:@"NO" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchDown];
    [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchDown];
   [favorite addSubview:button1];
   [favorite addSubview:button2];
    //favorite.hidden=YES;
    

}
-(void)favorite:(NSString *)inter
{  
    if([inter integerValue]==_pageIndex)
    {
         //favorite.hidden=NO;
    NSLog(@"FACORITE");
    [self.view addSubview:favorite];
   // 
       
        
        [UIView animateWithDuration:0.5 
                         animations:^{
                             //myPickerView.frame = CGRectMake(0, 210, 310, 180);
                             favorite.alpha = 0.6;
                         }];
        

        //favorite.hidden=NO;

    }
  //  [favorite CommitAnimations];
}
-(void)button1Pressed
{
    NSLog(@"button1");
   // favorite.hidden=YES;
    [UIView animateWithDuration:0.8 
                     animations:^{
                         //myPickerView.frame = CGRectMake(0, 210, 310, 180);
                        favorite.alpha = 0;
                     }];
    NSString *insertTag= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,URL,NAME) VALUES('%d','%@','%@')",TAG,-1,[[realasset defaultRepresentation]url],@"like"];
    NSLog(@"JJJJ%@",insertTag);
    [db insertToTable:insertTag];
    NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_id,playList_name) VALUES(%d,'%@')",PlayTable,-3,@"I LIKE"];
    NSLog(@"%@",insertPlayTable);
    [db insertToTable:insertPlayTable];
    NSString *insertPlayIdOrder= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,-3];
    NSLog(@"%@",insertPlayIdOrder);
    [db insertToTable:insertPlayIdOrder];
    NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%d','%d','%d','%@')",Rules,-3,1,-1,@"like"];
    NSLog(@"%@",insertRules);
    [db insertToTable:insertRules];  
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addfavorate" 
                                                       object:self 
                                                     userInfo:dic];
}
-(void)button2Pressed
{
    NSLog(@"button2");
   // favorite.hidden=YES;
    [UIView animateWithDuration:0.8 
                     animations:^{
                         //myPickerView.frame = CGRectMake(0, 210, 310, 180);
                         favorite.alpha = 0;
                     }];

}
//-(void)readPhotoFromALAssets:(NSString *)pageIndex{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    NSInteger index = [pageIndex integerValue];
//    for (NSInteger i = index-2; i<index+3; i++) {
//        if (i >= 0 && i < [self.photoSource count]) {
//            UIImage *fullImage = [self.fullScreenPhotos objectAtIndex:i];
//            if ((NSNull *)fullImage == [NSNull null] ) {
//            ALAsset *asset = [self.photoSource objectAtIndex:i];
//            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation]fullScreenImage]];
//            [self.fullScreenPhotos replaceObjectAtIndex:i withObject:image];
//                
//            }
//        }
//    }
//    
//    [pool release];
//}

#pragma mark -
#pragma mark View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    VI=NO;
    [self CFG];
    self.hidesBottomBarWhenPushed = YES;
    self.wantsFullScreenLayout = YES;
	self.view.backgroundColor = [UIColor blackColor];
    
	if (!_scrollView) {
		
		_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
		_scrollView.delegate=self;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		_scrollView.multipleTouchEnabled=YES;
		_scrollView.scrollEnabled=YES;
		_scrollView.directionalLockEnabled=YES;
		_scrollView.canCancelContentTouches=YES;
		_scrollView.delaysContentTouches=YES;
		_scrollView.clipsToBounds=YES;
		_scrollView.alwaysBounceHorizontal=YES;
		_scrollView.bounces=YES;
		_scrollView.pagingEnabled=YES;
		_scrollView.showsVerticalScrollIndicator=NO;
		_scrollView.showsHorizontalScrollIndicator=NO;
		_scrollView.backgroundColor = self.view.backgroundColor;
		[self.view addSubview:_scrollView];
        
	}
    NSMutableArray *views = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.photoSource count]; i++) {
		[views addObject:[NSNull null]];
	}
   NSMutableArray *array=[[NSMutableArray alloc]init];
    self.video=array;
	self.photoViews = views;
    [views release];
    [array release];
    
    tagShow = NO;
    editing=NO;
    croping = NO;
    NSString *u=NSLocalizedString(@"Edit", @"title");
    NSString *save = NSLocalizedString(@"Save", @"title");
    edit=[[UIBarButtonItem alloc]initWithTitle:u style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
    saveItem=[[UIBarButtonItem alloc]initWithTitle:save style:UIBarButtonItemStyleDone target:self action:@selector(savePhoto)];

   	self.navigationItem.rightBarButtonItem=edit;
    
    ppv = [[PopupPanelView alloc] initWithFrame:CGRectMake(0, 62, 320, 375)];
    //ALAsset *asset = [self.photoSource objectAtIndex:_pageIndex]->_asset;
   // NSString *currentPageUrl=[[[asset defaultRepresentation]url]description];
    //ppv.url = currentPageUrl;
    ppv.alpha = 0.4;
    [ppv Buttons];
    [ppv viewClose];
    
    
    playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *picture = [UIImage imageNamed:@"ji.png"];
    // set the image for the button
    [playButton setBackgroundImage:picture forState:UIControlStateNormal];
    [playButton setImage:picture forState:UIControlStateNormal];
}
-(void)playVideo
{
    ALAsset *realasset1 =[self.photoSource objectAtIndex:_pageIndex];
       NSLog(@"alasset:%@",realasset1);
    ALAssetRepresentation *ref = [realasset1 defaultRepresentation];
    NSURL *url = [ref url];
    NSLog(@"%@ is the url ",url);
       
    theMovie=[[MPMoviePlayerController alloc] initWithContentURL:url]; 
  //  NSTimeInterval duration = theMovie.duration;
  //  NSLog(@"LENGTH:%f",theMovie.duration);

    [[theMovie view] setFrame:[self.view bounds]]; // Frame must match parent view
    [self.view addSubview:[theMovie view]];
    //theMovie.scalingMode =  MPMovieControlModeDefault;
   // theMovie.scalingMode=MPMovieScalingModeAspectFill; 
    theMovie.scalingMode=MPMovieMediaTypeMaskAudio;
    theMovie.controlStyle = MPMovieControlModeHidden;
    //theMovie.scalingMode = MPMovieScalingModeFill;
    //   UIImage *imageSel = [theMovie thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    // Register for the playback finished notification. 
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(myMovieFinishedCallback:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:theMovie]; 
    
    // Movie playback is asynchronous, so this method returns immediately. 
    [theMovie play];  
    
    
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchBegan");
    [self setBarsHidden:!_barsHidden animated:YES];
    
    
    
}
// When the movie is done,release the controller. 
-(void)myMovieFinishedCallback:(NSNotification*)aNotification 
 {
 MPMoviePlayerController* theMovie2=[aNotification object]; 
 [[NSNotificationCenter defaultCenter] removeObserver:self 
 name:MPMoviePlayerPlaybackDidFinishNotification 
 object:theMovie2]; 
 // Release the movie instance created in playMovieAtURL
 //[theMovie2 release]; 
 }
-(void)viewDidAppear:(BOOL)animated{
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    NSLog(@"why is null %@",photoView);
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
        [photoView setClearPhoto];   
    }

}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
	[self setupToolbar];
	[self setupScrollViewContentSize];
    [self moveToPhotoAtIndex:_pageIndex animated:NO];
    [self startToLoadImageAtIndex:_pageIndex];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [theMovie stop];
    
    [timer invalidate];
	[super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];		
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);
	
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    _rotating = YES;
    NSInteger count = 0;
    for (PhotoImageView *view in self.photoViews){
        if ([view isKindOfClass:[PhotoImageView class]]) {
            if (count != _pageIndex) {
                [view setHidden:YES];
            }
        }
        count++;
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    for (PhotoImageView *view in self.photoViews){
        if ([view isKindOfClass:[PhotoImageView class]]) {
            [view rotateToOrientation:toInterfaceOrientation];
        }
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    [self setupScrollViewContentSize];
    [self moveToPhotoAtIndex:_pageIndex animated:NO];
    [self.scrollView scrollRectToVisible:((PhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).frame animated:YES];
    
    //  unhide side views
    for (PhotoImageView *view in self.photoViews){
        if ([view isKindOfClass:[PhotoImageView class]]) {
            [view setHidden:NO];
        }
    }
    _rotating = NO;
    
}

- (void)setupToolbar {
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonHit:)];
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	if ([self.photoSource count] > 1) {
		
		UIBarButtonItem *fixedCenter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedCenter.width = 80.0f;
		UIBarButtonItem *fixedLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedLeft.width = 40.0f;
		
        
		
		UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left.png"] 
                                                                 style:UIBarButtonItemStylePlain 
                                                                target:self action:@selector(moveBack:)];
        
		UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right.png"] 
                                                                  style:UIBarButtonItemStylePlain 
                                                                 target:self 
                                                                 action:@selector(moveForward:)];
		
		[self setToolbarItems:[NSArray arrayWithObjects:fixedLeft, flex, left, fixedCenter, right, flex, action, nil]];
		
		_rightButton = right;
		_leftButton = left;
		
		[fixedCenter release];
		[fixedLeft release];
		[right release];
		[left release];
		
	} else {
		[self setToolbarItems:[NSArray arrayWithObjects:flex, action, nil]];
	}
	
	_actionButton=action;
	self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
	[action release];
	[flex release];
	
}

#pragma mark -
#pragma mark EditMethods
-(void)edit
{
    self.navigationItem.rightBarButtonItem = saveItem;
    saveItem.enabled = NO;
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *cancell = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];
    self.navigationItem.leftBarButtonItem = cancell;
    [self setupEditToolbar];
    editing = YES;
    if (!self.scrollView.scrollEnabled) {
        self.scrollView.scrollEnabled = YES;
    }
    
}

-(void)cancelEdit{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = edit;
    [self setupToolbar];
    self.navigationItem.hidesBackButton = NO;
    editing = NO;
    if (cropView.superview!=nil) {
        [cropView removeFromSuperview];
    } 
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
        if (photoView.alpha!=1.0) {
            photoView.alpha = 1.0;
        }
    }
    if (!self.scrollView.scrollEnabled) {
        self.scrollView.scrollEnabled = YES;
    }
}

- (void)setupEditToolbar{
    [self setToolbarItems:nil];
    UIBarButtonItem *rotate = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"refresh.png"] 
                                                              style:UIBarButtonItemStylePlain 
                                                             target:self 
                                                             action:@selector(rotatePhoto)];
    
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *tag = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tag.png"] 
                                                           style:UIBarButtonItemStylePlain 
                                                          target:self 
                                                          action:@selector(markPhoto)];
    
    UIBarButtonItem *crop = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"wrench.png"]
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self 
                                                                               action:@selector(cropPhoto)];
    [self setToolbarItems:[NSArray arrayWithObjects:rotate,flex,tag,flex,crop, nil]];
    
    [rotate release];
    [flex release];
    [crop release];
    [tag release];
}

-(void)rotatePhoto{
    if (self.navigationItem.rightBarButtonItem == nil) {
        UIBarButtonItem *cropItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveCropPhoto:)];
        self.navigationItem.rightBarButtonItem = cropItem;
        [cropItem release];
    }
       
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    self.navigationItem.rightBarButtonItem.title = @"Save";
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
   
        [photoView rotatePhoto];
        [self.cropView setCropView];
    }
}

- (void)markPhoto{
    if (tagShow)
    {  
        [ppv viewClose];
    }
    else{
        if (ppv.superview == nil) {
            [self.view addSubview:ppv];
        }
        [ppv viewOpen];
    }
    tagShow = !tagShow;

    
}



-(void)cropPhoto{
    
    if (!self.scrollView.scrollEnabled) {
        self.scrollView.scrollEnabled = YES;
    }else{
        self.scrollView.scrollEnabled = NO;
    }
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
        
        
        if (cropView.superview!=nil) {
            self.navigationItem.rightBarButtonItem = nil;
            [cropView removeFromSuperview];
            photoView.alpha = 1.0;
            self.navigationItem.rightBarButtonItem = saveItem;
            saveItem.enabled = NO;
            croping = NO;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
            UIBarButtonItem *cropItem=[[UIBarButtonItem alloc]initWithTitle:@"Crop" style:UIBarButtonItemStyleDone target:self action:@selector(setCropPhoto:)];
            self.navigationItem.rightBarButtonItem = cropItem;
            [cropItem release];
            
            photoView.alpha = 0.4;
            CropView *temCV = [[CropView alloc]initWithFrame:CGRectMake(60, 140, 200, 200) ImageView:photoView superView:self.view];
            temCV.backgroundColor = [UIColor clearColor];
            self.cropView = [temCV retain];
            [temCV release];
            
            [self.view addSubview:cropView];
            croping = YES;
        }
    }

}

-(void)setCropPhoto:(id)sender{
    self.navigationItem.rightBarButtonItem = saveItem;
    if (!saveItem.enabled) {
        saveItem.enabled = YES;
    }
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
        photoView.alpha =1.0;
        [photoView setPhoto:self.cropView.cropImage];
    }
    [cropView removeFromSuperview];
}

-(void)savePhoto{
    if (!self.scrollView.scrollEnabled) {
        self.scrollView.scrollEnabled = YES;
    }
    saveItem.enabled = NO;
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView == nil || (NSNull *)photoView == [NSNull null]) {
        return;
    }else{
        [photoView savePhoto];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"The photo already save to camera roll!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
}
/*
- (UIImage *)croppedPhoto
{
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView == nil || (NSNull *)photoView == [NSNull null]) {
        return nil;
    }else{
        UIImage *orignImage = photoView.photo;
        UIScrollView *pScrollView = (UIScrollView *)photoView.scrollView;
        CGFloat zoomScale = pScrollView.zoomScale;
        
        CGFloat hfactor = photoView.imageView.image.size.width / photoView.imageView.frame.size.width;
        CGFloat vfactor = photoView.imageView.image.size.height / photoView.imageView.frame.size.height;
//        CGRect visibleRect;
//        visibleRect.origin = pScrollView.contentOffset;
//        visibleRect.size = pScrollView.bounds.size;
//       // NSLog(@"scrollview frame is %@",NSStringFromCGRect(pScrollView.frame));
//       // NSLog(@"scrollview bounds is %@",NSStringFromCGRect(pScrollView.bounds));
//        float theScale = 1.0 / zoomScale;
//        visibleRect.origin.x *= theScale;
//        visibleRect.origin.y *= theScale;
//        visibleRect.size.width *= theScale;
//        visibleRect.size.height *= theScale;
//        NSLog(@"scrollView visibleRect is %@",NSStringFromCGRect(visibleRect));
////        CGFloat cofX = pScrollView.contentOffset.x;
////        CGFloat cofY = pScrollView.contentOffset.y;
//        
//        CGRect newRect = [self.view convertRect:self.cropView.frame toView:pScrollView];
        CGPoint point = [self.view convertPoint:self.cropView.frame.origin toView:photoView.imageView];
       // NSLog(@"must the same %@ %@",NSStringFromCGPoint(point),NSStringFromCGPoint(self.cropView.frame.origin));
        CGFloat cx =  (point.x)  * hfactor*zoomScale;
        CGFloat cy =  (point.y) * vfactor*zoomScale;
        CGFloat cw = self.cropView.frame.size.width * hfactor;
        CGFloat ch = self.cropView.frame.size.height * vfactor;
        CGRect cropRect = CGRectMake(cx, cy, cw, ch);
        CGImageRef imageRef = CGImageCreateWithImageInRect([orignImage CGImage], cropRect);
        UIImage *result = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        
        return result;
    }
}
*/
- (NSInteger)currentPhotoIndex{
	
	return _pageIndex;
	
}



#pragma mark -
#pragma mark Bar Methods

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
    
}

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated{
	if (hidden&&_barsHidden) return;
    [self setStatusBarHidden:hidden animated:animated];
    [self.navigationController setNavigationBarHidden:hidden animated:animated];
    [self.navigationController setToolbarHidden:hidden animated:animated];
    if (hidden) {
        [UIView animateWithDuration:0.4 
                         animations:^{
                             ppv.alpha = 0;
                         }];
        
    }else{
        [UIView animateWithDuration:0.4 
                         animations:^{
                             ppv.alpha = 0.5;
                         }];
        
    }
	_barsHidden=hidden;
	
}

- (void)toggleBarsNotification:(NSNotification*)notification{
	[self setBarsHidden:!_barsHidden animated:YES];
}

#pragma mark -
#pragma mark Photo View Methods

//- (void)photoViewDidFinishLoading:(NSNotification*)notification{
//	if (notification == nil) return;
//	PhotoSource *source = [self.photoSource objectAtIndex:[self centerPhotoIndex]];
//    UIImage *image = source.photoImage;
//	if ([[[notification object] objectForKey:@"photo"] isEqual:image]) {
//		if ([[[notification object] objectForKey:@"failed"] boolValue]) {
//			if (_barsHidden) {
//				[self setBarsHidden:NO animated:YES];
//			}
//		} 
//        if (!editing) {
//            [self setViewState];
//        }
//	}
//}

- (NSInteger)centerPhotoIndex{
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
	return floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
}

- (void)moveForward:(id)sender{
    
   	[self moveToPhotoAtIndex:[self centerPhotoIndex]+1 animated:NO];
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
        [photoView setClearPhoto];   
    }
//    NSString *pageIndex = [NSString stringWithFormat:@"%d",_pageIndex];
//	[self performSelectorOnMainThread:@selector(readPhotoFromALAssets:) withObject:pageIndex waitUntilDone:NO];
}

- (void)moveBack:(id)sender{
    
	[self moveToPhotoAtIndex:[self centerPhotoIndex]-1 animated:NO];
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
        [photoView setClearPhoto];   
    }

//    NSString *pageIndex = [NSString stringWithFormat:@"%d",_pageIndex];
//	[self performSelectorOnMainThread:@selector(readPhotoFromALAssets:) withObject:pageIndex waitUntilDone:NO];
}

- (void)setViewState {	
	
	if (_leftButton) {
		_leftButton.enabled = !(_pageIndex-1 < 0);
	}
	
	if (_rightButton) {
		_rightButton.enabled = !(_pageIndex+1 >= [self.photoSource count]);
	}
	
	if (_actionButton) {
        
        _actionButton.enabled = YES;
	}
	
	if ([self.photoSource count] > 1) {
		self.title = [NSString stringWithFormat:@"%i of %i", _pageIndex+1, [self.photoSource count]];
	} else {
		self.title = @"";
	}
	
	
}
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated {
   // ALAsset *asset = [self.photoSource objectAtIndex:index];
    //NSString *currentPageUrl=[[[asset defaultRepresentation]url]description];
   // ppv.url = currentPageUrl;
    [ppv Buttons];
	NSAssert(index < [self.photoSource count] && index >= 0, @"Photo index passed out of bounds");
   	_pageIndex = index;
    
	if (!editing) {
        [self setViewState];
    }
    
	[self enqueuePhotoViewAtIndex:index];
  
	[self loadScrollViewWithPage:index-1];
    VI=YES;
	[self loadScrollViewWithPage:index];
    VI=NO;
	[self loadScrollViewWithPage:index+1];
	
	[self.scrollView scrollRectToVisible:((PhotoImageView*)[self.photoViews objectAtIndex:index]).frame animated:animated];
	
	
	if (index + 1 < [self.photoSource count] && (NSNull*)[self.photoViews objectAtIndex:index+1] != [NSNull null]) {
		[((PhotoImageView*)[self.photoViews objectAtIndex:index+1]) killScrollViewZoom];
	} 
	if (index - 1 >= 0 && (NSNull*)[self.photoViews objectAtIndex:index-1] != [NSNull null]) {
		[((PhotoImageView*)[self.photoViews objectAtIndex:index-1]) killScrollViewZoom];
	} 	
}

- (void)layoutScrollViewSubviews{
	NSInteger _index = [self currentPhotoIndex];
	for (NSInteger page = _index -1; page < _index+2; page++) {
		if (page >= 0 && page < [self.photoSource count]){
			
			CGFloat originX = self.scrollView.bounds.size.width * page;
			
			if (page < _index) {
				originX -= PV_IMAGE_GAP;
			} 
			if (page > _index) {
				originX += PV_IMAGE_GAP;
			}
			
			if ([self.photoViews objectAtIndex:page] == [NSNull null] || !((UIView*)[self.photoViews objectAtIndex:page]).superview){
                [self loadScrollViewWithPage:page];
			}
			
			PhotoImageView *_photoView = (PhotoImageView*)[self.photoViews objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, 0.0f, 320,480);//self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
			
			if (!CGRectEqualToRect(_photoView.frame, newframe)) {	
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.1];
				_photoView.frame = newframe;
				[UIView commitAnimations];
                
			}
			
		}
	}
	
}

- (void)setupScrollViewContentSize{
    
	CGSize contentSize = self.view.bounds.size;
	contentSize.width = (contentSize.width * [self.photoSource count]);
	
	if (!CGSizeEqualToSize(contentSize, self.scrollView.contentSize)) {
		self.scrollView.contentSize = contentSize;
	}
	
    
}

- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex{
	
	NSInteger count = 0;
	for (PhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[PhotoImageView class]]) {
			if (count > theIndex+1 || count < theIndex-1) {
				[view prepareForReusue];
				[view removeFromSuperview];
			} else {
				view.tag = 0;
			}
			
		} 
		count++;
	}	
}

- (PhotoImageView*)dequeuePhotoView{
	
	NSInteger count = 0;
	for (PhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[PhotoImageView class]]) {
			if (view.superview == nil) {
				view.tag = count;
				return view;
			}
		}
		count ++;
	}	
	return nil;
	
}

-(void)startToLoadImageAtIndex:(NSUInteger)index{
    NSUInteger i;
    
    if (index > 0) {
        
        // Release anything < index - 1
        for (i = 0; i < index-1; i++) { [(PhotoSource *)[self.photoSource objectAtIndex:i] releasePhoto]; /*NSLog(@"Release image at index %i", i);*/ }
        
        // Preload index - 1
        i = index - 1; 
        if (i < photoSource.count) { [(PhotoSource *)[self.photoSource objectAtIndex:i] obtainImageInBackgroundAndNotify:self]; /*NSLog(@"Pre-loading image at index %i", i);*/ }
        
    }
    if (index < photoSource.count - 1) {
        
        // Release anything > index + 1
        for (i = index + 2; i < photoSource.count; i++) { [(PhotoSource *)[self.photoSource objectAtIndex:i] releasePhoto]; /*NSLog(@"Release image at index %i", i);*/ }
        
        // Preload index + 1
        i = index + 1; 
        if (i < photoSource.count) { [(PhotoSource *)[self.photoSource objectAtIndex:i] obtainImageInBackgroundAndNotify:self]; /*NSLog(@"Pre-loading image at index %i", i);*/ }
        
    }

}

- (void)loadScrollViewWithPage:(NSInteger)page{
    
    if (page < 0) return;
    if (page >= [self.photoSource count]) return;
	
	PhotoImageView *photoView = [self.photoViews objectAtIndex:page];
	if ((NSNull*)photoView == [NSNull null]) {
		
		photoView = [self dequeuePhotoView];
		if (photoView != nil) {
			[self.photoViews exchangeObjectAtIndex:photoView.tag withObjectAtIndex:page];
			photoView = [self.photoViews objectAtIndex:page];
		}
		
	}
	
	if (photoView == nil || (NSNull*)photoView == [NSNull null]) {
		
		photoView = [[PhotoImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320,480)];
		[self.photoViews replaceObjectAtIndex:page withObject:photoView];
		[photoView release];		
	} 
//    UIImage *photo = [self. objectAtIndex:page];
//    if ((NSNull *)photo == [NSNull null]) {
//        return;
//    }
//    [photoView setPhoto:[self.fullScreenPhotos objectAtIndex:page]];
    [photoView setPhoto:[self imageAtIndex:page]];
    if (photoView.superview == nil) {
		[self.scrollView addSubview:photoView];
	}
     
	CGRect frame = self.scrollView.frame;
	NSInteger centerPageIndex = _pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + PV_IMAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - PV_IMAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	photoView.frame = frame;
    NSLog(@"aready here");
//    if(VI==YES)
//    {
//    realasset =[self.photoSource objectAtIndex:page];
//    if ([[realasset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) 
//    {  
//        
//        NSString *p=[NSString stringWithFormat:@"%d",page];
//                [self.video addObject:p];
//        CGRect frame1 =frame;
//        frame1.origin.x =xOrigin+130;
//        frame1.origin.y = 210;
//        frame1.size.height=60;
//        frame1.size.width=60;
//        [self play:frame1];
//    }
//    }
//    NSString *p=[NSString stringWithFormat:@"%d",page];
//    if(VI==YES)
//    {
//        [self performSelector:@selector(favorite:) withObject:p afterDelay:2.5];    
//    }
   //[self favorite];   
    
}

#pragma mark -
#pragma mark Photos

// Get image if it has been loaded, otherwise nil
- (UIImage *)imageAtIndex:(NSUInteger)index {
	if (self.photoSource && index < self.photoSource.count) {
        
		// Get image or obtain in background
		PhotoSource *photo = [self.photoSource objectAtIndex:index];
		if ([photo isImageAvailable]) {
			return [photo image];
		} else {
			[photo obtainImageInBackgroundAndNotify:self];
		}
		
	}
	return nil;
}

#pragma mark -
#pragma mark PhotoDelegate

- (void)photoDidFinishLoading:(PhotoSource *)photo {
	NSUInteger index = [self.photoSource indexOfObject:photo];
    PhotoImageView *photoView = (PhotoImageView *)[self.photoViews objectAtIndex:index];
   // NSLog(@"need to load index %d %@",index,photoView);
	if (index != NSNotFound) {

		if ((NSNull *)photoView!=[NSNull null]&&photoView!=nil) {
          //  NSLog(@"finish and the index is %d",index);
			// Tell page to display image again
			[photoView setPhoto:[self imageAtIndex:index]];
			
		}
	}
}

- (void)photoDidFailToLoad:(PhotoSource *)photo {
	NSUInteger index = [self.photoSource indexOfObject:photo];
     PhotoImageView *photoView = (PhotoImageView *)[self.photoViews objectAtIndex:index];
	if (index != NSNotFound) {
		if (index != NSNotFound) {
            if ((NSNull *)photoView!=[NSNull null]&&photoView!=nil) {
                
                // Tell page to display image again
                [photoView displayImageFailure];
                
            }
        }
	}
}


#pragma mark -
#pragma mark UIScrollView Delegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
    [UIView animateWithDuration:0
                     animations:^{
                         //myPickerView.frame = CGRectMake(0, 210, 310, 180);
                         favorite.alpha = 0;
                     }];

	NSInteger _index = [self centerPhotoIndex];
    
	if (_index >= [self.photoSource count] || _index < 0 ){//|| (NSNull *)[self.fullScreenPhotos objectAtIndex:_index] == [NSNull null]) {
		return;
	}
	
	if (_pageIndex != _index && !_rotating) {
//        ALAsset *asset = [self.photoSource objectAtIndex:_index];
//        NSString *currentPageUrl=[[[asset defaultRepresentation]url]description];
//        ppv.url = currentPageUrl;
//        [ppv Buttons];
		[self setBarsHidden:YES animated:YES];
		_pageIndex = _index;
        //[self moveToPhotoAtIndex:_index animated:YES];
        [self startToLoadImageAtIndex:_pageIndex];
        if (!editing) {
            [self setViewState];
        }
		
		if (![scrollView isTracking]) {
			[self layoutScrollViewSubviews];
		}
		
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource count] || _index < 0) {
		return;
	}	
    [self moveToPhotoAtIndex:_index animated:YES];
    PhotoImageView *photoView = [self.photoViews objectAtIndex:_pageIndex];
    if (photoView != nil && (NSNull *)photoView != [NSNull null]) {
        [photoView setClearPhoto];   
    }

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	[self layoutScrollViewSubviews];
}


#pragma mark -
#pragma mark Actions

- (void)copyPhoto{
	
	[[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(((PhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image) forPasteboardType:@"public.png"];
	
}

- (void)emailPhoto{
	/*MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc]init];
    messageController.messageComposeDelegate = self;
    messageController.recipients = [NSArray arrayWithObject:@"23234567"];  
    messageController.body = @"iPhone OS4";
    [self presentModalViewController:messageController animated:YES];
    [messageController release];*/
	MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
	[mailViewController setSubject:@"Shared Photo"];
	[mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation(((PhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image)] mimeType:@"png" fileName:@"Photo.png"];
	mailViewController.mailComposeDelegate = self;
	
	[self presentModalViewController:mailViewController animated:YES];
	[mailViewController release];
	
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	[self dismissModalViewControllerAnimated:YES];
	
	NSString *mailError = nil;
	
	switch (result) {
		case MFMailComposeResultSent: ; break;
		case MFMailComposeResultFailed: mailError = @"Failed sending media, please try again...";
			break;
		default:
			break;
	}
	
	if (mailError != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mailError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}


#pragma mark -
#pragma mark UIActionSheet Methods

- (IBAction)actionButtonHit:(id)sender{
	
	UIActionSheet *actionSheet;
	NSString *a=NSLocalizedString(@"Cancel", @"title");
    NSString *b=NSLocalizedString(@"Mark", @"title");
    NSString *c=NSLocalizedString(@"Copy", @"title");
    NSString *d=NSLocalizedString(@"Email", @"title");
	if ([MFMailComposeViewController canSendMail]) {		
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:a destructiveButtonTitle:nil otherButtonTitles:b,c, d, nil];
		
	} else {
		
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:b, c, nil];
		
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.delegate = self;
	
	[actionSheet showInView:self.view];
	[self setBarsHidden:YES animated:YES];
	
	[actionSheet release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	[self setBarsHidden:NO animated:YES];
	
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
		[self markPhoto];
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
		[self copyPhoto];	
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
		[self emailPhoto];	
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 3){
        [self cropPhoto];
    }
}

#pragma mark -
#pragma mark timer method

-(void)fireTimer:(NSString *)animateStyle{
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(playPhoto) userInfo:animateStyle repeats:YES];
}
-(void)playPhoto{
    _pageIndex+=1;
    NSString *pageIndex = [NSString stringWithFormat:@"%d",_pageIndex];
	[self performSelectorOnMainThread:@selector(readPhotoFromALAssets:) withObject:pageIndex waitUntilDone:NO];    [self setBarsHidden:YES animated:YES];
    NSString *animateStyle = [timer userInfo];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.subtype = kCATransitionFromRight;
    if ([animateStyle isEqualToString:@"Fade"]) {
        animation.type = kCATransitionFade;
    }
    else if([animateStyle isEqualToString:@"Reveal"]) {
        animation.type = kCATransitionReveal;
    }
    else if([animateStyle isEqualToString:@"Push"]) {
        animation.type = kCATransitionPush;
    }
    else if([animateStyle isEqualToString:@"MoveIn"]) {
        animation.type = kCATransitionMoveIn;
    }
    else{
        animation.type = animateStyle;
    }
    [self.scrollView.layer addAnimation:animation forKey:@"animation"];
    NSInteger _index = self._pageIndex;
	if (_index >= [self.photoSource count] || _index < 0) {
        _pageIndex = 0;
        [self moveToPhotoAtIndex:_pageIndex animated:NO];
    }else{
        [self moveToPhotoAtIndex:_pageIndex animated:NO];
    }
}
#pragma mark -
#pragma mark Memory

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
	timer = nil;
	_photoViews=nil;
	photoSource=nil;
	_scrollView=nil;
	
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [fullScreenPhotos release];
	[_photoViews release];
	[photoSource release];
	[_scrollView release];
    [cropView release];
    [super dealloc];
}
@end