//
//  TextController.h
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOperation.h"
#define TableName3 @"PlayTable" 
@interface TextController : UIViewController {
    DBOperation *da;
    IBOutlet UITextField *listName;
    IBOutlet UITextField *nameIn;
    IBOutlet UITextField *nameOut;
    NSString *str1;
    NSString *str2;
    NSString *str3;
}
@property(nonatomic,retain)UITextField *listName;
@property(nonatomic,retain)UITextField *nameIn;
@property(nonatomic,retain)UITextField *nameOut;
@property(nonatomic,assign)NSString *str1;
@property(nonatomic,assign)NSString *str2;
@property(nonatomic,assign)NSString *str3;
@end
