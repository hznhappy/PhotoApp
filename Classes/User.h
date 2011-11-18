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
    NSString *Transtion;
	}
@property (nonatomic,retain)NSString *id;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *Transtion;
@end
