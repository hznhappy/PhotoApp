//
//  prepareThumbnail.m
//  PhotoApp
//
//  Created by Andy on 11/25/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "prepareThumbnail.h"
#import "Thumbnail.h"

@implementation PrepareThumbnail

@synthesize urls,thumbNails;
@synthesize library;

-(id)initWithUrls:(NSMutableArray *)_urls assetLibrary: (ALAssetsLibrary*)asLibrary {
    self = [super init];
    self.urls = _urls;
    self.library = asLibrary;
    self.thumbNails = [[NSMutableDictionary alloc]init];
    // use a separate thread to read the asset library
    [self performSelectorInBackground:@selector(initLoadThumbnails) withObject:nil];

    return self;
}

-(NSArray *)getThumbnailSubViewsFrom:(NSInteger) index to:(NSInteger)count {

    if (index + count >= [urls count]) {
        count = [urls count] - index;
    }
    

    NSRange theRange;

    theRange.location = index;
    theRange.length = count;
    
    NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:count];
    for (NSURL*i in [self.urls subarrayWithRange:theRange]) {
        ALAsset *t = nil;
        do {
            t = [[thumbNails objectForKey:i]retain];
        } while (t == nil);
        
        Thumbnail *thumbnail = [[[Thumbnail alloc]initWithAsset:t]autorelease];
        [temp addObject: thumbnail];
    }
    
    return temp;
}


/**
 * background loading the image thumbnails
 */
-(void)initLoadThumbnails {
//    [self.thumbNails removeAllObjects];
    
    ALAssetsLibraryAssetForURLResultBlock assetRseult = ^(ALAsset *result) 
    {
        NSLog(@"Asset Returned: %@", result);
        if (result == nil) 
        {
            return;
        }
        [thumbNails setObject:result forKey:[[result defaultRepresentation]url]];

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
    
    
    for (NSURL* url in self.urls) {
        [self.library assetForURL:url resultBlock:assetRseult failureBlock:failureBlock];
    }
}

-(void)dealloc{
    [super dealloc];
    [thumbNails release];
    [urls release];
    [library release];
}
@end
