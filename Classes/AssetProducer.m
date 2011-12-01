//
//  AssetProducer.m
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AssetProducer.h"
#import "AssetRef.h"


@implementation AssetProducer
@synthesize assets;
@synthesize library;
@synthesize ready,assetGroups;
@synthesize assetsUrlOrdering;

-(id)initWithAssetsLibrary: (ALAssetsLibrary *)assetLibrary {
    self = [super init];
    // ---- grap the library assets
    ///////
    self.assetsUrlOrdering = [[NSMutableArray alloc]init];
    self.library = assetLibrary;
    self.ready = NO;
    
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
        }];
         NSLog(@"assertUrlOrdering: %@",self.assetsUrlOrdering);
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
