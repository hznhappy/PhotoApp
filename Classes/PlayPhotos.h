//
//  PlayPhotos.h
//  PhotoApp
//
//  Created by Andy on 10/11/11.
//  Copyright 2011 chinarewards. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PlayPhotos : UIViewController {
    IBOutlet UIImageView *PhotoFrameView;
	NSMutableArray *assets;
    BOOL show;
    UISlider *slider;
}
@property(nonatomic,retain)	NSMutableArray *assets;;
@property(nonatomic,retain)IBOutlet UISlider *slider;
- (IBAction)sliderAction:(id)sender;
@end
