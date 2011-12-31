//
//  CropView.h
//  PhotoApp
//
//  Created by Andy on 12/13/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoImageView;
@class GridView;
@interface CropView : UIView {
    @private
    CGPoint touchStart;
    
    BOOL rightBottomCorner;
    BOOL rightTopCorner;
    BOOL leftTopCorner;
    BOOL leftBottomCorner;
    
    PhotoImageView *photoImageView;
    UIView *photoBrowserView;
    UIImageView *cropImageView;
    GridView *gridView;
    
    UIImage *cropImage;
}

@property (nonatomic,retain)PhotoImageView *photoImageView;
@property (nonatomic,retain)UIView *photoBrowserView;
@property (nonatomic,retain)UIImage *cropImage;
- (id)initWithFrame:(CGRect)frame ImageView:(PhotoImageView *)_photoImageView superView:(UIView *)supView;
- (UIImage *)croppedPhoto;
- (void)setCropView;
- (CGRect)restrictFrame:(CGRect)rect;
@end
