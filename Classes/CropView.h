//
//  CropView.h
//  PhotoApp
//
//  Created by Andy on 12/13/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CropView : UIView {
    @private
    CGPoint touchStart;
    BOOL rightBottomCorner;
    BOOL rightTopCorner;
    BOOL leftTopCorner;
    BOOL leftBottomCorner;
}

@end
