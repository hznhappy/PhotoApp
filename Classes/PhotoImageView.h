//
//  PhotoImageView.h
//  PhotoApp
//
//  Created by Andy on 10/12/11.
//  Copyright 2011 chinarewards. All rights reserved.
//
@class PhotoScrollView;
#include <AssetsLibrary/AssetsLibrary.h>
@interface PhotoImageView : UIView <UIScrollViewDelegate>{
@private
	PhotoScrollView *_scrollView;
	ALAsset *_photo;
	UIImageView *_imageView;
	UIActivityIndicatorView *_activityView;
	
	BOOL _loading;
	CGFloat _beginRadians;
	
}

@property(nonatomic,readonly) ALAsset *photo;
@property(nonatomic,readonly) UIImageView *imageView;
@property(nonatomic,readonly) PhotoScrollView *scrollView;

- (void)setPhoto:(ALAsset *)aPhoto;
- (void)killScrollViewZoom;
- (void)layoutScrollViewAnimated:(BOOL)animated;
- (void)prepareForReusue;
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
@end
