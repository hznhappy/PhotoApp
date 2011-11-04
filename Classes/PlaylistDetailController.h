//
//  PlaylistDetailController.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBOperation;
@interface PlaylistDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    UITableView *listTable;
    BOOL mySwc;
    NSString *listName;
    
    DBOperation *dataBase;

}
@property(nonatomic,retain)IBOutlet UITableView *listTable;
@property(nonatomic,assign)BOOL mySwc;
@property(nonatomic,retain)NSString *listName;
-(void)updateTable:(id)sender;
@end
