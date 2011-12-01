//
//  AlbumClass.m
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AlbumClass.h"


@implementation AlbumClass
@synthesize albumId;
@synthesize albumName;
@synthesize photoCount;
@synthesize posterImage;


-(void)dealloc{
    [albumId release];
    [albumName release];
    [posterImage release];
    [super dealloc];
}
@end
