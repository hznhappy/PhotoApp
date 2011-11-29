//
//  MyNSOperation.h
//  PhotoApp
//
//  Created by Andy on 11/29/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface MyNSOperation : NSOperation {
    NSInteger beginIndex;
    NSInteger endIndex;
    NSMutableArray *thumbnails;
    NSMutableArray *allUrls;
}
@property (nonatomic,assign)NSInteger beginIndex;
@property (nonatomic,assign)NSInteger endIndex;
@property (nonatomic,retain)NSMutableArray *thumbnails;
@property (nonatomic,retain)NSMutableArray *allUrls;


-(id)initWithBeginIndex:(NSInteger)begin endIndex:(NSInteger)end storeThumbnails:(NSMutableArray *)_thumbnails urls:(NSMutableArray *)_urls;
-(void)loadThumbnails;
@end
