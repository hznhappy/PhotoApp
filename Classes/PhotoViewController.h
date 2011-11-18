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

@class PhotoImageView;
@interface PhotoViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
@private
	NSMutableArray *photoSource;
	NSMutableArray *_photoViews;
    NSMutableArray *photos;

	UIScrollView *_scrollView;	
	
	NSInteger _pageIndex;
	BOOL _rotating;
	BOOL _barsHidden;
	
	UIBarButtonItem *_leftButton;
	UIBarButtonItem *_rightButton;
	UIBarButtonItem *_actionButton;
    UIImage *img;

	
    UIBarButtonItem *edit;
    BOOL editing;
	DBOperation *db;
    PopupPanelView *ppv;
    NSMutableArray *listid;
    NSTimer *timer;	
}
@property(nonatomic,retain)PopupPanelView *ppv;
@property(nonatomic,retain)NSMutableArray *listid;
@property(nonatomic,retain)UIImage *img;

@property(nonatomic,retain)NSMutableArray *photos;
@property(nonatomic,retain) NSMutableArray *photoSource;
@property(nonatomic,retain) NSMutableArray *photoViews;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger _pageIndex;

- (id)initWithPhotoSource:(NSMutableArray *)aSource;
- (NSInteger)currentPhotoIndex;
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)fireTimer:(NSString *)animateStyle;

@end