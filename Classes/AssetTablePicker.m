//
//  AssetTablePicker.m
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AssetTablePicker.h"
#import "ThumbnailCell.h"
#import "AlbumPickerController.h"
#import "UserTableController.h"
#import "DeleteMeController.h"
#import "TextController.h"
#import "PhotoViewController.h"

@implementation AssetTablePicker
@synthesize assetGroup;
@synthesize dataBase;
@synthesize crwAssets,assetArrays,urlsArray;
@synthesize table;

#pragma mark -
#pragma mark UIViewController Methods
-(void)viewDidLoad {
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

    UIBarButtonItem *playButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playPhotos)];
    playButton.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = playButton;
    [playButton release];
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(setEditOverlay:) 
                                                name:@"Set Overlay" 
                                              object:nil];
    
    [self performSelectorInBackground:@selector(loadPhotos) withObject:nil];
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:.5];
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
                [thumbnail setOverlayHidden:NO];
            }
        }
    } 
    [dataBase closeDB];
}
#pragma mark -
#pragma mark ButtonAction Methods
-(IBAction)playPhotos{
    PhotoViewController *playPhotoController = [[PhotoViewController alloc]initWithPhotoSource:self.assetArrays];
    playPhotoController._pageIndex = 0;
    [playPhotoController fireTimer];
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

#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


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
    table = nil;
	thuView = nil;
    crwAssets = nil;
    assetArrays = nil;
    dataBase = nil;
    urlsArray = nil;
    [super viewDidUnload];
}

- (void)dealloc
{   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [table release];
	[thuView release];
    [crwAssets release];
    [assetArrays release];
    [dataBase release];
    [urlsArray release];
    [super dealloc];    
}


@end
