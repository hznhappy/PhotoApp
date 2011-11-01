//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "Thumbnail.h"
#import "AssetTablePicker.h"
#import "PhotoViewController.h"
#import "SingleViewController.h"
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
    }
	return self;	
}
-(void)setOverlayHidden:(BOOL)hide{
	tagOverlay.hidden = hide;
}

-(void)setSelectOvlay{
    selectOverlay.hidden = YES;
}

-(void)toggleSelection {
    
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

-(BOOL)selected {

    return !tagOverlay.hidden;

}


- (void)dealloc 
{    
    [asset release];
	[fatherController release];
	[assetArray release];
    [super dealloc];
}

@end

