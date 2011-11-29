//
//  AssetCell.m
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "ThumbnailCell.h"
#import "Thumbnail.h"
#import "prepareThumbnail.h"
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
@synthesize thumbnailPool;
@synthesize index;
@synthesize count;


-(id)initWithThumbnailPool:(PrepareThumbnail*)pool reuseIdentifier:(NSString*)_identifier {
    
	if((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier])) {
        self.thumbnailPool = pool;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        self.loadedurls = array;
        [array release];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        self.rowThumbnails = tempArray;
        [tempArray release];        
	}
    
    return self;
}
/*
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
	}
    return self;
}
*/
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
}

-(void)prepareThumailIndex:(NSInteger)from count:(NSInteger)cnt{
    self.index = from;
    self.count = cnt;

}


-(void)layoutSubviews {
    
 	CGRect frame = CGRectMake(4, 2, 75, 75);
   // NSDate *methodStart = [NSDate date];
/*
    if (cellLibrary != nil) {
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
    } else 
        if (thumbnailPool != nil) {
            for(UIButton *thum in [thumbnailPool getThumbnailSubViewsFrom:index*4 to:count]) {
                //            thum.overlay = tagOverlay;
                //            thum.load = self.loadSign;
                //            thum.assetArray = self.allUrls;
                //            thum.fatherController = self.passViewController;
                [thum setFrame:frame];
                //[thum addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:thum action:@selector(toggleSelection)] autorelease]];
                [self addSubview:thum];
                frame.origin.x = frame.origin.x + frame.size.width + 4;
            }
        }

    }else{*/
        for (UIButton *bt in self.rowAssets) {
            if (bt!=nil && (NSNull *) bt != [NSNull null] ) {
            [bt setFrame:frame];
            [self addSubview:bt];
            frame.origin.x = frame.origin.x + frame.size.width + 4;
        }
    }
    /*for(Thumbnail *thum in self.rowAssets) {
        if (thum!=nil && (NSNull *) thum != [NSNull null] ) {
            thum.overlay = tagOverlay;
            thum.load = self.loadSign;
            thum.assetArray = self.allUrls;
            thum.fatherController = self.passViewController;
            [thum setFrame:frame];
            [thum addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:thum action:@selector(toggleSelection)] autorelease]];
            [self addSubview:thum];
            frame.origin.x = frame.origin.x + frame.size.width + 4;

        }
            }*/

    /*NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
	NSLog(@"UITableViewCell layoutSubView time %f",executionTime);*/
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
