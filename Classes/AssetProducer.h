//
//  AssetProducer.h
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetProducer : NSObject {
    
    NSMutableArray /* URL */ *assetsUrlOrdering;
    
    NSMutableDictionary /* NSString -> AssetRef mapping */ *assets;
    ALAssetsLibrary *library;
    NSInteger gCount;
    NSMutableArray *assetGroups;
    BOOL ready;
}

@property (nonatomic,retain) NSMutableDictionary *assets;
@property (nonatomic,retain) ALAssetsLibrary *library;
@property (nonatomic,retain)NSMutableArray *assetsUrlOrdering;
@property (nonatomic,retain)NSMutableArray *assetGroups;
@property (nonatomic,assign)NSInteger gCount;

@property (nonatomic) BOOL ready;

-(id)initWithAssetsLibrary: (ALAssetsLibrary *)assetLibrary;
-(void)fetchAssets;
//-(void)getPhotoCount;
@end
