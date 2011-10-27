//
//  PopupPanelView.m
//  PhotoApp
//
//  Created by apple on 11-10-9.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "PopupPanelView.h"
#import "User.h"
#import "DeleteMeController.h"
#import "PhotoViewController.h"
@implementation PopupPanelView
@synthesize isOpen;
@synthesize rectForOpen;
@synthesize rectForClose;
@synthesize list;
@synthesize list1,toolBar;
@synthesize myscroll;
@synthesize url;
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.url = nil;
		isOpen = YES;
		rectForOpen = self.frame;
		rectForClose = CGRectMake(rectForOpen.origin.x , rectForOpen.origin.y, 0, rectForOpen.size.height);
		
		[self setBackgroundColor:[UIColor lightGrayColor]];
		[self.layer setCornerRadius:10.0];
		[self setClipsToBounds:YES];   
		myscroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 347)];
        [self addSubview:myscroll]; 
        [myscroll setBackgroundColor:[UIColor lightGrayColor]];        
        toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 307, 320, 40)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"MarkAll" 
                                                                 style:UIBarButtonItemStyleBordered 
                                                                target:self 
                                                         action:@selector(markname)];
        item1.width = 95;
        
        NSArray *items = [NSArray arrayWithObjects:item1,nil];
        [toolBar setItems:items];
        [self addSubview:toolBar];
        da=[[DBOperation alloc]init];
        [da openDB];
        [da createTable2];     
        NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM idTable"];
        [da selectFromTable2:countSQL];
        self.list=da.ary; 
          
        self.list1=[[NSMutableArray arrayWithCapacity:100]retain];
        
        [da closeDB];
        [myscroll setContentSize:CGSizeMake(320, 45*[self.list count])];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Buttons) name:@"edit" object:nil];
        [item1 release];
    }
   
    return self;
}
CGFloat btx = 20;
CGFloat bty = 20;
CGFloat btwidth = 60;
CGFloat byheight = 30;
-(void)Buttons
{
    for(UIButton *button in self.myscroll.subviews)
    {
        [button removeFromSuperview];
    }
    da=[[DBOperation alloc]init];
    [da openDB];
    [da createTable2];
    NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM idTable"];
    [da selectFromTable2:countSQL];
    self.list=da.ary; 
    [myscroll setContentSize:CGSizeMake(320, 45*[self.list count])];
    NSString *buttonName = nil;
	UIButton *button = nil;
	for(int i=0; i<[list count]; i++){
        
        [da createTable1];  
        User *user1 = [da getUser:[[list objectAtIndex:i]intValue]];
         button = [UIButton buttonWithType:UIButtonTypeCustom]; 
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       NSMutableString * firstCharacters = [NSMutableString string];
        NSArray * words = [user1.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (NSString * word in words) {
            if ([word length] > 0) {
                NSString * firstLetter = [word substringToIndex:1];
                [firstCharacters appendString:[firstLetter uppercaseString]];
            }
        }
        [firstCharacters retain];
        buttonName =firstCharacters;
		button.frame = CGRectMake(btx, bty, btwidth, byheight);
		[button setTitle:buttonName forState:UIControlStateNormal];
		button.tag = i;
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    
        
        NSString *selectSql1 = [NSString stringWithFormat:@"select * from tag where url='%@'",self.url];
        [da selectFromTAG:selectSql1];
        NSMutableArray *cid;
        cid=da.tagary;
        if([cid containsObject:[list objectAtIndex:i]])
        {
        if([user1.color isEqualToString:@"greenColor"])
            [button setBackgroundColor:[UIColor greenColor]];
        else if([user1.color isEqualToString:@"redColor"])
            [button setBackgroundColor:[UIColor redColor]];
        else if([user1.color isEqualToString:@"yellowColor"])
            [button setBackgroundColor:[UIColor yellowColor]];
        else if([user1.color isEqualToString:@"grayColor"])
            [button setBackgroundColor:[UIColor grayColor]];
        else if([user1.color isEqualToString:@"blueColor"])
            [button setBackgroundColor:[UIColor blueColor]];
        else if([user1.color isEqualToString:@"whiteColor"])
            [button setBackgroundColor:[UIColor whiteColor]];     
        
		}
        [myscroll addSubview:button];
		bty += 35;
		[buttonName release];
	}
	bty = 20;
    [da closeDB];

}
-(void)markname
{ 
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tiao" 
                                                       object:self 
                                                     userInfo:dic];
        
}

-(void)buttonPressed:(UIButton *)button{
	int tag = button.tag;
    [list1 addObject:[list objectAtIndex:tag]];
    da=[[DBOperation alloc]init];
    [da openDB];
    [da createTAG];   
    NSMutableArray *ta;
    NSString *selectSql1 = [NSString stringWithFormat:@"select * from tag where url='%@'",self.url];
    [da selectFromTAG:selectSql1];
    ta=da.tagary;
    [da createTable1];
    User *user1 = [da getUser:[[list objectAtIndex:tag]intValue]];
        if([ta containsObject:user1.id])
        {
            NSString *countSQL2 = [NSString stringWithFormat:@"DELETE FROM TAG WHERE ID='%@' and url='%@'",user1.id,self.url];
            
            [da deleteDB:countSQL2];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"fre",@"name",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"change" 
                                                               object:self 
                                                             userInfo:dic];
            [da closeDB];
            
        }
        else
        {
            NSString *insertUsername = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(ID,URL) VALUES(%d,'%@')",TableName,[[list objectAtIndex:tag]intValue],self.url];
            [da insertTAG:insertUsername];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"fre",@"name",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"change" 
                                                               object:self 
                                                             userInfo:dic];
        }

    
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
    [da.ary release];
    [da.tagary release];
    [list release];
    [list1 release];
    [url release];
    [super dealloc];
}


@end
