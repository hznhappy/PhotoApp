//
//  ThumbnailImageView.m
//  PhotoApp
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 chinarewards. All rights reserved.
//

#import "ThumbnailImageView.h"

@implementation ThumbnailImageView
@synthesize thumbnailIndex;
@synthesize delegate;

-(ThumbnailImageView *)initWithAsset:(ALAsset*)asset index:(NSUInteger)index{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        CGImageRef ref = [asset thumbnail];
        UIImage *img = [UIImage imageWithCGImage:ref];
        [self setImage:img];
        self.thumbnailIndex = index;
    }
    return self;
}
#pragma mark -
#pragma mark Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setSelectedView];
    [self addSubview:highlightView];
    NSLog(@"nothing");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate thumbnailImageViewSelected:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [highlightView removeFromSuperview];
}

#pragma mark -
#pragma mark Helper mehtods;
- (void)clearSelection {
    [highlightView removeFromSuperview];
}


-(void)setSelectedView{
    if (!highlightView) {
        UIImage *image = [UIImage imageNamed:@"ThumbnailHighlight.png"];
        highlightView = [[UIImageView alloc]initWithImage:image];
        highlightView.alpha = 0.5;
    }
    
}
@end
