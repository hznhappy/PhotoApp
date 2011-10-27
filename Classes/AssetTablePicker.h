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
#import "PlayPhotos.h"




@interface AssetTablePicker : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate>
{
    UITableView *table;
    UIToolbar *toolBar;
    UIBarButtonItem *show;
    UIPickerView *buttonPicker;

	ALAssetsGroup *assetGroup;
	
	NSMutableArray *crwAssets;
	NSMutableArray *tagPhotos;
	NSMutableArray *unSelectedImages;
	NSMutableArray *photoArray;
    NSMutableArray *allPhotoes; //store all the photoes;
    NSArray	*pickerViewArray;
    NSMutableArray *assetArrays;
	
	
    DBOperation *dataBase;
	Thumbnail *thuView;
    BOOL showPicker;
    CGRect pickerViewFrame;
}
@property (nonatomic,retain)IBOutlet UIToolbar *toolBar;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *show;
@property (nonatomic,retain)IBOutlet UITableView *table;
@property (nonatomic,retain)IBOutlet UIPickerView *buttonPicker;

@property (nonatomic,assign) ALAssetsGroup  *assetGroup;
@property (nonatomic,retain) DBOperation *dataBase;

@property (nonatomic,retain) NSMutableArray *crwAssets;
@property (nonatomic,retain) NSMutableArray *allPhotoes;
@property (nonatomic,retain) NSArray	    *pickerViewArray;
@property (nonatomic,retain) NSMutableArray *assetArrays;
@property (nonatomic,retain) NSMutableArray *tagPhotos;
@property (nonatomic,retain) NSMutableArray *unTagPhotos;
-(IBAction)playPhotos;
-(IBAction)setPickerView;
-(IBAction)markNames;
-(void)loadPhotos;
-(void)selectPlayList;

@end