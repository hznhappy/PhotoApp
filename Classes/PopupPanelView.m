//
//  PopupPanelView.m
//  PhotoApp
//
//  Created by apple on 11-10-9.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "PopupPanelView.h"
#import "User.h"
#import "tagManagementController.h"
#import "PhotoViewController.h"
@implementation PopupPanelView
@synthesize isOpen;
@synthesize rectForOpen;
@synthesize rectForClose;
@synthesize list;
@synthesize toolBar;
@synthesize myscroll;
@synthesize url;
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.url = nil;
		isOpen = NO;
		rectForOpen = self.frame;
		rectForClose = CGRectMake(0 ,440, rectForOpen.size.width, 0);
		
		[self setBackgroundColor:[UIColor whiteColor]];
        self.alpha=0.4;
		[self.layer setCornerRadius:10.0];
		[self setClipsToBounds:YES];   
		myscroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 347)];
        [self addSubview:myscroll]; 
        [myscroll setBackgroundColor:[UIColor clearColor]]; 
        [self selectTable];
        [myscroll setContentSize:CGSizeMake(320, 45*[self.list count])];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Buttons) name:@"edit" object:nil];
    }
   
    return self;
}
-(void)selectTable
{
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [da createTable:createTag]; 
    NSString *selectTag= [NSString stringWithFormat:@"select * from tag where url='%@'",self.url];
    [da selectFromTAG:selectTag];
    self.list=da.tagIdAry;
    [da closeDB];

}
CGFloat btx = 20;
CGFloat bty = 20;
CGFloat btwidth = 120;
CGFloat byheight = 30;
-(void)Buttons
{
    for(UIButton *button in self.myscroll.subviews)
    {
        [button removeFromSuperview];
    }
       [myscroll setContentSize:CGSizeMake(320, 45*[self.list count])];
    NSString *buttonName = nil;
	UIButton *button = nil;
    [self selectTable];
    for(int i=0; i<[da.tagUserName count]; i++){
         button = [UIButton buttonWithType:UIButtonTypeCustom]; 
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        buttonName =[da.tagUserName objectAtIndex:i];
		button.frame = CGRectMake(btx, bty, btwidth, byheight);
		[button setTitle:buttonName forState:UIControlStateNormal];
		button.tag = i;
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [myscroll addSubview:button];
		bty += 35;
	}
	bty = 20;
 }
-(void)buttonPressed:(UIButton *)button{
	int tag = button.tag;
    [self selectTable];
    [da openDB];
    NSString *deleteTag= [NSString stringWithFormat:@"DELETE FROM TAG WHERE ID='%@' and url='%@'",[self.list objectAtIndex:tag],self.url];
    [da deleteDB:deleteTag];
    [da closeDB];
    [self Buttons];
   }

-(void)viewOpen{
	isOpen = YES;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[self setFrame:rectForOpen];
	[UIView commitAnimations];
}

-(void)viewClose{
	isOpen = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[self setFrame:rectForClose];
	[UIView commitAnimations];
}

- (void)drawRect:(CGRect)rect {
   }


- (void)dealloc {
    [da release];
   [list release];
    [url release];
    [super dealloc];
}


@end
