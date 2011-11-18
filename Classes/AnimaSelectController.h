//
//  AnimaSelectController.h
//  PhotoApp
//
//  Created by Andy on 11/4/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOperation.h"

@interface AnimaSelectController : UIViewController<UITableViewDelegate,UITableViewDataSource>
 {
    NSMutableArray *animaArray;
     NSString *tranStyle;
     DBOperation *database;
     NSMutableArray *Trans_list;
     NSString *play_id;
     NSString *Text;
}
@property(nonatomic,retain)NSMutableArray *animaArray;
@property(nonatomic,retain)NSString *tranStyle;
@property(nonatomic,retain)NSMutableArray *Trans_list;
@property(nonatomic,retain)NSString *play_id;
@property(nonatomic,retain) NSString *Text;
-(void)creatTable;
@end
