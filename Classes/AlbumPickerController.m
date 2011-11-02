//
//  AlbumPickerController.m
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumPickerController.h"
#import "AssetTablePicker.h"
@implementation AlbumPickerController

@synthesize assetGroups;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
	[self.navigationItem setTitle:@"Loading..."];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];
    [self getAssetGroup];
    }

-(void)getAssetGroup{
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
       {
           NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
           
           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
           {
               if (group == nil) 
               {
                   return;
               }
               
               [self.assetGroups addObject:group];
               [group numberOfAssets];
               // Reload albums
               [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
           };
           
           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
               
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:[NSString stringWithFormat:@"Album Error: %@", [error description]] 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
               [alert show];
               [alert release];
               
               NSLog(@"A problem occured %@", [error description]);	                                 
           };	
           
           ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];        
           [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator 
                                failureBlock:assetGroupEnumberatorFailure];
           
           
           [library release];
           [pool release];
       });
}
-(void)reloadTableView {
	
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Albums"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Get count
    ALAssetsGroup *group = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [group numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[group valueForProperty:ALAssetsGroupPropertyName], gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *assetsArray = [[NSMutableArray alloc]init];
    ALAssetsGroup *group = [assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
	[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
     {         
         if(result == nil) 
         {
             return;
         }
         [assetsArray addObject:[[result defaultRepresentation]url]];
    }];
    NSLog(@"%d assetcount",[assetsArray count]);

	AssetTablePicker *picker = [[AssetTablePicker alloc] initWithNibName:@"AssetTablePicker" bundle:[NSBundle mainBundle]];

    picker.urlsArray = assetsArray;
    NSLog(@"%d",[picker.assetArrays count]);
	[self.navigationController pushViewController:picker animated:YES];
    [assetsArray release];
	[picker release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{	
	[assetGroups release];
    [super dealloc];
}

@end

