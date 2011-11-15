//
//  Asset.h
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoAppDelegate.h"
@interface Thumbnail : UIView {
	ALAsset *asset;
	UIView *selectOverlay;
    UIImageView *overlayView;
    UIImageView *tagOverlay;
    UIViewController *fatherController;
    
    NSMutableArray *assetArray;
    
    BOOL overlay;
	id parent;

}

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id parent;
@property (nonatomic,assign)BOOL overlay;
@property (nonatomic,retain)UIViewController *fatherController;
@property (nonatomic,retain)NSMutableArray *assetArray;
-(id)initWithAsset:(ALAsset*)_asset;
-(BOOL)selected;
-(void)setOverlayHidden:(BOOL)hide;
-(void)setSelectOvlay;
-(void)setTagOverlayHidden:(BOOL)hide;
-(BOOL)tagOverlay;



@end