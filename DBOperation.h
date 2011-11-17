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
    NSMutableArray *orderIdList;
    NSMutableArray *orderList;
    NSMutableArray *tagIdAry;
    NSMutableArray *playIdAry;
    NSMutableArray *playNameAry;
    NSMutableArray *playlist_UserName;
    NSMutableArray *playlist_UserId;
    NSMutableArray *playlist_UserRules;
    NSMutableSet *tagUrl;
    NSMutableArray *tagUserName;
    NSMutableArray *tagName;
}
@property(nonatomic,retain)NSMutableArray *orderIdList;
@property(nonatomic,retain)NSMutableArray *orderList;
@property(nonatomic,retain)NSMutableArray *tagIdAry;
@property(nonatomic,retain)NSMutableArray *playIdAry;
@property(nonatomic,retain)NSMutableArray *playNameAry;
@property(nonatomic,retain)NSMutableArray *playlist_UserName;
@property(nonatomic,retain)NSMutableArray *playlist_UserId;
@property(nonatomic,retain)NSMutableArray *playlist_UserRules;
@property(nonatomic,retain)NSMutableArray *photos;
@property(nonatomic,retain)NSMutableSet *tagUrl;
@property(nonatomic,retain)NSMutableArray *tagUserName;
@property(nonatomic,retain)NSMutableArray *tagName;
// apply to all views
-(void)openDB;
-(void)createTable:(NSString *)sql;
-(void)insertToTable:(NSString *)sql;
-(void)updateTable:(NSString *)sql;
-(void)closeDB;
-(void)deleteDB:(NSString *)sql; 
// apply to tagManagementController , PopupPanelView for retreiving user_id  order by idOrder or playIdOrder
-(void)selectOrderId:(NSString *)sql;
//apply to AlbumController for retreiving user_id user_name from Rules
-(void)selectFromRules:(NSString *)sql;
// apply to PhotoViewController PopupPanelView , tagManagementController ,AlbumController for retreiving tag_id,tag_url from tag table
-(void)selectFromTAG:(NSString *)sql;
//apply to AlbumController for retreiving playlist_id,playlist_name from palytable
-(void)selectFromPlayTable:(NSString *)sql;
//apply to tagManagementController , PopupPanelView,for retreiving user_id,user_name,user_color from UserTable;
- (User*)getUserFromUserTable:(int)id;
//apply to AlbumController for retreiving playlist_id,playlist_name from playTable
- (User*)getUserFromPlayTable:(int)id;
//apply to AssetTablePickerController for retreiving url from TAG
-(NSMutableArray *)selectPhotos:(NSString *)sql;
-(void)selectUserNameFromTag:(NSString *)sql;
-(NSString *)filePath;
-(BOOL)exitInDatabase:(NSString *)sql;

@end
