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
@synthesize beginIndex;
@synthesize endIndex;
@synthesize thumbnails;
@synthesize allUrls;
-(id)initWithBeginIndex:(NSInteger)begin endIndex:(NSInteger)end storeThumbnails:(NSMutableArray *)_thumbnails urls:(NSMutableArray *)_urls{
    self = [super init];
    if (self) {
        self.beginIndex = begin;
        self.endIndex = end;
        self.thumbnails = [_thumbnails retain];
        self.allUrls = [_urls retain];
    }
    return self;
    
}


-(void)main{
    @try {
        NSAutoreleasePool *pools = [[NSAutoreleasePool alloc]init];
        [self loadThumbnails];
        [pools release];

    }
    @catch (NSException *exception) {
        NSLog(@"exception %@ and urls is %d",exception,[self.allUrls count]);
    }
}
-(void)loadThumbnails{
    NSDate *star = [NSDate date];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    for (NSInteger i = beginIndex; i<=endIndex; i++) {
        ALAssetsLibraryAssetForURLResultBlock assetRseult = ^(ALAsset *result) 
        {
            if (result == nil) 
            {
                return;
            }
            //Thumbnail *thumbNail = [[Thumbnail alloc]initWithAsset:result];
            
             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             [button setImage:[UIImage imageWithCGImage:[result thumbnail]] forState:UIControlStateNormal];
            [self.thumbnails replaceObjectAtIndex:i withObject:button];        
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
        
        
        if ([self isCancelled]) {
            return;
        }
        NSURL *url = [self.allUrls objectAtIndex:i];
        [url retain];
        [library assetForURL:url resultBlock:assetRseult failureBlock:failureBlock];
    }
    NSDate *finish = [NSDate date];
    NSTimeInterval excuteTime = [finish timeIntervalSinceDate:star];
    NSLog(@"finish time is %f",excuteTime);
}


-(void)dealloc{
    [allUrls release];
    [thumbnails release];
    [super dealloc];
}
@end
