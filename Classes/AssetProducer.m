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
    NSLog(@"AssertProducer");
    self = [super init];
    // ---- grap the library assets
    ///////
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
           ALAssetsGroup *group;
            for(int i=0;i<[assetGroups count];i++)
            {
                group = (ALAssetsGroup*)[assetGroups objectAtIndex:i];
                [group setAssetsFilter:[ALAssetsFilter allAssets]];
                gCount +=[group numberOfAssets];
            }
            return;
        }               
        [self.assetGroups addObject:group];
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                         message:[NSString stringWithFormat:@"Error: %@", [error description]] 
                                                        delegate:nil 
                                               cancelButtonTitle:@"Ok" 
                                               otherButtonTitles:nil];
        [alert show];
        [alert release];                                 
    };	
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator 
                         failureBlock:assetGroupEnumberatorFailure];
    
    [library release];
    [pool release];

}


-(void)getAllAssets{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    for (ALAssetsGroup *group in self.assetGroups) {
        [group setAssetsFilter:[ALAssetsFilter allAssets]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
         {         
             if(result == nil) 
             {self.ready = YES;
                 return;
             }
             AssetRef * ref = [[AssetRef alloc]initWithALAsset:result];
             NSString *url = [[[result defaultRepresentation]url]description];
             // XXX fixme
             [self.assetsUrlOrdering addObject:url];
             
             [self.assets setValue:ref forKey:url];

         }];
    }
    [pool release];
}

-(BOOL)isReady {
    return ready;
}

@end
