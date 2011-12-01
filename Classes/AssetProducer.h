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
    
    NSDictionary /* NSString -> AssetRef mapping */ *assets;
    ALAssetsLibrary *library;
    
    BOOL ready;
}

@property (nonatomic,retain) NSDictionary *assets;
@property (nonatomic,retain) ALAssetsLibrary *library;
@property (nonatomic,retain)NSMutableArray *assetsUrlOrdering;
@property (nonatomic) BOOL ready;

-(id)initWithAssetsLibrary: (ALAssetsLibrary *)assetLibrary;
-(void)fetchAssets;
@end
