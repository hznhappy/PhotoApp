//
//  AssetCell.m
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "ThumbnailCell.h"
#import "Thumbnail.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ThumbnailCell

-(void)displayThumbnails:(NSMutableDictionary *)array{
    CGRect frame = CGRectMake(4, 2, 75, 75);
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (ALAsset *asset in [array allValues]) {
        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:frame];
        [button setImage:image forState:UIControlStateNormal];
        [self addSubview:button];
        frame.origin.x = frame.origin.x + frame.size.width + 4;
        
    }
}

- (void) albumSelected: (id) sender {
    NSLog(@"Album Selected");
    
}


-(void)dealloc 
{

	[super dealloc];
}

@end
