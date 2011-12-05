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
    
}
- (void) albumSelected: (id) sender ;

-(void)displayThumbnails:(NSMutableDictionary *)array;
@end
