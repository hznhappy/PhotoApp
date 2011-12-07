//
//  DisplayPhotoView.m
//  PhotoApp
//
//  Created by Andy on 12/6/11.
//  Copyright 2011 chinarewards. All rights reserved.
//
#import <QuartzCore/CATiledLayer.h>
#import "DisplayPhotoView.h"

//	#define NEW_DRAW 1

@implementation DisplayPhotoView
@synthesize image;
+ (Class)layerClass {
	return [CATiledLayer class];
}
- (id)initWithImage:(UIImage *)_image frame:(CGRect)_frame
{
    if ((self = [super initWithFrame:_frame])) {
        image = [_image retain];
        
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 4;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
 	//CGContextRef context = UIGraphicsGetCurrentContext();
#ifdef NEW_DRAW
    // get the scale from the context by getting the current transform matrix, then asking for
    // its "a" component, which is one of the two scale components. We could also ask for "d".
    // This assumes (safely) that the view is being scaled equally in both dimensions.
    CGFloat scale = CGContextGetCTM(context).a;
    
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    CGSize tileSize = tiledLayer.tileSize;
    
    // Even at scales lower than 100%, we are drawing into a rect in the coordinate system of the full
    // image. One tile at 50% covers the width (in original image coordinates) of two tiles at 100%. 
    // So at 50% we need to stretch our tiles to double the width and height; at 25% we need to stretch 
    // them to quadruple the width and height; and so on.
    // (Note that this means that we are drawing very blurry images as the scale gets low. At 12.5%, 
    // our lowest scale, we are stretching about 6 small tiles to fill the entire original image area. 
    // But this is okay, because the big blurry image we're drawing here will be scaled way down before 
    // it is displayed.)
    tileSize.width /= scale;
    tileSize.height /= scale;
    
    // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
    int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);
    
    for (int row = firstRow; row <= lastRow; row++) {
        for (int col = firstCol; col <= lastCol; col++) {
            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row,
                                         tileSize.width, tileSize.height);
            
            // if the tile would stick outside of our bounds, we need to truncate it so as to avoid
            // stretching out the partial tiles at the right and bottom edges
            tileRect = CGRectIntersection(self.bounds, tileRect);
            
            [image drawInRect:tileRect];
        }
    }
#else
    CGRect imageRect;
	imageRect.origin = CGPointMake(0, 0);
	imageRect.size = self.frame.size;
	// Note: The images are actually drawn upside down because Quartz image drawing expects
	// the coordinate system to have the origin in the lower-left corner, but a UIView
	// puts the origin in the upper-left corner. For the sake of brevity (and because
	// it likely would go unnoticed for the image used) this is not addressed here.
	// For the demonstration of PDF drawing however, it is addressed, as it would definately
	// be noticed, and one method of addressing it is shown there.
    
	// Draw the image in the upper left corner (0,0) with size 64x64
	//CGContextDrawImage(context, imageRect, img);
    [self.image drawInRect:imageRect];
#endif
}

- (void)dealloc
{
    [image release];
    [super dealloc];
}


@end
