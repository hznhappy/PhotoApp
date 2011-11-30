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
@synthesize stopOperation;


-(id)initWithBeginIndex:(NSInteger)begin endIndex:(NSInteger)end storeThumbnails:(NSMutableArray *)_thumbnails urls:(NSMutableArray *)_urls{
    self = [super init];
    if (self) {
        self.beginIndex = begin;
        self.endIndex = end;
        self.thumbnails = [_thumbnails retain];
        self.allUrls = [_urls retain];
        self.stopOperation = NO;
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
            button.tag = i;
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
        
        if (i==endIndex) {
            self.stopOperation = YES;
        }
        if ([self isCancelled]) {
            return;
        }
        [library assetForURL:[self.allUrls objectAtIndex:i] resultBlock:assetRseult failureBlock:failureBlock];
    }
    NSDate *finish = [NSDate date];
    NSTimeInterval excuteTime = [finish timeIntervalSinceDate:star];
    NSLog(@"finish time is %f",excuteTime);
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
    [thumbnails release];
    [super dealloc];
}
@end
