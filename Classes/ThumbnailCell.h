//
//  AssetCell.h
//
//  Created by Andy.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ThumbnailImageView.h"

@class ThumbnailCell;

@protocol ThumbnailCellSelectionDelegate <NSObject>

-(void)selectedThumbnailCell:(ThumbnailCell *)cell selectedAtIndex:(NSUInteger)index;

@end 

@interface ThumbnailCell : UITableViewCell<ThumbnailSelectionDelegate>
{
    NSUInteger rowNumber;
    id<ThumbnailCellSelectionDelegate>selectionDelegate;
}

@property (nonatomic, assign) NSUInteger rowNumber;
@property (nonatomic, assign) id<ThumbnailCellSelectionDelegate> selectionDelegate;


-(void)displayThumbnails:(NSArray *)array count:(NSUInteger)count;
-(void)clearSelection;
@end
