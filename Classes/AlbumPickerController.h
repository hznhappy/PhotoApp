//
//  AlbumPickerController.h
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlbumPickerController : UITableViewController {
	
	NSMutableArray *assetGroups;
}

@property (nonatomic, retain) NSMutableArray *assetGroups;
-(void)getAssetGroup;
@end

