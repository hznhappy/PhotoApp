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
    
    NSMutableDictionary *assets;
    NSMutableArray *allUrls;
    
    BOOL stopOperation;
}

@property (nonatomic,retain)NSMutableDictionary *assets;
@property (nonatomic,retain)NSMutableArray *allUrls;

@property (nonatomic,assign)BOOL stopOperation;




-(id)initWithUrls:(NSMutableArray *)_urls;
-(ALAsset *)getAssetsWithUrl:(NSURL *)url;
-(void)getAssetsFormLiabrary;
@end
