//
//  MyNSOperation.m
//  PhotoApp
//
//  Created by Andy on 11/29/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "MyNSOperation.h"
#import "Thumbnail.h"


@implementation MyNSOperation

@synthesize assets;
@synthesize allUrls;
@synthesize stopOperation;


-(id)initWithUrls:(NSMutableArray *)_urls{
    self = [super init];
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init ];
        self.assets = dic;
        self.allUrls = _urls;
        self.stopOperation = NO;
        [dic release];
    }
    return self;
    NSLog(@"come here");
    
}

-(ALAsset *)getAssetsWithUrl:(NSURL *)url{
    return [self.assets objectForKey:url];
}
-(void)getAssetsFormLiabrary{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
        ALAssetsLibraryAssetForURLResultBlock assetRseult = ^(ALAsset *result) 
        {
            if (result == nil) 
            {
                self.stopOperation = YES;
                return;
            }
            NSURL *url = [[result defaultRepresentation]url];
            [self.assets setObject:result forKey:url];        
        };
        
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                             message:[NSString stringWithFormat:@"Error: %@", [error description]] 
                                                            delegate:nil 
                                                   cancelButtonTitle:@"Ok" 
                                                   otherButtonTitles:nil];
            [alert show];
            [alert release];
            NSLog(@"A problem occured %@", [error description]);                                     
        };    
        
        
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    for (NSURL *url in self.allUrls) {
        if ([self isCancelled]) {
            return;
        }
        [library assetForURL:url resultBlock:assetRseult failureBlock:failureBlock];
    }
    [library release];
    [pool release];
}

-(void)main{
    @try {
        NSAutoreleasePool *pools = [[NSAutoreleasePool alloc]init];
        [self getAssetsFormLiabrary];
        [pools release];

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
    [allUrls release];
    [assets release];
    [super dealloc];
}
@end
