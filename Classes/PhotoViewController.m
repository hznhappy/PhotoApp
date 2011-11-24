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

@interface PhotoViewController (Private)
- (void)loadScrollViewWithPage:(NSInteger)page image:(UIImage *)image;
- (void)layoutScrollViewSubviews;
- (void)setupScrollViewContentSize;
- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex;
- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (NSInteger)centerPhotoIndex;
- (void)setupToolbar;
- (void)setViewState;
- (void)autosizePopoverToImageSize:(CGSize)imageSize photoImageView:(PhotoImageView*)photoImageView;
@end


@implementation PhotoViewController
//@synthesize listid;
@synthesize ppv;
@synthesize scrollView=_scrollView;
@synthesize photoSource; 
@synthesize photoViews=_photoViews;
@synthesize _pageIndex;
@synthesize photos,bgPhotos;
@synthesize img;

- (id)initWithPhotoSource:(NSMutableArray *)aSource{
	if ((self = [super init])) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleBarsNotification:) name:@"PhotoViewToggleBars" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewDidFinishLoading:) name:@"PhotoDidFinishLoading" object:nil];
		
		self.hidesBottomBarWhenPushed = YES;
		self.wantsFullScreenLayout = YES;		
		photoSource = [aSource retain];
		
	}
	
	return self;
}

#pragma mark -
#pragma mark View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.wantsFullScreenLayout = YES;
	self.view.backgroundColor = [UIColor blackColor];
	self.wantsFullScreenLayout = YES;
    
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
   	//  load photoviews lazily
	NSMutableArray *views = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.photoSource count]; i++) {
		[views addObject:[NSNull null]];
	}
	self.photoViews = views;
    editing=NO;
   // self.listid=[NSMutableArray arrayWithCapacity:100];
     NSString *u=NSLocalizedString(@"Edit", @"title");
    edit=[[UIBarButtonItem alloc]initWithTitle:u style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
   	self.navigationItem.rightBarButtonItem=edit;
  
    ppv = [[PopupPanelView alloc] initWithFrame:CGRectMake(0, 62, 320, 375)];
    NSURL *currentPageUrl = [self.photoSource objectAtIndex:_pageIndex];
    ppv.url = currentPageUrl;
    [ppv Buttons];
    [self.view addSubview:ppv];
    db = [DBOperation getInstance];
    ppv.hidden=YES;
   	[views release];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.photos = array;
    [array release];
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    self.bgPhotos = temp;
    [temp release];
}
-(void)viewDidAppear:(BOOL)animated{
    [self moveToPhotoAtIndex:_pageIndex animated:NO];
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
	[self setupToolbar];
	[self setupScrollViewContentSize];
    [self performSelectorOnMainThread:@selector(loadPhoto) withObject:nil waitUntilDone:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
	[super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];		
}

-(void)loadPhoto//(NSInteger)page
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    void (^assetRseult)(ALAsset *) = ^(ALAsset *result) 
    {
        if (result == nil) 
        {
            return;
        }
        //self.img=[UIImage imageWithCGImage:[[result defaultRepresentation]fullScreenImage]];
        //            if ([self.photos objectAtIndex:i]!=nil||[self.photos objectAtIndex:i]!=[NSNull null]) {
        //                [self.photos replaceObjectAtIndex:i withObject:[UIImage imageWithCGImage:[[result defaultRepresentation]fullScreenImage]]];
        //            }
        CGImageRef ref = [[result defaultRepresentation] fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:ref];
        [self.bgPhotos addObject:image];
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
    if (_pageIndex ==0) {
        [self.bgPhotos addObject:[NSNull null]];
        [self.bgPhotos addObject:[NSNull null]];
    }else if (_pageIndex ==1) {
        [self.bgPhotos addObject:[NSNull null]];
    }
    NSInteger j = _pageIndex+2;
    
    if (j>=[self.photoSource count]) {
        j = [self.photoSource count]-1;
    }
    for (NSInteger i = _pageIndex-2;i <= j;i++) {
        if (i<0) {
            i = 0;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];        
        [library assetForURL:[self.photoSource objectAtIndex:i] resultBlock:assetRseult failureBlock:failureBlock];
        [library release];
    }
    if (_pageIndex == [self.photoSource count]-1) {
        [self.bgPhotos addObject:[NSNull null]];
        [self.bgPhotos addObject:[NSNull null]];
    }else if (_pageIndex == [self.photoSource count]-2) {
        [self.bgPhotos addObject:[NSNull null]];
    }     
    [pool release];
    self.photos = self.bgPhotos;
}
-(void)anotherLoad:(id)object
{
    NSArray *array = (NSArray *)object;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    NSInteger currentPage = [[array objectAtIndex:0]integerValue];
    NSInteger nextPage = [[array objectAtIndex:1]integerValue];
    if (currentPage<nextPage) {
        if (nextPage+2<[self.photoSource count]) {
            [self loadPhotos:[self.photoSource objectAtIndex:nextPage+2]];
        }
        for (NSUInteger i = 0; i<5; i++) {
            if (i == 4) {
                if (nextPage+2>[self.photoSource count]-1)
                    [self.bgPhotos replaceObjectAtIndex:i withObject:[NSNull null]];
                else{
                    [self.bgPhotos replaceObjectAtIndex:i withObject:self.img];
                }
            }else
            [self.bgPhotos exchangeObjectAtIndex:i withObjectAtIndex:i+1];
        }    
    }else if(currentPage>nextPage){
        if (nextPage-2>=0) {
            [self loadPhotos:[self.photoSource objectAtIndex:nextPage-2]];
        }
        for (NSInteger i = 4; i>=0; i--) {
            if (i == 0) {
                if (nextPage-2<0)
                    [self.bgPhotos replaceObjectAtIndex:i withObject:[NSNull null]];
                else 
                    [self.bgPhotos replaceObjectAtIndex:i withObject:self.img];
            }else
            [self.bgPhotos exchangeObjectAtIndex:i withObjectAtIndex:i-1];
        } 
    }
          [pool release];
}
//-(NSMutableArray *)changePhotos:(NSMutableArray *)array{
//    NSInteger page = [self centerPhotoIndex];
//    if (_pageIndex<page) {
////        if (page+2<[self.photoSource count]) {
////            [self loadPhotos:[self.photoSource objectAtIndex:page+2]];
////        }
//        for (NSUInteger i = 0; i<5; i++) {
////            if (i == 4) {
////                if (page+2>[self.photoSource count]-1)
////                    [array replaceObjectAtIndex:i withObject:[NSNull null]];
////                else{
////                    [array replaceObjectAtIndex:i withObject:self.img];
////                }
////            }else
//                [array exchangeObjectAtIndex:i withObjectAtIndex:i+1];
//        }    
//    }else if(_pageIndex>page){
////        if (page-2>=0) {
////            [self loadPhotos:[self.photoSource objectAtIndex:page-2]];
////        }
//        for (NSInteger i = 4; i>=0; i--) {
////            if (i == 0) {
////                if (nextPage-2<0)
////                    [self.bgPhotos replaceObjectAtIndex:i withObject:[NSNull null]];
////                else 
////                    [self.bgPhotos replaceObjectAtIndex:i withObject:self.img];
////            }else
//                [array exchangeObjectAtIndex:i withObjectAtIndex:i-1];
//        } 
//    }
//    return array;
//
//}

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
-(void)edit
{
      NSString *a=NSLocalizedString(@"Edit", @"title");
      NSString *b=NSLocalizedString(@"Done", @"title");
    
    if (editing)
{  ppv.hidden=NO;
    
    ppv.alpha=0.4;
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"Set Overlay" 
                                                  //     object:self];
     [self.view addSubview:ppv];
    edit.style = UIBarButtonItemStyleBordered;
    edit.title = a;
    [ppv viewClose];
}
else{
    ppv.hidden=NO;
    edit.style = UIBarButtonItemStyleDone;
    edit.title = b;
    [ppv viewOpen];
}
    editing = !editing;
}
- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
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

- (void)photoViewDidFinishLoading:(NSNotification*)notification{
	if (notification == nil) return;
	UIImage *image = [self.photos objectAtIndex:2];//[self centerPhotoIndex]];
	if ([[[notification object] objectForKey:@"photo"] isEqual:image]) {
		if ([[[notification object] objectForKey:@"failed"] boolValue]) {
			if (_barsHidden) {
				[self setBarsHidden:NO animated:YES];
			}
		} 
		[self setViewState];
	}
}

- (NSInteger)centerPhotoIndex{
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
	return floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
}

- (void)moveForward:(id)sender{
    [self.photos replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:self.bgPhotos];
    NSString *currentPage = [NSString stringWithFormat:@"%d",_pageIndex];
    NSString *nextPage = [NSString stringWithFormat:@"%d",_pageIndex+1];
    NSArray *array = [NSArray arrayWithObjects:currentPage,nextPage, nil];
    [self performSelectorInBackground:@selector(anotherLoad:) withObject:array];
	[self moveToPhotoAtIndex:[self centerPhotoIndex]+1 animated:NO];	
}

- (void)moveBack:(id)sender{
    [self.photos replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:self.bgPhotos];
    NSString *currentPage = [NSString stringWithFormat:@"%d",_pageIndex];
    NSString *nextPage = [NSString stringWithFormat:@"%d",_pageIndex-1];
    NSArray *array = [NSArray arrayWithObjects:currentPage,nextPage, nil];
    [self performSelectorInBackground:@selector(anotherLoad:) withObject:array];
	[self moveToPhotoAtIndex:[self centerPhotoIndex]-1 animated:NO];
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
	NSAssert(index < [self.photoSource count] && index >= 0, @"Photo index passed out of bounds");
   	_pageIndex = index;
    NSURL *currentPageUrl = [self.photoSource objectAtIndex:_pageIndex];
    ppv.url = currentPageUrl;
    [ppv Buttons];
	[self setViewState];
    
	[self enqueuePhotoViewAtIndex:index];
	
	[self loadScrollViewWithPage:index-1 image:[self.photos objectAtIndex:1]];
	[self loadScrollViewWithPage:index image:[self.photos objectAtIndex:2]];
	[self loadScrollViewWithPage:index+1 image:[self.photos objectAtIndex:3]];
	
	
	[self.scrollView scrollRectToVisible:((PhotoImageView*)[self.photoViews objectAtIndex:index]).frame animated:animated];
	
	
	if (index + 1 < [self.photoSource count] && (NSNull*)[self.photoViews objectAtIndex:index+1] != [NSNull null]) {
		[((PhotoImageView*)[self.photoViews objectAtIndex:index+1]) killScrollViewZoom];
	} 
	if (index - 1 >= 0 && (NSNull*)[self.photoViews objectAtIndex:index-1] != [NSNull null]) {
		[((PhotoImageView*)[self.photoViews objectAtIndex:index-1]) killScrollViewZoom];
	} 	
   // [self doView];	
}

-(void)loadPhotos:(NSURL *)url 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    void (^assetRseult)(ALAsset *) = ^(ALAsset *result) 
    {
        if (result != nil) 
            self.img=[UIImage imageWithCGImage:[[result defaultRepresentation]fullScreenImage]];
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

- (void)layoutScrollViewSubviews{
	
	NSInteger _index = [self currentPhotoIndex];
	
	for (NSInteger page = _index -1; page < _index+2; page++) {
		//NSLog(@"%d",page);
		if (page >= 0 && page < [self.photoSource count]){
			
			CGFloat originX = self.scrollView.bounds.size.width * page;
			
			if (page < _index) {
				originX -= PV_IMAGE_GAP;
			} 
			if (page > _index) {
				originX += PV_IMAGE_GAP;
			}
			
			if ([self.photoViews objectAtIndex:page] == [NSNull null] || !((UIView*)[self.photoViews objectAtIndex:page]).superview){
				if (page == _index -1) {
                    [self loadScrollViewWithPage:page image:[self.photos objectAtIndex:1]];
                    
                }else if (page == _index) {
                    [self loadScrollViewWithPage:page image:[self.photos objectAtIndex:2]];
                    
                }else if (page == _index +1) {
                    [self loadScrollViewWithPage:page image:[self.photos objectAtIndex:3]];
                    
                }
                
			}
			
			PhotoImageView *_photoView = (PhotoImageView*)[self.photoViews objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
			
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

- (void)loadScrollViewWithPage:(NSInteger)page image:(UIImage *)image{
	
    if (page < 0) return;
    if (page >= [self.photoSource count]) return;
	
	PhotoImageView * photoView = [self.photoViews objectAtIndex:page];
	if ((NSNull*)photoView == [NSNull null]) {
		
		photoView = [self dequeuePhotoView];
		if (photoView != nil) {
			[self.photoViews exchangeObjectAtIndex:photoView.tag withObjectAtIndex:page];
			photoView = [self.photoViews objectAtIndex:page];
		}
		
	}
	
	if (photoView == nil || (NSNull*)photoView == [NSNull null]) {
		
		photoView = [[PhotoImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
		[self.photoViews replaceObjectAtIndex:page withObject:photoView];
		[photoView release];
		
	} 
    //NSURL *url = [self.photoSource objectAtIndex:page];
    //[self  loadPhotos:url];
   // [photoView setPhoto:self.img];//[self.photos objectAtIndex:page]];
    [photoView setPhoto:image];//[self.photos objectAtIndex:page]];

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
}


#pragma mark -
#pragma mark UIScrollView Delegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSInteger _index = [self centerPhotoIndex];
    //[self anotherLoad];
	if (_index >= [self.photoSource count] || _index < 0) {
		return;
	}
	
	if (_pageIndex != _index && !_rotating) {
        
		[self setBarsHidden:YES animated:YES];
        [self.photos replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:self.bgPhotos];
        NSLog(@"%@ is ph:",self.photos);
        NSString *currentPage = [NSString stringWithFormat:@"%d",_pageIndex];
        NSString *nextPage = [NSString stringWithFormat:@"%d",_index];
        NSArray *array = [NSArray arrayWithObjects:currentPage,nextPage, nil];
        [self performSelectorInBackground:@selector(anotherLoad:) withObject:array];

		_pageIndex = _index;
		[self setViewState];
		
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
   // [self performSelectorOnMainThread:@selector(anotherLoad) withObject:nil waitUntilDone:YES];
    //[self.photos replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:self.bgPhotos];
//    [self.photos replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:self.bgPhotos];
//    NSLog(@"%@ is ph:",self.photos);
//    NSString *currentPage = [NSString stringWithFormat:@"%d",_pageIndex];
//    NSString *nextPage = [NSString stringWithFormat:@"%d",_index];
//    NSArray *array = [NSArray arrayWithObjects:currentPage,nextPage, nil];
//    [self performSelectorInBackground:@selector(anotherLoad:) withObject:array];
	[self moveToPhotoAtIndex:_index animated:YES];    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	[self layoutScrollViewSubviews];
}


#pragma mark -
#pragma mark Actions
- (void)markPhoto{
    [self edit];
    
}

- (void)copyPhoto{
	
	[[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(((PhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image) forPasteboardType:@"public.png"];
	
}

- (void)emailPhoto{
	
	MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
	[mailViewController setSubject:@"Shared Photo"];
	[mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation(((PhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image)] mimeType:@"png" fileName:@"Photo.png"];
	mailViewController.mailComposeDelegate = self;
	
	[self presentModalViewController:mailViewController animated:YES];
	[mailViewController release];
	
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
	}
}

#pragma mark -
#pragma mark timer method

-(void)fireTimer:(NSString *)animateStyle{
    //[self performSelectorOnMainThread:@selector(loadPhoto) withObject:nil waitUntilDone:NO];
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(playPhoto) userInfo:animateStyle repeats:YES];
    NSLog(@"when the timer fire");
}
-(void)playPhoto{
    [self setBarsHidden:YES animated:YES];
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
    _pageIndex+=1;
    NSInteger _index = self._pageIndex;
	if (_index >= [self.photoSource count] || _index < 0) {
        //[timer invalidate];
        _pageIndex = 0;
    }else{
        [self.photos replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:self.bgPhotos];
        NSString *currentPage = [NSString stringWithFormat:@"%d",_pageIndex-1];
        NSString *nextPage = [NSString stringWithFormat:@"%d",_pageIndex];
        NSArray *array = [NSArray arrayWithObjects:currentPage,nextPage, nil];
        NSLog(@"self photos%@",self.photos);
        [self performSelectorInBackground:@selector(anotherLoad:) withObject:array];
        [self moveToPhotoAtIndex:_index animated:NO];
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
    //listid = nil;
	
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [bgPhotos release];
	[_photoViews release];
	[photoSource release];
	[_scrollView release];
	//[listid release];
    [img release];
    [super dealloc];
}


@end