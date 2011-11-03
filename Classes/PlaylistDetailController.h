//
//  PlaylistDetailController.h
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlaylistDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    UITableView *listTable;
    UISwitch *mySwitch;
    UITextField *playlistName;
    NSString *listName;

}
@property(nonatomic,retain)IBOutlet UITableView *listTable;
@property(nonatomic,retain)UISwitch *mySwitch;
@property(nonatomic,retain)IBOutlet NSString *listName;

@end
