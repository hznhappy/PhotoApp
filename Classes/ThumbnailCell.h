//
//  AssetCell.h
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThumbnailCell : UITableViewCell
{
	NSArray *rowAssets;
}

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
-(void)setAssets:(NSArray*)_assets;

@property (nonatomic,retain) NSArray *rowAssets;

@end
