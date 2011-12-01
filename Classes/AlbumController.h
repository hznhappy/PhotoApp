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
}

@property (nonatomic,retain)PlaylistProducer *playList;
@property(nonatomic,retain)IBOutlet UITableView *tableView; 

@property(nonatomic,retain)AlbumClass *selectedAlbum;

- (void) albumSelected: (id) sender;
@end
