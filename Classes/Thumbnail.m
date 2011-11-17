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
        
		self.asset = _asset;
		
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
		[selectOverlay release];
        
		tagOverlay = [[UIImageView alloc] initWithFrame:viewFrames];
		[tagOverlay setImage:[UIImage imageNamed:@"tagOverlay.png"]];
		[tagOverlay setHidden:YES];
		[self addSubview:tagOverlay];
        [tagOverlay release];
        
        tagBg = [[UIView alloc]initWithFrame:CGRectMake(3, 3, 25, 25)];
        [tagBg setBackgroundColor:[UIColor whiteColor]];
        CGPoint tagBgCenter = tagBg.center;
        tagBg.layer.cornerRadius = 25 / 2.0;
        tagBg.center = tagBgCenter;

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
        [tagBg addSubview:tagCount];
        [self addSubview:tagBg];
        tagBg.hidden=YES; 
        [tagCount release];
    }
	return self;	
}
-(void)setOverlayHidden:(NSString *)hide{
    count.text = hide;
      tagBg.hidden=NO; 

}

-(void)setSelectOvlay{
    selectOverlay.hidden = YES;
}

-(void)setTagOverlayHidden:(BOOL)hide{
    overlayView.hidden = hide;
    if([count.text intValue]-1==0)
    {
        tagBg.hidden=YES; 
    }
    count.text = [NSString stringWithFormat:@"%d",[count.text intValue]-1];

}

-(void)toggleSelection {
    
    if (overlay) {
        overlayView.hidden = [self tagOverlay];
        if ([self tagOverlay]) {
            NSURL *url = [[self.asset defaultRepresentation]url];
            NSLog(@"url %@",url);
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AddUrl" 
                                                               object:self 
                                                             userInfo:dic];
           
             count.text = [NSString stringWithFormat:@"%d",[count.text intValue]+1];
            tagBg.hidden=NO;
        }
        else
        {
            NSURL *url = [[self.asset defaultRepresentation]url];
            NSLog(@"url %@",url);
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:url,@"Removeurl",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveUrl" 
                                                               object:self 
                                                             userInfo:dic];
            if([count.text intValue]-1==0)
            {
                  tagBg.hidden=YES; 
            }
            count.text = [NSString stringWithFormat:@"%d",[count.text intValue]-1];
            
        }
        
    }else{
        if (load) {
            return;
        }else{
            NSInteger currenPage = 0;
            for (id aAsset in self.assetArray) {
                if ([[[self.asset defaultRepresentation]url] isEqual:[[aAsset defaultRepresentation]url]]) {
                    currenPage = [assetArray indexOfObject:aAsset];
                }
            }
            PhotoViewController *photoController = [[PhotoViewController alloc] initWithPhotoSource:self.assetArray];
            photoController._pageIndex = currenPage;
            selectOverlay.hidden = NO;
            photoController.photos = self.photos;
            [self.fatherController.navigationController pushViewController:photoController animated:YES];
            [photoController release];
        }
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
    [super dealloc];
}

@end

