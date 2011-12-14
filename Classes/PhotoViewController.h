//
//  PhotoViewController.h
//  PhotoApp
//
//  Created by Andy on 10/12/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DBOperation.h"
#import "PopupPanelView.h"

#define PV_IMAGE_GAP 30
@class CropView;
@class PhotoImageView;
@interface PhotoViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate> {
@private
	NSArray *photoSource;
	NSMutableArray *_photoViews;
    NSMutableArray *fullScreenPhotos;
	UIScrollView *_scrollView;	
	
	NSInteger _pageIndex;
	BOOL _rotating;
	BOOL _barsHidden;
	
	UIBarButtonItem *_leftButton;
	UIBarButtonItem *_rightButton;
	UIBarButtonItem *_actionButton;

	CropView *cropView;
    UIBarButtonItem *edit;
    BOOL editing;
    BOOL tagShow;
    BOOL croping;
	//DBOperation *db;
    PopupPanelView *ppv;
    NSTimer *timer;	
}
@property(nonatomic,retain)PopupPanelView *ppv;

@property(nonatomic,retain) NSArray *photoSource;
@property(nonatomic,retain) NSMutableArray *photoViews;
@property(nonatomic,retain) NSMutableArray *fullScreenPhotos;

@property (nonatomic,retain)CropView *cropView;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger _pageIndex;

- (id)initWithPhotoSource:(NSArray *)aSource currentPage:(NSInteger)page;
-(void)readPhotoFromALAssets:(NSString *)pageIndex;
- (NSInteger)currentPhotoIndex;
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)fireTimer:(NSString *)animateStyle;
- (UIImage *) croppedPhoto;
@end

@interface UIImage (Crop)

- (UIImage *)crop:(CGRect)rect;
@end