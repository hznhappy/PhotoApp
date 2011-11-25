//
//  AssetCell.h
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ThumbnailCell : UITableViewCell
{
	NSArray *rowAssets;
	NSMutableArray *rowThumbnails;
	NSMutableArray *loadedurls;
    ALAssetsLibrary *cellLibrary;
    NSMutableArray *allUrls;
    
    BOOL tagOverlay;
    BOOL loadSign;
    BOOL imagesReady;
}

-(id)initWithUrls:(NSArray*)_url andAssetLibrary:(ALAssetsLibrary*)assetLibrary reuseIdentifier:(NSString*)_identifier;
-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
-(void)setAssets:(NSArray*)_assets;
-(void)prepareThumail;
@property (nonatomic,retain) NSArray *rowAssets;
@property (nonatomic,retain) NSMutableArray *rowThumbnails;
@property (nonatomic,retain) NSMutableArray *loadedurls;
@property (nonatomic,retain) NSMutableArray *allUrls;
@property (nonatomic,retain) ALAssetsLibrary *cellLibrary;
@property (nonatomic,assign) BOOL tagOverlay;
@property (nonatomic,assign) BOOL loadSign;
@property (nonatomic,assign) BOOL imagesReady;

@end
