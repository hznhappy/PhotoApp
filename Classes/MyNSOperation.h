//
//  MyNSOperation.h
//  PhotoApp
//
//  Created by Andy on 11/29/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AssetTablePicker;
@interface MyNSOperation : NSOperation {
    
    NSArray *allUrls;
    
    AssetTablePicker *controller;
    
    BOOL stopOperation;
}

@property (nonatomic,retain)NSArray *allUrls;

@property (nonatomic,retain)AssetTablePicker *controller;


@property (nonatomic,assign)BOOL stopOperation;




-(id)initWithUrls:(NSArray *)_urls viewController:(AssetTablePicker *)_controller;
-(void)getAssetsFormLiabrary;
@end
