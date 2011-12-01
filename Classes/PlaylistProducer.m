//
//  PlaylistProducer.m
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistProducer.h"
#import "AlbumClass.h"
#import "AssetProducer.h"


@implementation PlaylistProducer
@synthesize playlists;
@synthesize assetProducer;

- (id) initWithAssetProcuder:(AssetProducer *)_assetProducer {
    self = [super init];
    if (self) {
        self.playlists = [[NSMutableArray alloc]init];
        self.assetProducer = _assetProducer;
        [self doFetchPlaylists];
    }
    return self;
}

- (void) doFetchPlaylists {
    self.playlists = [[NSMutableArray alloc]init];
    // 1: all
    NSInteger allPhotoscount = [self.assetProducer.assetsUrlOrdering count];
    AlbumClass *album = [[AlbumClass alloc]init];
    album.albumId = @"-1";
    album.albumName = @"All";
    // XXX fixme
    album.photoCount = allPhotoscount;
    // .....
    
    [self.playlists addObject:album];
    
    // 2: untag
    
    // 3: from DB
}
@end
