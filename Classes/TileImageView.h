//
//  TileImageView.h
//  PhotoApp
//
//  Created by Andy on 12/28/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TileImageView : UIView {
    CGFloat imageScale;
    UIImage* image;
    CGRect imageRect;
}
@property (retain) UIImage* image;

-(id)initWithFrame:(CGRect)_frame image:(UIImage*)_image scale:(CGFloat)_scale;

@end
