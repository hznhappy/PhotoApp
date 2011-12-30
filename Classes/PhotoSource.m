//
//  PhotoSource.m
//  PhotoApp
//
//  Created by Andy on 12/28/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PhotoSource.h"


@implementation UIImage (Decompress)

- (void)decompress {
    const CGImageRef cgImage = [self CGImage];  
	
    const int width = CGImageGetWidth(cgImage);
    const int height = CGImageGetHeight(cgImage);
	
    const CGColorSpaceRef colorspace = CGImageGetColorSpace(cgImage);
    const CGContextRef context = CGBitmapContextCreate(
													   NULL, /* Where to store the data. NULL = don’t care */
													   width, height, /* width & height */
													   8, width * 4, /* bits per component, bytes per row */
													   colorspace, kCGImageAlphaNoneSkipFirst);
	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
}

@end

// Private
@interface PhotoSource ()
// Properties
@property (nonatomic, retain) UIImage *photoImage;
@property (nonatomic, retain) ALAsset *_asset;
@property (assign) BOOL workingInBackground;
// Private Methods
- (void)doBackgroundWork:(id <PhotoSourceDelegate>)delegate;

@end

@implementation PhotoSource

@synthesize photoImage,_asset,workingInBackground;

+ (PhotoSource *)PhotoWithAsset:(ALAsset *)asset{
    return [[[PhotoSource alloc]initWithAsset:asset] autorelease];
}

- (id)initWithAsset:(ALAsset *)asset{
    if ((self = [super init])) {
        self._asset = asset;
    }
    return self;
}

- (void)dealloc {
	[_asset release];
	[photoImage release];
	[super dealloc];
}

- (BOOL)isImageAvailable{
    return (self.photoImage != nil);
}

- (UIImage *)image{
    return self.photoImage;
}

- (UIImage *)obtainImage{
    if (!self.photoImage) {
		
		// Load
		UIImage *img = nil;
		 if (self._asset){
            CGImageRef ref = [[self._asset defaultRepresentation]fullScreenImage];
            if (ref) {
                img = [[UIImage alloc]initWithCGImage:ref];
            }else{
                NSLog(@"Photo from photo album not found");
            }
        }
        
		// Force the loading and caching of raw image data for speed
		[img decompress];		
		
		// Store
		self.photoImage = img;
		[img release];
		
	}
	return [[self.photoImage retain] autorelease];
}


- (void)obtainImageInBackgroundAndNotify:(id <PhotoSourceDelegate>)notifyDelegate{
    if (self.workingInBackground == YES) return; // Already fetching
	self.workingInBackground = YES;
	[self performSelectorInBackground:@selector(doBackgroundWork:) withObject:notifyDelegate];
}

- (void)releasePhoto{
    if (self.photoImage && _asset) {
		self.photoImage = nil;
	}
}

- (void)doBackgroundWork:(id <PhotoSourceDelegate>)delegate{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	// Load image
	UIImage *img = [self obtainImage];
	
	// Notify delegate of success or fail
	if (img) {
		[(NSObject *)delegate performSelectorOnMainThread:@selector(photoDidFinishLoading:) withObject:self waitUntilDone:NO];
	} else {
		[(NSObject *)delegate performSelectorOnMainThread:@selector(photoDidFailToLoad:) withObject:self waitUntilDone:NO];		
	}
    
	// Finish
	self.workingInBackground = NO;
	
	[pool release];

}
@end
