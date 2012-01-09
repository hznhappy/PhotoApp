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
@synthesize selectionDelegate;
@synthesize rowNumber;

-(void)displayThumbnails:(NSArray *)array count:(NSUInteger)count{
    CGRect frame = CGRectMake(4, 2, 75, 75);
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSUInteger i = 0;i <count; i++) {
        if (i < [array count]) {
            ALAsset *asset = [array objectAtIndex:i];
            ThumbnailImageView *thumImageView = [[ThumbnailImageView alloc]initWithAsset:asset index:rowNumber*count+i];
            thumImageView.frame = frame;
            thumImageView.delegate = self;
            [self addSubview:thumImageView];
            [thumImageView release];
            frame.origin.x = frame.origin.x + frame.size.width + 4;
        }
        
    }
}

-(void)clearSelection{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ThumbnailImageView class]]) {
            [(ThumbnailImageView *)view clearSelection];
        }
    }
}
#pragma mark -
#pragma mark delegate methods;
-(void)thumbnailImageViewSelected:(ThumbnailImageView *)thumbnailImageView{
    [selectionDelegate selectedThumbnailCell:self selectedAtIndex:thumbnailImageView.thumbnailIndex];
}
-(void)dealloc 
{

	[super dealloc];
}

@end
