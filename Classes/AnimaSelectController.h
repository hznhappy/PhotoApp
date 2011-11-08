//
//  AnimaSelectController.h
//  PhotoApp
//
//  Created by Andy on 11/4/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnimaSelectController : UIViewController<UITableViewDelegate,UITableViewDataSource>
 {
    NSMutableArray *animaArray;
     NSString *tranStyle;
}
@property(nonatomic,retain)NSMutableArray *animaArray;
@property(nonatomic,retain)NSString *tranStyle;

@end
