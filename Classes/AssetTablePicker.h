//
//  AssetTablePicker.h
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Thumbnail.h"
#import "sqlite3.h"
#import "DBOperation.h"
#define TAG @"TAG"


@interface AssetTablePicker : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,ABPeoplePickerNavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>
{
    UIActivityIndicatorView *_activityView;
    UITableView *table;
    UIToolbar *viewBar;
    UIToolbar *tagBar;
    UIBarButtonItem *save;
    UIBarButtonItem *reset;
    UIBarButtonItem *cancel;
    UIBarButtonItem *lock;
    NSString *selectName;

	ALAssetsGroup *assetGroup;
	
	NSMutableArray *crwAssets;
    NSMutableArray *assetArrays;
	NSMutableArray *urlsArray;
    NSMutableArray *selectUrls;
    NSMutableArray *dateArray;
    NSMutableArray *images;

    DBOperation *dataBase;
	Thumbnail *thuView;
    BOOL mode;
    BOOL load;
    NSString *UserId;
    NSString *UserName;
    NSMutableArray *UrlList;
    NSString *PLAYID;
    UIAlertView *alert1;
    UITextField *passWord;
    BOOL ME;
    BOOL PASS;
    NSNumber *val;
    UITextField *passWord2;
}
@property (nonatomic,retain)IBOutlet UITableView *table;
@property (nonatomic,retain)IBOutlet UIToolbar *viewBar;
@property (nonatomic,retain)IBOutlet UIToolbar *tagBar;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *save;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *reset;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *lock;

@property(nonatomic,retain)NSString *UserId;
@property(nonatomic,retain)NSString *UserName;
@property (nonatomic,assign) ALAssetsGroup  *assetGroup;

@property (nonatomic,retain) DBOperation *dataBase;
@property (nonatomic,retain)NSString *PLAYID;
@property (nonatomic,retain) NSMutableArray *images;
@property (nonatomic,retain) NSMutableArray *crwAssets;
@property (nonatomic,retain) NSMutableArray *assetArrays;
@property (nonatomic,retain) NSMutableArray *urlsArray;
@property (nonatomic,retain) NSMutableArray *selectUrls;
@property (nonatomic,retain) NSMutableArray *dateArry;
@property (nonatomic,retain) NSMutableArray *UrlList;
-(IBAction)actionButtonPressed;
-(IBAction)playPhotos;
-(IBAction)lockButtonPressed;
-(IBAction)saveTags;
-(IBAction)resetTags;
-(IBAction)selectFromFavoriteNames;
-(IBAction)selectFromAllNames;
-(void)loadPhotos;
-(void)setPhotoTag;
-(void)AddUrl:(NSNotification *)note;
-(void)RemoveUrl:(NSNotification *)note;
-(void)AddUser:(NSNotification *)note;
-(void)creatTable;
@end