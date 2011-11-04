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
}
@property(nonatomic,retain)NSMutableArray *animaArray;
@end
