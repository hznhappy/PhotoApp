//
//  DBOperation.h
//  
//
//  Created by Andy on 9/19/11.
//  Copyright 2011 chinarewards . All rights reserved.
//

#import <Foundation/Foundation.h>
#import<sqlite3.h>
#import "User.h"
#define UserTable  @"UserTable"
#define idOrder @"idOrder"
#define playIdOrder @"PlayIdOrder"
#define TAG @"TAG"
#define PlayTable @"PlayTable"
#define rules @"rules"
@interface DBOperation : NSObject {
    NSMutableArray *photos;
    NSDictionary *dic;
    int tagValue;
    sqlite3 *db;
<<<<<<< HEAD
    NSMutableArray *orderIdList;
    NSMutableArray *orderList;
    NSMutableArray *tagIdAry;
    NSMutableArray *playIdAry;
    NSMutableArray *playlist_name;
    NSMutableArray *playlist_Id;
   // NSMutableArray *playlist_nameOut;
    NSMutableArray *playlistUrl;
}
@property(nonatomic,retain)NSMutableArray *orderIdList;
@property(nonatomic,retain)NSMutableArray *orderList;
@property(nonatomic,retain)NSMutableArray *tagIdAry;
@property(nonatomic,retain)NSMutableArray *playIdAry;
@property(nonatomic,retain)NSMutableArray *playlist_name;
@property(nonatomic,retain)NSMutableArray *playlist_Id;
//@property(nonatomic,retain)NSMutableArray *playlist_nameOut;
@property(nonatomic,retain)NSMutableArray *playlistUrl;
// apply to all views
=======
    NSMutableArray *ary;
    NSMutableArray *tagary;
    NSMutableArray *playary;
    NSMutableArray *urlary;

}
@property(nonatomic,retain)NSMutableArray *urlary;
@property(nonatomic,retain)NSMutableArray *ary;
@property(nonatomic,retain)NSMutableArray *tagary;
@property(nonatomic,retain)NSMutableArray *playary;
>>>>>>> 15e8e02534a590f74c6e26c281e6653427a25607
-(void)openDB;
-(void)createTable:(NSString *)sql;
-(void)insertToTable:(NSString *)sql;
-(void)updateTable:(NSString *)sql;
-(void)closeDB;
-(void)deleteDB:(NSString *)sql;

// apply to DeleteMeController , PopupPanelView for retreiving user_id  order by idOrder or playIdOrder
-(void)selectOrderId:(NSString *)sql;
//apply to UserTableController for retreiving user_name from Rules
-(void)selectNameFromRules:(NSString *)sql;
//apply to UserTableController to retreiving user_id from rules;
-(void)selectIdFromRules:(NSString *)sql;
//apply to UserTableController for retreiving url from TAG and Rules
-(void)selectFromRulesAndTag:(int)id;
// apply to PhotoViewController PopupPanelView , DeleteMeController ,UserTableController for retreiving tag_id,tag_url from tag table
-(void)selectFromTAG:(NSString *)sql;
//apply to UserTableController for retreiving playlist_id,playlist_name from palytable
-(void)selectFromPlayTable:(NSString *)sql;
//apply to DeleteMeController , PopupPanelView,for retreiving user_id,user_name,user_color from UserTable;
- (User*)getUserFromUserTable:(int)id;
//apply to UserTableController for retreiving playlist_id,playlist_name from playTable
- (User*)getUserFromPlayTable:(int)id;
//apply to AssetTablePickerController for retreiving url from TAG
-(NSMutableArray *)selectPhotos:(NSString *)sql;
-(NSString *)filePath;
-(BOOL)exitInDatabase:(NSString *)sql;
@end
