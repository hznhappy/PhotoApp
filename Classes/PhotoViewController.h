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

#define PV_IMAGE_GAP 30

@class PhotoImageView;
@interface PhotoViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
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

	
    UIBarButtonItem *edit;
    BOOL editing;
	//DBOperation *db;
    PopupPanelView *ppv;
    NSTimer *timer;	
    UIButton *playButton;
}
@property(nonatomic,retain)PopupPanelView *ppv;

@property(nonatomic,retain) NSArray *photoSource;
@property(nonatomic,retain) NSMutableArray *photoViews;
@property(nonatomic,retain) NSMutableArray *fullScreenPhotos;

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger _pageIndex;

- (id)initWithPhotoSource:(NSArray *)aSource currentPage:(NSInteger)page;
-(void)readPhotoFromALAssets;
- (NSInteger)currentPhotoIndex;
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)fireTimer:(NSString *)animateStyle;
-(void)playVideo;
-(void)play:(CGRect)framek;
@end