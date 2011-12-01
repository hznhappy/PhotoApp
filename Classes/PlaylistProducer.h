//
//  PlaylistProducer.h
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AssetProducer;

@interface PlaylistProducer : NSObject {
    NSMutableArray /* AlbumClass */ *playlists;
    AssetProducer *assetProducer;
    
    
}

@property (nonatomic,retain) AssetProducer *assetProducer;
@property (nonatomic, retain) NSMutableArray /* AlbumClass */ *playlists;

- (id) initWithAssetProcuder:(AssetProducer *)_assetProducer ;
- (void) doFetchPlaylists;

@end
