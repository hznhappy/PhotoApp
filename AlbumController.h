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
#import "AlbumClass.h"
#import "AssetProducer.h"
#import "AssetRef.h"


#define PlayTable @"PlayTable"
#define playIdTable @"playIdTable"
#define playIdOrder @"PlayIdOrder"
#define Rules @"Rules"
@class PlaylistProducer;
@interface AlbumController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>{
    
    IBOutlet UITableView *tableView;
    UIBarButtonItem *editButton;
    PlaylistProducer *playList;
    AlbumClass *selectedAlbum;
    AssetProducer *p;
    NSInteger I;
    DBOperation *database;
}

@property (nonatomic,retain)PlaylistProducer *playList;
@property(nonatomic,retain)IBOutlet UITableView *tableView; 

@property(nonatomic,retain)AlbumClass *selectedAlbum;
@property(nonatomic,assign)NSInteger I;

- (void) albumSelected: (id) sender;
-(void)addnumber;
-(void)addcount;
-(void)addfavorate;
-(IBAction)toggleEdit:(id)sender;
-(IBAction)toggleAdd:(id)sender;
@end
