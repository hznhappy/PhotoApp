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
#import "MyNSOperation.h"

#define TAG @"TAG"
#define PassTable @"PassTable"


@interface AssetTablePicker : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,ABPeoplePickerNavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>
{
    UITableView *table;
    UIToolbar *viewBar;
    UIToolbar *tagBar;
    UIBarButtonItem *save;
    UIBarButtonItem *reset;
    UIBarButtonItem *cancel;
    UIBarButtonItem *lock;

    MyNSOperation *operation;
    
    NSOperationQueue *queue;
    NSMutableArray *operations;
	
	NSMutableArray *crwAssets;
	NSArray *urlsArray;
    NSMutableArray *dateArray;
    NSMutableArray *images;
    
    
    DBOperation *dataBase;
    BOOL mode;
    BOOL load;
    BOOL done;
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
    UIView *tagBg;
}
@property (nonatomic,retain)IBOutlet UITableView *table;
@property (nonatomic,retain)IBOutlet UIToolbar *viewBar;
@property (nonatomic,retain)IBOutlet UIToolbar *tagBar;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *save;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *reset;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *lock;
@property (nonatomic,retain)ALAssetsLibrary *library;
@property (nonatomic,retain)NSInvocationOperation *operation1;
@property (nonatomic,retain)NSInvocationOperation *operation2;
@property (nonatomic,retain)MyNSOperation *operation;

@property(nonatomic,retain)NSString *UserId;
@property(nonatomic,retain)NSString *UserName;
@property(nonatomic,retain)UIView *tagBg;

@property (nonatomic,retain)NSString *PLAYID;
@property (nonatomic,retain)NSMutableArray *operations;
@property (nonatomic,retain) NSMutableArray *images;
@property (nonatomic,retain) NSMutableArray *crwAssets;
@property (nonatomic,retain) NSArray *urlsArray;
@property (nonatomic,retain) NSMutableArray *dateArry;
@property (nonatomic,retain) NSMutableArray *UrlList;
@property (nonatomic,retain)NSNumber *val;
-(IBAction)actionButtonPressed;
-(IBAction)playPhotos;
-(IBAction)lockButtonPressed;
-(IBAction)saveTags;
-(IBAction)resetTags;
-(IBAction)selectFromFavoriteNames;
-(IBAction)selectFromAllNames;
-(void)setPhotoTag;
-(void)AddUrl:(NSNotification *)note;
-(void)RemoveUrl:(NSNotification *)note;
-(void)AddUser:(NSNotification *)note;
-(void)creatTable;
-(void)viewPhotos:(id)sender;

-(void)getAssets:(ALAsset *)asset;
@end