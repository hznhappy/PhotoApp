//
//  AssetCell.m
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "ThumbnailCell.h"
#import "Thumbnail.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ThumbnailCell

@synthesize rowAssets;
@synthesize allUrls;
@synthesize tagOverlay,loadSign;
@synthesize rowThumbnails;
@synthesize imagesReady;
@synthesize loadedurls;
@synthesize cellLibrary;
@synthesize passViewController;





-(id)initWithUrls:(NSArray*)_url andAssetLibrary:(ALAssetsLibrary*)assetLibrary reuseIdentifier:(NSString*)_identifier {
    
	if((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier])) {
		self.rowAssets = _url;
        self.cellLibrary = assetLibrary;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        self.loadedurls = array;
        [array release];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        self.rowThumbnails = tempArray;
        [tempArray release];
        [self prepareThumail];

	}
    return self;
}

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier {
    
	if((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier])) {
        
		self.rowAssets = _assets;
	}
	
	return self;
}

-(void)setAssets:(NSArray*)_assets {
	
	for(UIView *view in [self subviews]) 
    {		
		[view removeFromSuperview];
	}
	
	self.rowAssets = _assets;
    [self prepareThumail];
}
-(void)prepareThumail{
    imagesReady = NO;
    [self.loadedurls removeAllObjects];
    [self.rowThumbnails removeAllObjects];
    ALAssetsLibraryAssetForURLResultBlock assetRseult = ^(ALAsset *result) 
    {
        if (result == nil) 
        {
            return;
        }
        Thumbnail *view = [[Thumbnail alloc] initWithAsset:result];
        view.assetArray = self.allUrls;
        [rowThumbnails addObject:view];
        
        NSURL *url = [[result defaultRepresentation] url];
        [loadedurls addObject:url];
        
        if ([loadedurls count] == [self.rowAssets count]) {
            imagesReady = YES;
            [self setNeedsLayout];
        }
        
        [view release];
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
    
    
    for (NSURL* url in rowAssets) {
        [self.cellLibrary assetForURL:url resultBlock:assetRseult failureBlock:failureBlock];
    }
}


-(void)layoutSubviews {
    //NSLog(@"%@",self.loadSign?@"yes":@"no");
    NSLog(@"cell count %d",[self.allUrls count]);
    
	CGRect frame = CGRectMake(4, 2, 75, 75);
	
    if (imagesReady) {
        for(Thumbnail *thum in self.rowThumbnails) {
            thum.overlay = tagOverlay;
            thum.load = self.loadSign;
            thum.assetArray = self.allUrls;
            thum.fatherController = self.passViewController;
            [thum setFrame:frame];
            [thum addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:thum action:@selector(toggleSelection)] autorelease]];
            [self addSubview:thum];
            frame.origin.x = frame.origin.x + frame.size.width + 4;
        }
    }
}

-(void)dealloc 
{
    [passViewController release];
    [allUrls release];
    [loadedurls release];
    [cellLibrary release];
    [rowThumbnails release];
	[rowAssets release];
	[super dealloc];
}

@end
