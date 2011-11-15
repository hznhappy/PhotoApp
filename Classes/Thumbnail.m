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
@synthesize overlay;
@synthesize fatherController;
@synthesize assetArray;
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
        
        UIView *tagBg = [[UIView alloc]initWithFrame:CGRectMake(3, 3, 25, 25)];
        [tagBg setBackgroundColor:[UIColor whiteColor]];
        CGPoint tagBgCenter = tagBg.center;
        tagBg.layer.cornerRadius = 25 / 2.0;
        tagBg.center = tagBgCenter;

        UIView *tagCount = [[UIView alloc]initWithFrame:CGRectMake(2.6, 2.2, 20, 20)];
        tagCount.backgroundColor = [UIColor colorWithRed:182/255.0 green:0 blue:0 alpha:1];
        CGPoint saveCenter = tagCount.center;
        tagCount.layer.cornerRadius = 20 / 2.0;
        tagCount.center = saveCenter;
        UITextField *count = [[UITextField alloc]initWithFrame:CGRectMake(3, 4, 13, 12)];
        count.backgroundColor = [UIColor colorWithRed:182/255.0 green:0 blue:0 alpha:1];
        count.textColor = [UIColor whiteColor];
        count.textAlignment = UITextAlignmentLeft;
        count.font = [UIFont boldSystemFontOfSize:11];
        count.text = @"18";
        [tagCount addSubview:count];
        [tagBg addSubview:tagCount];
        [self addSubview:tagBg];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 999;
        
        [tagCount release];
        [count release];
        [tagBg release];

    }
	return self;	
}
-(void)setOverlayHidden:(BOOL)hide{
	tagOverlay.hidden = hide;
}

-(void)setSelectOvlay{
    selectOverlay.hidden = YES;
}

-(void)setTagOverlayHidden:(BOOL)hide{
    overlayView.hidden = hide;
}

-(void)toggleSelection {
    
    if (overlay) {
        overlayView.hidden = [self tagOverlay];
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
    [overlayView release];
    [asset release];
	[fatherController release];
	[assetArray release];
    [super dealloc];
}

@end

