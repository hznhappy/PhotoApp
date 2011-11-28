//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "Thumbnail.h"
#import "AssetTablePicker.h"
#import "PhotoViewController.h"
@implementation Thumbnail

@synthesize asset;
@synthesize parent;
@synthesize overlay,load;
@synthesize fatherController;
@synthesize assetArray,photos;
@synthesize index,tagBg;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset{
	
	if ((self = [super initWithFrame:CGRectMake(0, 0, 0, 0)])) {
        NSMutableArray *temArray = [[NSMutableArray alloc]init];
        self.assetArray = temArray;
        [temArray release];
        
		self.asset =[_asset retain];
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
        
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
        overlayView = [[UIImageView alloc]initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"selectOverlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
        
		selectOverlay = [[UIView alloc]initWithFrame:viewFrames];
        selectOverlay.backgroundColor = [UIColor blackColor];
		[selectOverlay setHidden:YES];
        selectOverlay.alpha = 0.5f;
		[self addSubview:selectOverlay];
		
        
		tagOverlay = [[UIImageView alloc] initWithFrame:viewFrames];
		[tagOverlay setImage:[UIImage imageNamed:@"tagOverlay.png"]];
		[tagOverlay setHidden:YES];
		[self addSubview:tagOverlay];
      
        UIView *BU=[[UIView alloc]initWithFrame:CGRectMake(3, 3, 25, 25)];
        self.tagBg =BU;
        [BU release];
        CGPoint tagBgCenter = tagBg.center;
        self.tagBg.layer.cornerRadius = 25 / 2.0;
        self.tagBg.center = tagBgCenter;

        UIView *tagCount = [[UIView alloc]initWithFrame:CGRectMake(2.6, 2.2, 20, 20)];
        tagCount.backgroundColor = [UIColor colorWithRed:182/255.0 green:0 blue:0 alpha:1];
        CGPoint saveCenter = tagCount.center;
        tagCount.layer.cornerRadius = 20 / 2.0;
        tagCount.center = saveCenter;
        count = [[UILabel alloc]initWithFrame:CGRectMake(3, 4, 13, 12)];
        count.backgroundColor = [UIColor colorWithRed:182/255.0 green:0 blue:0 alpha:1];
        count.textColor = [UIColor whiteColor];
        count.textAlignment = UITextAlignmentCenter;
        count.font = [UIFont boldSystemFontOfSize:11];
        [tagCount addSubview:count];
        [self.tagBg addSubview:tagCount];
        [self addSubview:self.tagBg];
        self.tagBg.hidden=YES; 
        [tagCount release];
    }
	return self;	
}
-(void)setOverlayHidden:(NSString *)hide{
    count.text = hide;
    self.tagBg.hidden=NO; 

}

-(void)setSelectOvlay{
    selectOverlay.hidden = YES;
}

-(void)setTagOverlayHidden:(BOOL)hide{
    overlayView.hidden = hide;
    if([count.text intValue]-1==0)
    {
        self.tagBg.hidden=YES; 
    }
    count.text = [NSString stringWithFormat:@"%d",[count.text intValue]-1];

}

-(void)toggleSelection {
    
    if (overlay) {
        overlayView.hidden = [self tagOverlay];
        if ([self tagOverlay]) {
            NSString *indexString = [NSString stringWithFormat:@"%d",self.index];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexString,@"index",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AddUrl" 
                                                               object:self 
                                                             userInfo:dic];
           
            count.text = [NSString stringWithFormat:@"%d",[count.text intValue]+1];
            self.tagBg.hidden=NO;
        }
        else
        {
            NSString *indexString = [NSString stringWithFormat:@"%d",self.index];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexString,@"Removeurl",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveUrl" 
                                                               object:self 
                                                             userInfo:dic];
            if([count.text intValue]-1==0)
            {
                  self.tagBg.hidden=YES; 
            }
            count.text = [NSString stringWithFormat:@"%d",[count.text intValue]-1];
            
        }
        
    }else{
       
        PhotoViewController *photoController = [[PhotoViewController alloc] initWithPhotoSource:self.assetArray currentPage:self.index];
        selectOverlay.hidden = NO;
        [self.fatherController.navigationController pushViewController:photoController animated:YES];
        [photoController release];
    }
}

-(BOOL)selected {

    return !tagOverlay.hidden;

}

-(BOOL)tagOverlay{
    return !overlayView.hidden;
}
- (void)dealloc 
{    
    [photos release];
    [overlayView release];
    [asset release];
	[fatherController release];
	[assetArray release];
    [tagBg release];
    [count release];
    [selectOverlay release];
    [tagOverlay release];
    [super dealloc];
}

@end

