//
//  CropView.m
//  PhotoApp
//
//  Created by Andy on 12/13/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "CropView.h"
#import "PhotoImageView.h"
#import "GridView.h"
#import <QuartzCore/QuartzCore.h>
#define kResizeThumbSize 15

@implementation CropView
@synthesize photoImageView;
@synthesize photoBrowserView;
@synthesize cropImage;
+ (Class)layerClass {
	return [CATiledLayer class];
}

- (id)initWithFrame:(CGRect)frame ImageView:(PhotoImageView *)_photoImageView superView:(UIView *)supView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.photoImageView = _photoImageView;
        self.photoBrowserView = supView;
        CGSize size = self.frame.size;
        cropImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, size.width-4, size.height-4)];
        [self setCropView];
        [self addSubview:cropImageView];
        
        gridView = [[GridView alloc]initWithFrame:CGRectMake(1, 1, size.width-2, size.height-2)];
        gridView.backgroundColor = [UIColor clearColor];
        gridView.hidden = YES;
        [self addSubview:gridView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCropView) name:@"ChangeCropView" object:nil];

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

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetRGBStrokeColor(ctx, 1.0, 2.0, 0, 1); 
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint( ctx, 100,100);
    
    CGContextStrokePath(ctx);
  
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextSetLineWidth(ctx, 2.0);
  CGFloat colX1 = CGRectGetMaxX(rect)/3.0;
  CGFloat colX2 = 2*colX1;
  CGFloat rowY1 = CGRectGetMaxY(rect)/3.0;
  CGFloat rowY2 = 2*rowY1;
  
  CGContextBeginPath(ctx);
  CGContextMoveToPoint(ctx, colX1, CGRectGetMinY(rect));  
  CGContextAddLineToPoint(ctx, colX1, CGRectGetMaxY(rect));
  
  CGContextMoveToPoint(ctx, colX2, CGRectGetMinY(rect));
  CGContextAddLineToPoint(ctx, colX2, CGRectGetMaxY(rect));
  
  CGContextMoveToPoint(ctx, rowY1, CGRectGetMinX(rect));
  CGContextAddLineToPoint(ctx, rowY1, CGRectGetMaxX(rect));
  
  CGContextMoveToPoint(ctx, rowY2, CGRectGetMinX(rect));
  CGContextAddLineToPoint(ctx, rowY2, CGRectGetMaxX(rect));
  CGContextClosePath(ctx);
  
  CGContextSetRGBFillColor(ctx, 1, 1, 0, 1);
  CGContextFillPath(ctx);

}
 */

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 6.0f);
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);

    //CGContextBeginPath(context);
    
//    CGContextSetLineWidth(context, 2.0f);
//    CGContextMoveToPoint(context, minX, minY);
//    CGContextAddLineToPoint(context, maxX, minY);
//    CGContextAddLineToPoint(context, maxX, maxY);
//    CGContextAddLineToPoint(context, minX, maxY);
//    CGContextAddLineToPoint(context, minX, minY);
//    CGContextStrokePath(context);

    CGContextMoveToPoint(context, maxX/12.0,minY);
    CGContextAddLineToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, minX, maxY/12.0);
    
    CGContextMoveToPoint(context, maxX * 11/12.0,minY);
    CGContextAddLineToPoint(context, maxX, minY);
    CGContextAddLineToPoint(context, maxX, maxY/12.0);
    
    CGContextMoveToPoint(context, maxX,maxY* 11/12.0);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, maxX * 11/12.0, maxY);
    
    CGContextMoveToPoint(context, maxX/12.0,maxY);
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextAddLineToPoint(context, minX, maxY * 11/12.0);
    CGContextStrokePath(context);

    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, maxX/12.0,minY);
    CGContextAddLineToPoint(context, maxX * 11/12.0,minY);
    
    CGContextMoveToPoint(context, maxX, maxY/12.0);
    CGContextAddLineToPoint(context, maxX,maxY* 11/12.0);
    
    CGContextMoveToPoint(context, maxX * 11/12.0, maxY);
    CGContextAddLineToPoint(context, maxX/12.0,maxY);
    
    CGContextMoveToPoint(context, minX, maxY * 11/12.0);
    CGContextAddLineToPoint(context, minX, maxY/12.0);
    CGContextStrokePath(context);
    
//    CGContextMoveToPoint(context, maxX/12.0,minY-0.8);
//    CGContextAddLineToPoint(context, minX-0.8, minY-0.8);
//    CGContextAddLineToPoint(context, minX-0.8, maxY/12.0);
//    CGFloat colX1 = CGRectGetMaxX(rect)/3.0;
//    CGFloat colX2 = 2*colX1;
//    CGFloat rowY1 = CGRectGetMaxY(rect)/3.0;
//    CGFloat rowY2 = 2*rowY1;
//    
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, colX1, CGRectGetMinY(rect));  
//    CGContextAddLineToPoint(context, colX1, CGRectGetMaxY(rect));
//    
//    CGContextMoveToPoint(context, colX2, CGRectGetMinY(rect));
//    CGContextAddLineToPoint(context, colX2, CGRectGetMaxY(rect));
//    
//    CGContextMoveToPoint(context, CGRectGetMinX(rect),rowY1);
//    CGContextAddLineToPoint(context, CGRectGetMaxX(rect),rowY1);
//    
//    CGContextMoveToPoint(context, CGRectGetMinX(rect),rowY2);
//    CGContextAddLineToPoint(context,CGRectGetMaxX(rect),rowY2);
    
}

- (UIImage *)croppedPhoto
{
        UIImage *orignImage = self.photoImageView.photo;
        UIScrollView *pScrollView = (UIScrollView *)photoImageView.scrollView;
        CGFloat zoomScale = pScrollView.zoomScale;
        
        CGFloat hfactor = photoImageView.imageView.image.size.width / photoImageView.imageView.frame.size.width;
        CGFloat vfactor = photoImageView.imageView.image.size.height / photoImageView.imageView.frame.size.height;
    
        //        CGRect visibleRect;
        //        visibleRect.origin = pScrollView.contentOffset;
        //        visibleRect.size = pScrollView.bounds.size;
        //       // NSLog(@"scrollview frame is %@",NSStringFromCGRect(pScrollView.frame));
        //       // NSLog(@"scrollview bounds is %@",NSStringFromCGRect(pScrollView.bounds));
        //        float theScale = 1.0 / zoomScale;
        //        visibleRect.origin.x *= theScale;
        //        visibleRect.origin.y *= theScale;
        //        visibleRect.size.width *= theScale;
        //        visibleRect.size.height *= theScale;
        //        NSLog(@"scrollView visibleRect is %@",NSStringFromCGRect(visibleRect));
        ////        CGFloat cofX = pScrollView.contentOffset.x;
        ////        CGFloat cofY = pScrollView.contentOffset.y;
        //        
        //        CGRect newRect = [self.view convertRect:self.cropView.frame toView:pScrollView];
    
        CGPoint point = [self convertPoint:cropImageView.frame.origin toView:photoImageView.imageView];

        CGFloat cx =  (point.x)  * hfactor*zoomScale;
        CGFloat cy =  (point.y) * vfactor*zoomScale;
        CGFloat cw = cropImageView.frame.size.width * hfactor;
        CGFloat ch = cropImageView.frame.size.height * vfactor;
        CGRect cropRect = CGRectMake(cx, cy, cw, ch);

        CGImageRef imageRef = CGImageCreateWithImageInRect([orignImage CGImage], cropRect);
        UIImage *result = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        
        return result;
}

-(void)setCropView{
    self.cropImage = [self croppedPhoto];
    [cropImageView setImage:self.cropImage];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    gridView.hidden = NO;
    touchStart = [[touches anyObject] locationInView:self];
    rightBottomCorner = (self.bounds.size.width - touchStart.x < kResizeThumbSize &&
                  self.bounds.size.height - touchStart.y < kResizeThumbSize);
    leftTopCorner = (touchStart.x - self.bounds.origin.x < kResizeThumbSize &&
                       touchStart.y - self.bounds.origin.y < kResizeThumbSize);
    leftBottomCorner = (touchStart.x - self.bounds.origin.x < kResizeThumbSize &&
                             self.bounds.size.height - touchStart.y < kResizeThumbSize);
    rightTopCorner = (touchStart.y - self.bounds.origin.y < kResizeThumbSize &&
                           self.bounds.size.width - touchStart.x <kResizeThumbSize);
    
    if (rightBottomCorner) {
        touchStart = CGPointMake(touchStart.x - self.bounds.size.width,
                                 touchStart.y - self.bounds.size.height);
    }else if(rightTopCorner){
        touchStart = CGPointMake(touchStart.x - self.bounds.size.width, 
                                 touchStart.y );

    }else if(leftBottomCorner){
        touchStart = CGPointMake(touchStart.x, touchStart.y - self.bounds.size.height);

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGRect newFrame;
    if (rightBottomCorner) {
        newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                touchPoint.x - touchStart.x, touchPoint.y - touchStart.y);
        self.frame = [self restrictFrame:newFrame];
    }else if(rightTopCorner){

        newFrame = CGRectMake(self.frame.origin.x,self.frame.origin.y + touchPoint.y - touchStart.y, 
                                touchPoint.x - touchStart.x, self.frame.size.height - touchPoint.y + touchStart.y);
        self.frame = [self restrictFrame:newFrame];

    }else if(leftTopCorner){
        newFrame = CGRectMake(self.frame.origin.x+touchPoint.x - touchStart.x, self.frame.origin.y+touchPoint.y - touchStart.y,
                                self.frame.size.width - touchPoint.x + touchStart.x, self.frame.size.height - touchPoint.y + touchStart.y);
        self.frame = [self restrictFrame:newFrame];


    }else if(leftBottomCorner){
        newFrame = CGRectMake(self.frame.origin.x +  touchPoint.x - touchStart.x, self.frame.origin.y,
                                self.frame.size.width - touchPoint.x + touchStart.x, touchPoint.y - touchStart.y);
        self.frame = [self restrictFrame:newFrame];

    }
    
    else {
        CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                  self.center.y + touchPoint.y - touchStart.y);
//        self.center = [self restrictCenter:newCenter];
        self.center = newCenter;
        self.frame = [self restrictFrame:self.frame];
    }
    
    CGSize size = self.frame.size;
    [self setCropView];
    cropImageView.frame = CGRectMake(2, 2, size.width-4, size.height-4);
    gridView.frame = CGRectMake(1, 1, size.width-2, size.height-2);
    
}

-(CGRect)restrictFrame:(CGRect)rect{
    //need to fix
    /*CGRect imageViewRect = self.photoImageView.imageView.frame;
    CGRect relativeRect = [self.superview convertRect:rect toView:self.photoImageView.imageView];
    CGFloat selfMinX = CGRectGetMinX(relativeRect);
    CGFloat selfMaxX = CGRectGetMaxX(relativeRect);
    CGFloat selfMinY = CGRectGetMinY(relativeRect);
    CGFloat selfMaxY = CGRectGetMaxY(relativeRect);
    
    CGFloat minX = CGRectGetMinX(imageViewRect);
    CGFloat maxX = CGRectGetMaxX(imageViewRect);
    CGFloat minY = CGRectGetMinY(imageViewRect);
    CGFloat maxY = CGRectGetMaxY(imageViewRect);

    if (selfMinX < minX) {
        relativeRect.origin.x = minX;
        relativeRect.size = self.frame.size;
        NSLog(@"doing x work ");
    }
    else if(selfMinY < minY){
        relativeRect.origin.y = minY;
        relativeRect.size = self.frame.size;
        NSLog(@"doing y work");
    }
    else if(selfMaxX > maxX)
        relativeRect.size.width -= selfMaxX + maxX;
    else if(selfMaxY > maxY)
        relativeRect.size.height -= selfMaxY + maxY;

    return [self.photoImageView.imageView convertRect:relativeRect toView:self.superview];*/
    return rect;
    
}

//-(CGPoint)restrictCenter:(CGPoint)point{
//    CGRect imageViewRect = self.photoImageView.imageView.frame;
//    CGRect relativeRect = [self.superview convertRect:self.frame toView:self.photoImageView.imageView];
//    CGFloat selfMinX = CGRectGetMinX(relativeRect);
//    CGFloat selfMaxX = CGRectGetMaxX(relativeRect);
//    CGFloat selfMinY = CGRectGetMinY(relativeRect);
//    CGFloat selfMaxY = CGRectGetMaxY(relativeRect);
//    
//    CGFloat minX = CGRectGetMinX(imageViewRect);
//    CGFloat maxX = CGRectGetMaxX(imageViewRect);
//    CGFloat minY = CGRectGetMinY(imageViewRect);
//    CGFloat maxY = CGRectGetMaxY(imageViewRect);
//    
//    if (selfMinX < minX) {
//        relativeRect.origin.x = minX;
//        relativeRect.size = self.frame.size;
//    }
//    else if(selfMinY < minY){
//        relativeRect.origin.y = minY;
//        relativeRect.size = self.frame.size;
//    }
//    else if(selfMaxX > maxX)
//        relativeRect.size.width -= selfMaxX + maxX;
//    else if(selfMaxY > maxY)
//        relativeRect.size.height -= selfMaxY + maxY;
//    CGRect newRect = [self.photoImageView.imageView convertRect:relativeRect toView:self.superview];
//    
//    return point;
//}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    gridView.hidden = YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [cropImage release];
    [photoImageView release];
    [gridView release];
    [photoBrowserView release];
    [cropImageView release];
    [cropImageView release];
    [super dealloc];
}

@end
