//
//  DisplayPhotoView.m
//  PhotoApp
//
//  Created by Andy on 12/6/11.
//  Copyright 2011 chinarewards. All rights reserved.
//
#import <QuartzCore/CATiledLayer.h>
#import "DisplayPhotoView.h"

//	#define NEW_DRAW 1

@implementation DisplayPhotoView
@synthesize image;

- (void)drawRect:(CGRect)rect {
 	//CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect imageRect;
	imageRect.origin = CGPointMake(0, 0);
	imageRect.size = self.frame.size;
    
    [self.image drawInRect:imageRect];
}

- (void)dealloc
{
    [image release];
    [super dealloc];
}


@end
