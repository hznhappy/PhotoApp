//
//  User.h
//  PhotoApp
//
//  Created by apple on 11-9-29.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface User : NSObject{
	
	NSString *id;
	NSString *name;
	NSString *color;
    NSString *with;
    NSString *without;
    NSString *name1;
    
	}
@property (nonatomic,retain)NSString *id;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *name1;
@property (nonatomic,retain)NSString *color;
@property (nonatomic,retain)NSString *with;
@property (nonatomic,retain)NSString *without;

@end
