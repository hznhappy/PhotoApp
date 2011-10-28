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

@implementation AssetTablePicker
@synthesize assetGroup;
@synthesize dataBase;
@synthesize pickerViewArray;
@synthesize allPhotoes,crwAssets,assetArrays,tagPhotos,unTagPhotos;
@synthesize show;
@synthesize toolBar;
@synthesize buttonPicker;
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
    self.crwAssets = thumbNailArray;
    [thumbNailArray release];
    
    NSMutableArray *temArray1 = [[NSMutableArray alloc] init] ;
    NSMutableArray *temArray2 = [[NSMutableArray alloc] init] ;
    NSMutableArray *temArray3 = [[NSMutableArray alloc] init] ;
    NSMutableArray *temArray4 = [[NSMutableArray alloc] init] ;
    self.tagPhotos = temArray1;
    self.unTagPhotos = temArray2;
    self.allPhotoes = temArray3;
    self.assetArrays = temArray4;
	[temArray1 release];
    [temArray2 release];
	[temArray3 release];
	[temArray4 release];

    showPicker = NO;
    NSArray *pickArray = [NSArray arrayWithObjects:
                            @"SHOW ALL",
                            @"SHOW TAGGED",
                            @"SHOW UNTAG",  
                            nil];
    self.pickerViewArray = pickArray;
    pickerViewFrame = self.buttonPicker.frame;
    pickerViewFrame.origin.y = 480;
    self.buttonPicker.frame = pickerViewFrame;

    UIBarButtonItem *listButton = [[UIBarButtonItem alloc]initWithTitle:@"Playlist" 
                                                               style:UIBarButtonItemStyleBordered 
                                                              target:self 
                                                              action:@selector(selectPlayList)];
    self.navigationItem.rightBarButtonItem = listButton;
    [listButton release];
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(setEditOverlay:) 
                                                name:@"Set Overlay" 
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(setListTitle:) 
                                                name:@"SetTitle" 
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

	
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
     {         
         if(result == nil) 
         {
             return;
         }
         [self.assetArrays addObject:result];
         thuView = [[Thumbnail alloc] initWithAsset:result];
         thuView.fatherController = self;
         [self.crwAssets addObject:thuView];
         [thuView release];
     }];
    [dataBase openDB];
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG;";
    NSMutableArray *photos = [dataBase selectPhotos:selectSql];
    //Set the photo tag
    for (NSString *dataStr in photos) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        for (Thumbnail *thumbnail in self.crwAssets) {
            NSURL *thumStr = [[thumbnail.asset defaultRepresentation]url];
            if ([dbStr isEqual:thumStr]) {
                [thumbnail setOverlayHidden:NO];
            }
        }
    } 
    
    for (Thumbnail *thumbnail in self.crwAssets) {
        for (id asset in self.assetArrays) {
            [thumbnail.assetArray addObject:asset];
        }
    }
    NSMutableArray *strArray = [NSMutableArray arrayWithCapacity:40];
    for (Thumbnail *thumbnail in self.crwAssets) {
        NSURL *thumStr = [[thumbnail.asset defaultRepresentation]url];
        [strArray addObject:thumStr];
    }
    
    for (NSString *dataStr in photos){
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        if (![strArray containsObject:dbStr]) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM TAG WHERE URL='%@'",dataStr];
            [dataBase updateTable:sql];
        }
    }
    [dataBase closeDB];
	[self.table reloadData];           
    [pool release];

	
}

-(void)viewDidUnload{
    toolBar = nil;
    table = nil;
    buttonPicker = nil;
    pickerViewArray = nil;
	thuView = nil;
    tagPhotos = nil;
	unTagPhotos = nil;
    crwAssets = nil;
    photoArray = nil;
    allPhotoes = nil;
    assetArrays = nil;
    dataBase = nil;
    show = nil;
    [super viewDidUnload];
}

- (void)dealloc
{   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [toolBar release];
    [table release];
    [buttonPicker release];
    [pickerViewArray release];
	[thuView release];
    [tagPhotos release];
	[unTagPhotos release];
    [crwAssets release];
    [photoArray release];
    [allPhotoes release];
    [assetArrays release];
    [dataBase release];
    [show release];
    [super dealloc];    
}

#pragma mark -
#pragma mark ButtonAction Methods
-(IBAction)playPhotos{
    [dataBase openDB];
    if (self.navigationItem.title==@""||self.navigationItem.title==nil) {
        PlayPhotos *play = [[PlayPhotos alloc]init];
        play.assets = self.assetArrays;
        [self.navigationController pushViewController:play animated:YES];
        [play release];
    }else{
        NSString *sql = @"select count(*) from PlayTable;";
        if ([dataBase exitInDatabase:sql]) {
            [self selectPlayList];
        }else{
            TextController *ts=[[TextController alloc]init];
            [self.navigationController pushViewController:ts animated:YES];
        }
    }
    
}
-(IBAction)setPickerView{
    if (!showPicker) {
        self.table.scrollEnabled = NO;
        [UIView animateWithDuration:0.7 
                         animations:^{
                             pickerViewFrame.origin.y = 220;
                             buttonPicker.frame = pickerViewFrame;
                         }];
    }else{
        self.table.scrollEnabled = YES;
        [UIView animateWithDuration:0.7 
                         animations:^{
                             pickerViewFrame.origin.y = 480;
                             buttonPicker.frame = pickerViewFrame;                         
                         }];
    }
    showPicker = !showPicker;
}
-(IBAction)markNames{
    DeleteMeController *d=[[DeleteMeController alloc]init];
    [self.navigationController pushViewController:d animated:YES];
    [d release];
}
-(void)selectPlayList{
    UserTableController *u=[[UserTableController alloc]init];
	//UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:u];
	//[self presentModalViewController:navController animated:YES];
    [self.navigationController pushViewController:u animated:YES];
    [u release];
}

#pragma mark - 
#pragma mark notification method

-(void)setEditOverlay:(NSNotification *)notification{
    for (Thumbnail *thumbnail in self.crwAssets) {
        [thumbnail setOverlayHidden:YES];
    }
    
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
-(void)setListTitle:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    [self.navigationItem setTitle:[dic valueForKey:@"listTitle"]];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.table.scrollEnabled = YES;
    NSString *str = [NSString stringWithFormat:@"%@",[pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
    self.show.title = str;
    if ([str isEqualToString:@"SHOW TAGGED"]) {
        [self.assetArrays removeAllObjects];
        [tagPhotos removeAllObjects];
		for(Thumbnail *elcAsset in self.crwAssets) 
		{		
			if([elcAsset selected]) {
				[tagPhotos addObject:elcAsset];
                [self.assetArrays addObject:elcAsset.asset];
				[self.table reloadData];
                
			}
		}
        if (![tagPhotos count]== 0) {
            for(Thumbnail *thumbnail in tagPhotos) {
                [thumbnail.assetArray removeAllObjects];
                for (id asset in self.assetArrays) {
                    [thumbnail.assetArray addObject:asset];
                }      
            }

        }else{
            self.show.title = @"SHOW ALL";
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Info" 
														   message:@"There are no tagged images" 
														  delegate:self 
                                                 cancelButtonTitle:@"ok" 
												 otherButtonTitles:nil];
			[alert show];
			[alert release];

        }
    }else if([str isEqualToString:@"SHOW UNTAG"]){
        [self.assetArrays removeAllObjects];
        [unTagPhotos removeAllObjects];
		for(Thumbnail *elcAsset in self.crwAssets) 
		{		
			if(![elcAsset selected]) {
				[unTagPhotos addObject:elcAsset];
                [self.assetArrays addObject:elcAsset.asset];				
                [self.table reloadData];
			}
		}
		if (![unTagPhotos count]== 0) {
            for(Thumbnail *thumbnail in unTagPhotos) {
                [thumbnail.assetArray removeAllObjects];
                for (id asset in self.assetArrays) {
                    [thumbnail.assetArray addObject:asset];
                }    
            }
        }
        
        else{
            self.show.title = @"SHOW ALL";
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Info" 
														   message:@"There are no untagged images" 
														  delegate:self 
												 cancelButtonTitle:@"ok" 
												 otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
    }else{
        [self.assetArrays removeAllObjects];
        for(Thumbnail *elcAsset in self.crwAssets) 
		{		
			
            [self.assetArrays addObject:elcAsset.asset];				
        }
        for(Thumbnail *thumbnail in self.crwAssets) {
            [thumbnail.assetArray removeAllObjects];
            for (id asset in self.assetArrays) {
                [thumbnail.assetArray addObject:asset];
            }    
        }
        [self.table reloadData];
        
    }
    [UIView animateWithDuration:0.7 
                     animations:^{
                         pickerViewFrame.origin.y = 480;
                         buttonPicker.frame = pickerViewFrame;
                     }];
    showPicker = !showPicker;

}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [pickerViewArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 280;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 30;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([show.title isEqualToString:@"SHOW UNTAG"]) {
		return ceil([unTagPhotos count]/4.0);
	}else if ([show.title isEqualToString:@"SHOW TAGGED"]) {
		return ceil([tagPhotos count] /4.0);
	}else {
		return ceil([crwAssets count] / 4.0);
	}

    
}


-(NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	if ([show.title isEqualToString:@"SHOW UNTAG"]) {
		if(maxIndex < [unTagPhotos count]) {
			
			return [NSArray arrayWithObjects:[unTagPhotos objectAtIndex:index],
					[unTagPhotos objectAtIndex:index+1],
					[unTagPhotos objectAtIndex:index+2],
					[unTagPhotos objectAtIndex:index+3],
					nil];
		}
		
		else if(maxIndex-1 < [unTagPhotos count]) {
			
			return [NSArray arrayWithObjects:[unTagPhotos objectAtIndex:index],
					[unTagPhotos objectAtIndex:index+1],
					[unTagPhotos objectAtIndex:index+2],
					nil];
		}
		
		else if(maxIndex-2 < [unTagPhotos count]) {
			
			return [NSArray arrayWithObjects:[unTagPhotos objectAtIndex:index],
					[unTagPhotos objectAtIndex:index+1],
					nil];
		}
		
		else if(maxIndex-3 < [unTagPhotos count]) {
			
			return [NSArray arrayWithObject:[unTagPhotos objectAtIndex:index]];
		
		}
   }else if ([show.title isEqualToString:@"SHOW TAGGED"]) {
		if(maxIndex < [tagPhotos count]) {
			
			return [NSArray arrayWithObjects:[tagPhotos objectAtIndex:index],
					[tagPhotos objectAtIndex:index+1],
					[tagPhotos objectAtIndex:index+2],
					[tagPhotos objectAtIndex:index+3],
					nil];
		}
		
		else if(maxIndex-1 < [tagPhotos count]) {
			
			return [NSArray arrayWithObjects:[tagPhotos objectAtIndex:index],
					[tagPhotos objectAtIndex:index+1],
					[tagPhotos objectAtIndex:index+2],
					nil];
		}
		
		else if(maxIndex-2 < [tagPhotos count]) {
			
			return [NSArray arrayWithObjects:[tagPhotos objectAtIndex:index],
					[tagPhotos objectAtIndex:index+1],
					nil];
		}
		
		else if(maxIndex-3 < [tagPhotos count]) {
			
			return [NSArray arrayWithObject:[tagPhotos objectAtIndex:index]];
		}
	}else {
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

@end
