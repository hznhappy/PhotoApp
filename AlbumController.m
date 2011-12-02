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
#import "AlbumClass.h"
#import "AssetProducer.h"
#import "PlaylistProducer.h"
#import "DBOperation.h"


@implementation AlbumController

@synthesize tableView;
@synthesize playList;
@synthesize selectedAlbum;
@synthesize I;

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
    database=[DBOperation getInstance];
    p = [[AssetProducer alloc]initWithAssetsLibrary: [[ALAssetsLibrary alloc] init]];
    self.playList = [[PlaylistProducer alloc]initWithAssetProcuder:p];
    [self setWantsFullScreenLayout:YES];
	[self.navigationItem setTitle:@"Album"];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addnumber) name:@"addplay" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addcount) name:@"addcount" object:nil];
    
   
}
-(void)addcount
{
    NSLog(@"SHUAXING"); 
    [self.tableView reloadData];
}
-(void)addnumber
{    AlbumClass *al = [self.playList.playlists objectAtIndex:[self.playList.playlists count]-1];
    [self.playList creatTable];
    if([al.albumId isEqualToString:[self.playList.list objectAtIndex:[self.playList.list count]-1]])
    {}
    else
    {AlbumClass *album = [[AlbumClass alloc]init];
        [database getUserFromPlayTable:[[self.playList.list objectAtIndex:[self.playList.list count]-1]intValue]];
        album.albumId=[self.playList.list objectAtIndex:[self.playList.list count]-1];
        album.albumName=database.name;
        [self.playList.playlists addObject:album];
    }
    [self.tableView reloadData];

}
-(IBAction)toggleEdit:(id)sender
{   NSString *c=NSLocalizedString(@"Done", @"button");
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
 
          return [self.playList.playlists count];

   
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
    
        AlbumClass *al = [self.playList.playlists objectAtIndex:indexPath.row];
       
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",al.albumName,al.photoCount];

       cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}
-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AssetTablePicker *assetPicker = [[AssetTablePicker alloc]initWithNibName:@"AssetTablePicker" bundle:[NSBundle mainBundle]];
    assetPicker.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:assetPicker animated:YES];
    [assetPicker release];
    [table deselectRowAtIndexPath:indexPath animated:YES];

    
    
    self.selectedAlbum = [self.playList.playlists objectAtIndex: indexPath.row];
    //[[UIApplication sharedApplication]sendAction:@selector(albumSelected:) to:nil from:self forEvent:nil];
    
}


#pragma mark -
#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{     
    [self.playList.playlists removeObjectAtIndex:indexPath.row];
    NSInteger INDEX=indexPath.row;
    [self.playList creatTable];
    [self.playList deleteTable:INDEX];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{   NSUInteger fromRow=[fromIndexPath row];
	NSUInteger toRow=[toIndexPath row];
	id object=[[self.playList.playlists objectAtIndex:fromRow]retain];
	[self.playList.playlists removeObjectAtIndex:fromRow];
	[self.playList.playlists insertObject:object atIndex:toRow];
	[object release];
    [self.playList tableorder];
    [self.tableView reloadData];
} 


- (void) albumSelected: (id) sender {
    NSLog(@"Album Selected");
    
}

#pragma mark -
#pragma mark memory method

- (void)dealloc {
    
    [playList release];
    [tableView release];

    [super dealloc];
}
@end
