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
    BOOL tagOverlay;
    BOOL loadSign;
}

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
-(void)setAssets:(NSArray*)_assets;

@property (nonatomic,retain) NSArray *rowAssets;
@property (nonatomic,assign) BOOL tagOverlay;
@property (nonatomic,assign) BOOL loadSign;

@end
