//
//  PlaylistProducer.h
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBOperation.h"
#define PlayTable @"PlayTable"
#define playIdTable @"playIdTable"
#define playIdOrder @"PlayIdOrder"
#define Rules @"Rules"
#define PassTable @"PassTable"
@class AssetProducer;

@interface PlaylistProducer : NSObject {
    NSMutableArray /* AlbumClass */ *playlists;
    AssetProducer *assetProducer;
    DBOperation *da;
    NSMutableArray *list;
    NSMutableSet *SUM;
    NSMutableArray *dbUrl;
    NSMutableArray *allUrl;
    
    
}

@property (nonatomic,retain) AssetProducer *assetProducer;
@property (nonatomic, retain) NSMutableArray /* AlbumClass */ *playlists;
@property (nonatomic, retain)NSMutableArray *list;
@property (nonatomic, retain)NSMutableArray *allUrl;
- (id) initWithAssetProcuder:(AssetProducer *)_assetProducer ;
- (void) doFetchPlaylists;
-(void)Special;
-(void)creatTable;
-(void)deleteTable:(NSInteger)index;
@end
