//
//  UserTableController.h
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
@interface UserTableController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tableView;
    NSMutableArray *list;
    DBOperation *da;
    
    NSMutableArray *withlist;
    NSMutableArray *withoutlist;
    UIBarButtonItem *editButton;
    NSMutableArray *allUrl;
    NSMutableArray *unTagUrl;
    NSMutableArray *playListUrl;
    NSMutableArray *assetGroups;
    NSMutableArray *tagUrl;
    NSMutableSet *SUM;
    NSMutableArray *dbUrl;
    int r;
}
@property(nonatomic,retain)NSMutableArray *assetGroups;
@property(nonatomic,retain)NSMutableSet *SUM;
@property(nonatomic,retain)NSMutableArray *allUrl;
@property(nonatomic,retain)NSMutableArray *unTagUrl;
@property(nonatomic,retain)NSMutableArray *playListUrl;
@property(nonatomic,retain)NSMutableArray *tagUrl;
@property(nonatomic,retain)IBOutlet UITableView *tableView; 
@property(nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)NSMutableArray *withlist;
@property(nonatomic,retain)NSMutableArray *withoutlist;
@property(nonatomic,retain) UIToolbar* tools;
-(void)getAssetGroup;
-(void)getAllUrls;
-(void)getTagUrls;
-(void)getUnTagUrls;
-(void)deleteUnExitUrls;
-(void)creatTable;
-(void)playlistUrl:(int)row_id;
@end
