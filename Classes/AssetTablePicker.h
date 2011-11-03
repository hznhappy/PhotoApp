//
//  AssetTablePicker.h
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Thumbnail.h"
#import "sqlite3.h"
#import "DBOperation.h"




@interface AssetTablePicker : UIViewController<UINavigationControllerDelegate>
{
    UITableView *table;
    UIBarButtonItem *show;

	ALAssetsGroup *assetGroup;
	
	NSMutableArray *crwAssets;
	NSMutableArray *tagPhotos;
	NSMutableArray *unSelectedImages;
	NSMutableArray *photoArray;
    NSMutableArray *allPhotoes; //store all the photoes;
    NSArray	*pickerViewArray;
    NSMutableArray *assetArrays;
	NSMutableArray *urlsArray;
	
    DBOperation *dataBase;
	Thumbnail *thuView;
    CGRect pickerViewFrame;
}
@property (nonatomic,retain)IBOutlet UITableView *table;

@property (nonatomic,assign) ALAssetsGroup  *assetGroup;

@property (nonatomic,retain) DBOperation *dataBase;

@property (nonatomic,retain) NSMutableArray *crwAssets;
@property (nonatomic,retain) NSMutableArray *allPhotoes;
@property (nonatomic,retain) NSArray	    *pickerViewArray;
@property (nonatomic,retain) NSMutableArray *assetArrays;
@property (nonatomic,retain) NSMutableArray *tagPhotos;
@property (nonatomic,retain) NSMutableArray *unTagPhotos;
@property (nonatomic,retain) NSMutableArray *urlsArray;
-(IBAction)playPhotos;
-(void)loadPhotos;
- (void)displayTag;
@end