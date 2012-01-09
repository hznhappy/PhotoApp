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
     NSMutableDictionary *tempAsset= [[NSMutableDictionary alloc]init];
    self.assets = tempAsset;
    [tempAsset release];
    self.gCount = 0;
    NSMutableArray *tempUrlOrdering = [[NSMutableArray alloc]init];
    self.assetsUrlOrdering = tempUrlOrdering;
    [tempUrlOrdering release];
    NSMutableArray *tempArray =[[NSMutableArray alloc]init];
    self.assetGroups = tempArray;
    [tempArray release];
    self.library = [assetLibrary retain];
    self.ready = NO;
    gCount=0;
    [self fetchAssets];
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
             { 
                 self.ready = YES;
                 return;
             }
             
             AssetRef * ref = [[AssetRef alloc]initWithALAsset:result];
             NSString *url = [[[result defaultRepresentation]url]description];
             // XXX fixme
             [self.assetsUrlOrdering addObject:url];
             
             [self.assets setValue:ref forKey:url];
             [ref release];
         }];
        //NSLog(@"asssetUrl:%@",self.assetsUrlOrdering);
        [self.assetGroups addObject:group];
      
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        
        NSLog(@"error happen when enumberatoring group,error: %@ ",[error description]);                 
    };	
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator 
                         failureBlock:assetGroupEnumberatorFailure];
   
    [pool release];
    
}



-(BOOL)isReady {
    return ready;
}

@end
