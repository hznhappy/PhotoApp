//
//  PhotoSource.h
//  PhotoApp
//
//  Created by Andy on 12/28/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PhotoSource;

@protocol PhotoSourceDelegate <NSObject>

-(void)photoDidFinishLoading:(PhotoSource *)photo;
-(void)photoDidFailToLoad:(PhotoSource *)photo;

@end
@interface PhotoSource : NSObject {
    UIImage *photoImage;
    ALAsset *_asset;
    
    BOOL workingInBackground;
}

+ (PhotoSource *)PhotoWithAsset:(ALAsset *)asset;
- (id)initWithAsset:(ALAsset *)asset;

- (BOOL)isImageAvailable;
-(ALAsset *)alasset;
-(UIImage *)fuzzyImage;
- (UIImage *)image;
- (UIImage *)obtainImage;
- (void)obtainImageInBackgroundAndNotify:(id <PhotoSourceDelegate>)notifyDelegate;
- (void)releasePhoto;
@end


@interface UIImage (Decompress)
- (void)decompress;
@end