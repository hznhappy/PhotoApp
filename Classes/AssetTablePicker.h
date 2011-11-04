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

	ALAssetsGroup *assetGroup;
	
	NSMutableArray *crwAssets;
    NSMutableArray *assetArrays;
	NSMutableArray *urlsArray;
	
    DBOperation *dataBase;
	Thumbnail *thuView;
}
@property (nonatomic,retain)IBOutlet UITableView *table;

@property (nonatomic,assign) ALAssetsGroup  *assetGroup;

@property (nonatomic,retain) DBOperation *dataBase;

@property (nonatomic,retain) NSMutableArray *crwAssets;
@property (nonatomic,retain) NSMutableArray *assetArrays;
@property (nonatomic,retain) NSMutableArray *urlsArray;
-(IBAction)playPhotos;
-(void)loadPhotos;
-(void)setPhotoTag;
@end