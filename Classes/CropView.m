//
//  CropView.m
//  PhotoApp
//
//  Created by Andy on 12/13/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "CropView.h"
#import <QuartzCore/QuartzCore.h>
#define kResizeThumbSize 15

@implementation CropView

+ (Class)layerClass {
	return [CATiledLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 4;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 3;
    }
    return self;
}
/*
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //create a context to do our clipping in
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //create a rect with the size we want to crop the image to
    //the X and Y here are zero so we start at the beginning of our
    //newly created context
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    
    //create a rect equivalent to the full size of the image
    //offset the rect by the X and Y we want to start the crop
    //from in order to cut off anything before them
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 imageToCrop.size.width,
                                 imageToCrop.size.height);
    
    //draw the image to our clipped context using our offset rect
    CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
    
    //pull the image from our cropped context
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    //Note: this is autoreleased
    return cropped;
}



- (void)drawRect:(CGRect)rect
{
    //draw the whole lights off image
    //the on images will be drawn overtop
    [lightsOffImage drawInRect:rect];
    
    //if we don't have any lights on... no point in continuing
    if( numberOfLightsOn < 1 )
        return;
    
    //figure out the dimensions of numberOfLights on bulbs
    CGSize croppedSize = CGSizeMake(LIGHT_WIDTH * numberOfLightsOn, LIGHT_HEIGHT);
    CGRect clippedRect = CGRectMake(0, 0, croppedSize.width, croppedSize.height);
    
    //get the "on" bulbs by cropping the image
    UIImage *cropped = [self imageByCropping:lightsOnImage toRect:clippedRect];
    
    //create a rect to draw the newly cropped on images to
    CGRect lightsOnRect = CGRectMake(LIGHT_BULB_OFFSET_X,
                                     LIGHT_BULB_OFFSET_Y,
                                     croppedSize.width,
                                     croppedSize.height);
    
    //draw the "on" lights
    [cropped drawInRect:lightsOnRect];
    
    //cropped is autoreleased so no need to worry about cleanup
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat scale = CGContextGetCTM(context).a;
    
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    CGSize tileSize = tiledLayer.tileSize;
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
            
            
            [[UIColor whiteColor] set];
            CGContextSetLineWidth(context, 6.0 / scale);
            CGContextStrokeRect(context, tileRect);
            
        }
    }
    

}

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect));  // mid right
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 1, 1, 0, 1);
    CGContextFillPath(ctx);
}
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchStart = [[touches anyObject] locationInView:self];
    isResizing = (self.bounds.size.width - touchStart.x < kResizeThumbSize &&
                  self.bounds.size.height - touchStart.y < kResizeThumbSize);
    if (isResizing) {
        touchStart = CGPointMake(touchStart.x - self.bounds.size.width,
                                 touchStart.y - self.bounds.size.height);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (isResizing) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                touchPoint.x - touchStart.x, touchPoint.y - touchStart.y);
    } else {
        self.center = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                  self.center.y + touchPoint.y - touchStart.y);
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
