//
//  SingleViewController.h
//  PhotoApp
//
//  Created by Andy on 11/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DBOperation.h"
#import "PopupPanelView.h"

@interface SingleViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    NSMutableArray *photoSource;
	NSMutableArray *_photoViews;
	UIScrollView *scrollView;	
	
	NSInteger _pageIndex;
	BOOL _rotating;
	BOOL _barsHidden;
	
	IBOutlet UIBarButtonItem *_leftButton;
	IBOutlet UIBarButtonItem *_rightButton;
	IBOutlet UIBarButtonItem *_actionButton;
	
	
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
- (IBAction)moveForward:(id)sender;
- (IBAction)moveBack:(id)sender;
- (IBAction)actionButtonHit:(id)sender;
@end
