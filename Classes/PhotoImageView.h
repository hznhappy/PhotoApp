//
//  PhotoImageView.h
//  PhotoApp
//
//  Created by Andy on 10/12/11.
//  Copyright 2011 chinarewards. All rights reserved.
//
@class PhotoScrollView;
@class DisplayPhotoView;
@class TileImageView;
#include <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>

@interface PhotoImageView : UIView <UIScrollViewDelegate>{
@private
	PhotoScrollView *_scrollView;
	UIImage *_photo;
	UIImageView *_imageView;
	UIActivityIndicatorView *_activityView;
	
	BOOL _loading;
	CGFloat _beginRadians;
    // The TiledImageView that is currently front most
	TileImageView* frontTiledView;
	// The old TiledImageView that we draw on top of when the zooming stops
	TileImageView* backTiledView;
}

@property(nonatomic,readonly) UIImage *photo;
@property(nonatomic,readonly) UIImageView *imageView;
@property(nonatomic,readonly) PhotoScrollView *scrollView;
@property(retain) TileImageView *backTiledView;
- (void)setPhoto:(UIImage *)aPhoto;
-(void)setClearPhoto;
- (void)displayImageFailure;
- (void)rotatePhoto;
-(void)savePhoto;
- (void)killScrollViewZoom;
- (void)layoutScrollViewAnimated:(BOOL)animated;
- (void)prepareForReusue;
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
@end


@interface UIImage (UIImage_Extensions)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end;
