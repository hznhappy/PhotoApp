//
//  ThumbnailImageView.h
//  PhotoApp
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class ThumbnailImageView;

@protocol ThumbnailSelectionDelegate <NSObject>
-(void)thumbnailImageViewSelected:(ThumbnailImageView *)thumbnailImageView;
@end

@interface ThumbnailImageView : UIImageView{
    UIImageView *highlightView;
    NSUInteger thumbnailIndex;
    id<ThumbnailSelectionDelegate>delegate;
}
@property(nonatomic,assign)NSUInteger thumbnailIndex;
@property(nonatomic,assign)id<ThumbnailSelectionDelegate>delegate;
-(ThumbnailImageView *)initWithAsset:(ALAsset*)asset index:(NSUInteger)index;
-(void)setSelectedView;
-(void)clearSelection;
@end
