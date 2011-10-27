//
//  ResultViewController.h
//  ELCImagePickerDemo
//
//  Created by apple on 11-9-16.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"
#define DataFile @"data.sqlite3"
#define TableName1  @"UserTable1"

@interface ResultViewController : UIViewController {
	UITextField *txt1;
	//UITextField *txt2;
	//UITextField *txt3;
	sqlite3 *database;
    NSString *name;
}
@property (nonatomic,retain)UITextField *txt1;
@property (nonatomic,retain)NSString *name;
//@property (nonatomic,retain)UITextField *txt2;
//@property (nonatomic,retain)UITextField *txt3;
-(NSString*)databasePath;
@end
