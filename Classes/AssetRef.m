//
//  AssetRef.m
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AssetRef.h"


@implementation AssetRef

@synthesize  asset;
-(id)initWithALAsset:(ALAsset *)_asset{
    self = [super init];
    if (self) {
        self.asset = _asset;
    }
    return self;
}

-(void)dealloc{
    [asset release];
    [super dealloc];
}
@end
