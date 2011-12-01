//
//  AlbumClass.h
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlbumClass : NSObject {
    NSString *albumId;
    NSString *albumName;
    NSInteger photoCount;
    UIImage *posterImage;
}

@property(nonatomic,retain)NSString *albumId;
@property(nonatomic,retain)NSString *albumName;
@property(nonatomic,assign)NSInteger photoCount;
@property(nonatomic,retain)UIImage *posterImage;


@end
