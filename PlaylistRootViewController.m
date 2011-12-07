//
//  PlaylistRootViewController.m
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistRootViewController.h"
#import "AlbumController.h"
#import "AssetTablePicker.h"
#import "AssetRef.h"
#import "PhotoViewController.h"
@implementation PlaylistRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AlbumController *al = [[AlbumController alloc]init];
    [self pushViewController:al animated:NO];
    [al release];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushAssetsTablePicker:) name:@"pushThumbnailView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushPhotosBrowser:) name:@"viewPhotos" object:nil];
}

-(void)pushAssetsTablePicker:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    NSArray *assetRefs = [dic valueForKey:@"assets"];
    NSMutableArray *assets = [[NSMutableArray alloc]init];
    for (AssetRef *aref in assetRefs) {
        [assets addObject:aref.asset];
    }
    AssetTablePicker *ap = [[AssetTablePicker alloc]initWithNibName:@"AssetTablePicker" bundle:[NSBundle mainBundle]];
    ap.hidesBottomBarWhenPushed = YES;
    ap.crwAssets = assets;
    [assets release];
    [self pushViewController:ap animated:YES];
    [ap release];    
}

-(void)pushPhotosBrowser:(NSNotification *)note{
    NSDictionary *dicOfPhotoViewer = [note userInfo];
    NSString *key = [[dicOfPhotoViewer allKeys] objectAtIndex:0];
    NSMutableArray *assets = [dicOfPhotoViewer valueForKey:key];
    PhotoViewController *pc = [[PhotoViewController alloc]initWithPhotoSource:assets currentPage:[key integerValue]];
    //PhotosBrowser *pc = [[PhotosBrowser alloc]initWithPhotoSource:assets currentPage:[key integerValue]];
    [self pushViewController:pc animated:YES];
    [pc release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
