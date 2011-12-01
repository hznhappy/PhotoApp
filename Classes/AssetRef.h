//
//  AssetRef.h
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetRef : NSObject {
    ALAsset *asset;
    
}

@property (nonatomic,retain)ALAsset *asset;
-(id)initWithALAsset:(ALAsset *)_asset;
@end
