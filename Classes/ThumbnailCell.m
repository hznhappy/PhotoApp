//
//  AssetCell.m
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "ThumbnailCell.h"
#import "Thumbnail.h"

@implementation ThumbnailCell

@synthesize rowAssets;
@synthesize tagOverlay,loadSign;

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier {
    
	if((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier])) {
        
		self.rowAssets = _assets;
	}
	
	return self;
}

-(void)setAssets:(NSArray*)_assets {
	
	for(UIView *view in [self subviews]) 
    {		
		[view removeFromSuperview];
	}
	
	self.rowAssets = _assets;
}


-(void)layoutSubviews {
    //NSLog(@"%@",self.loadSign?@"yes":@"no");
	CGRect frame = CGRectMake(4, 2, 75, 75);
	
	for(Thumbnail *thum in self.rowAssets) {
        thum.overlay = tagOverlay;
        thum.load = self.loadSign;
		[thum setFrame:frame];
		[thum addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:thum action:@selector(toggleSelection)] autorelease]];
		[self addSubview:thum];
		frame.origin.x = frame.origin.x + frame.size.width + 4;
	}
}

-(void)dealloc 
{
	[rowAssets release];
	[super dealloc];
}

@end
