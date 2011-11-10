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
	UIScrollView *_scrollView;	
	
	NSInteger _pageIndex;
	BOOL _rotating;
	BOOL _barsHidden;
	
	UIBarButtonItem *_leftButton;
	UIBarButtonItem *_rightButton;
	UIBarButtonItem *_actionButton;
	
	
    UIBarButtonItem *edit;
    BOOL editing;
	DBOperation *db;
    PopupPanelView *ppv;
    CGFloat bty;
    NSMutableArray *listid;
    UILabel *nameTitle;
    NSTimer *timer;	
}
@property(nonatomic,retain)PopupPanelView *ppv;
@property(nonatomic,retain)NSMutableArray *listid;


@property(nonatomic,retain) NSMutableArray *photoSource;
@property(nonatomic,retain) NSMutableArray *photoViews;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger _pageIndex;

- (id)initWithPhotoSource:(NSMutableArray *)aSource;
-(void)doView;
- (NSInteger)currentPhotoIndex;
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)fireTimer;

@end