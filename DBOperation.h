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
#define TableName1  @"UserTable"
#define TableName2 @"idTable"
#define TableName @"TAG"
#define TableName3 @"PlayTable"
@interface DBOperation : NSObject {
    NSMutableArray *photos;
    NSDictionary *dic;
    int tagValue;
    sqlite3 *db;
    NSMutableArray *ary;
    NSMutableArray *tagary;
    NSMutableArray *playary;

}
@property(nonatomic,retain)NSMutableArray *ary;
@property(nonatomic,retain)NSMutableArray *tagary;
@property(nonatomic,retain)NSMutableArray *playary;
- (NSMutableDictionary*)getUser1;
-(void)createTable2;
-(void)createTable1;
-(void)insertToTable:(NSString *)sql;
-(void)selectFromTable2:(NSString *)sql;
-(void)deleteDB:(NSString *)sql;
- (User*)getUser:(int)id;
- (User*)getUser3:(NSString *)name;
-(void)createTable3;
-(void)selectFromTable3:(NSString *)sql;
-(void)openDB;
-(void)createTable:(NSString *)sql;
-(void)updateTable:(NSString *)sql;
-(NSMutableArray *)selectNameID:(NSString *)sql;
-(NSMutableArray *)selectPhotos:(NSString *)sql;
-(BOOL)exitInDatabase:(NSString *)sql;
-(NSString *)filePath;
-(void)closeDB;
-(void)createTAG;
-(void)insertTAG:(NSString *)sql;
-(void)selectFromTAG:(NSString *)sql;

@end
