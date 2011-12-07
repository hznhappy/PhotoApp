//
//  MyNSOperation.m
//  PhotoApp
//
//  Created by Andy on 11/29/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "MyNSOperation.h"
#import "Thumbnail.h"
#import "AssetTablePicker.h"

@implementation MyNSOperation

@synthesize allUrls;
@synthesize stopOperation;
@synthesize controller;


-(id)initWithUrls:(NSArray *)_urls viewController:(AssetTablePicker *)_controller{
    self = [super init];
    if (self) {
        self.allUrls = _urls;
        self.stopOperation = NO;
        self.controller = _controller;
        [_controller release];
    }
    return self;    
}

-(void)getAssetsFormLiabrary{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
        ALAssetsLibraryAssetForURLResultBlock assetRseult = ^(ALAsset *result) 
        {
            if (result == nil) 
            {
                [self.controller.table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                self.stopOperation = YES;
                return;
            }
            [self.controller performSelectorOnMainThread:@selector(getAssets:) withObject:result waitUntilDone:NO];       
        };
        
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
                NSLog(@"A problem occured %@", [error description]);                                     
        };    
        
        
    
    
    ALAssetsLibrary *library = [[[ALAssetsLibrary alloc]init]autorelease];
    for (NSURL *url in self.allUrls) {
        if ([self isCancelled]) {
            return;
        }
        [library assetForURL:url resultBlock:assetRseult failureBlock:failureBlock];
    }
    [pool release];
}

-(void)main{
    @try {
        if ([self isCancelled]) {
            return;
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        [self getAssetsFormLiabrary];
        [pool release];
        if ([self isCancelled]) {
            return;
        }

    }
    @catch (NSException *exception) {
        NSLog(@"exception %@ and urls is %d",exception,[self.allUrls count]);
    }
}


-(BOOL)isFinished{
    if (self.stopOperation) {
        return YES;
    }else{
        return [super isFinished];
    }
}

-(void)dealloc{
    //[controller release];
    [allUrls release];
    [super dealloc];
}
@end
