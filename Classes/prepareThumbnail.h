//
//  prepareThumbnail.h
//  PhotoApp
//
//  Created by Andy on 11/25/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class Thumbnail;
@interface PrepareThumbnail : NSObject {
    NSMutableArray *urls;
    NSMutableDictionary *thumbnails;
    
    ALAssetsLibrary *library;
}

@property (nonatomic,retain)NSMutableArray *urls;
@property (nonatomic,retain)NSMutableDictionary *thumbNails;

@property (nonatomic,retain)ALAssetsLibrary *library;

-(NSArray *)getThumbnailSubViewsFrom:(NSInteger) index to:(NSInteger)count;
-(id)initWithUrls:(NSMutableArray *)_urls assetLibrary: (ALAssetsLibrary*)asLibrary;

@end
