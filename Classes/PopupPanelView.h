//
//  PopupPanelView.h
//  PhotoApp
//
//  Created by apple on 11-10-9.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DBOperation.h"
#define TAG @"TAG"
@interface PopupPanelView :UIView{
	CGRect rectForOpen;
	CGRect rectForClose;
	BOOL isOpen;
    NSMutableArray *list;
    DBOperation *da;
    NSMutableArray *list1;
    UIScrollView *myscroll;
    UIToolbar *toolBar;
    NSURL *url;
}
@property(nonatomic,retain)UIToolbar *toolBar;
@property BOOL isOpen;
@property CGRect rectForOpen;
@property CGRect rectForClose;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,retain)NSMutableArray *list1;
@property (nonatomic,retain)UIScrollView *myscroll;
@property (nonatomic,retain)NSURL *url;
-(void)buttonPressed:(UIButton *)button;
-(void)viewOpen;
-(void)viewClose;
-(void)Buttons;
@end
