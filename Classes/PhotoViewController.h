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
#import <MediaPlayer/MediaPlayer.h>
#define Rules    @"Rules"
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
	DBOperation *db;
    PopupPanelView *ppv;
    NSTimer *timer;	
    UIButton *playButton;
    NSMutableArray *video;
    BOOL VI;
    BOOL favo;
    MPMoviePlayerController* theMovie;
    UIView *favorite;
    ALAsset *realasset;
}
@property(nonatomic,retain)PopupPanelView *ppv;
@property(nonatomic,retain)NSMutableArray *video;
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
-(void)playVideo;
-(void)play:(CGRect)framek;
-(void)favorite:(NSString *)inter;
-(void)CFG;
-(void)button1Pressed;
-(void)button2Pressed;
- (UIImage *) croppedPhoto;
@end

@interface UIImage (Crop)

- (UIImage *)crop:(CGRect)rect;
@end