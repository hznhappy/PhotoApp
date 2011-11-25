//
//  AlbumController.h
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DBOperation.h"
#define PlayTable @"PlayTable"
#define playIdTable @"playIdTable"
#define playIdOrder @"PlayIdOrder"
#define Rules @"Rules"
@interface AlbumController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>{
    
    IBOutlet UITableView *tableView;
    NSMutableArray *list;
    DBOperation *da;
    UIBarButtonItem *editButton;
    NSMutableArray *allUrl;
    NSMutableArray *unTagUrl;
    NSMutableArray *playListUrl;
    NSMutableArray *assetGroups;
    NSMutableArray *tagUrl;
    NSMutableSet *SUM;
    NSMutableArray *dbUrl;
    int r;
    ALAsset *img;
    NSMutableArray *date;
   
   }
@property(nonatomic,retain)NSMutableArray *assetGroups;
@property(nonatomic,retain)NSMutableSet *SUM;
@property(nonatomic,retain)NSMutableArray *allUrl;
@property(nonatomic,retain)NSMutableArray *unTagUrl;
@property(nonatomic,retain)NSMutableArray *dbUrl;
@property(nonatomic,retain)NSMutableArray *playListUrl;
@property(nonatomic,retain)NSMutableArray *tagUrl;
@property(nonatomic,retain)IBOutlet UITableView *tableView; 
@property(nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)ALAsset *img;
-(void)getAssetGroup;
-(void)getAllUrls;
-(void)getTagUrls;
-(void)getUnTagUrls;
-(void)deleteUnExitUrls;
-(void)creatTable;
-(void)playlistUrl:(int)row_id;
-(void)loadPhotos:(NSURL *)url;
-(void)Special;
//-(void)getDate:(ALAsset*)rule;
@end
