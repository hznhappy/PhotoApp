//
//  AssetProducer.m
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AssetProducer.h"
#import "AssetRef.h"
#import "PlaylistProducer.h"
@implementation AssetProducer
@synthesize assets;
@synthesize library;
@synthesize ready,assetGroups;
@synthesize assetsUrlOrdering;
@synthesize gCount;

-(id)initWithAssetsLibrary: (ALAssetsLibrary *)assetLibrary {
    self = [super init];
    // ---- grap the library assets
    ///////
    self.assets = [[NSMutableDictionary alloc]init];
    self.gCount = 0;
    self.assetsUrlOrdering = [[NSMutableArray alloc]init];
    self.assetGroups=[[NSMutableArray alloc]init];
    self.library = assetLibrary;
    self.ready = NO;
    gCount=0;
    [self fetchAssets];
    //[self performSelectorOnMainThread:@selector(fetchAssets) withObject:nil waitUntilDone:YES];
    //[self performSelectorOnMainThread:@selector(count) withObject:nil waitUntilDone:YES];
    //[self performSelectorOnMainThread:@selector(doFetchPlaylists) withObject:nil waitUntilDone:YES];
    //[self performSelector:@selector(doFetchPlaylists) withObject:nil afterDelay:0.05];
    return self;
}
-(void)fetchAssets{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
    {
        if (group == nil) 
        {
            return;
        }
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
         {         
             if(result == nil) 
             { //NSLog(@"self.ASSETURLoRDERING:%@",self.assetsUrlOrdering);
                 self.ready = YES;
                 return;
             }
             
             AssetRef * ref = [[AssetRef alloc]initWithALAsset:result];
             NSString *url = [[[result defaultRepresentation]url]description];
             // XXX fixme
             [self.assetsUrlOrdering addObject:url];
             
             [self.assets setValue:ref forKey:url];
         }];
        
        [self.assetGroups addObject:group];
      
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        
        NSLog(@"error happen when enumberatoring group,error: %@ ",[error description]);                 
    };	
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator 
                         failureBlock:assetGroupEnumberatorFailure];
   
    [pool release];
    NSLog(@"assert:%@",self.assets);
    
}

-(BOOL)isReady {
    return ready;
}

@end
