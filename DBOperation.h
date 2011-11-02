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
#define idTable @"idTable"
#define TAG @"TAG"
#define PlayTable @"PlayTable"
#define rules @"rules"
@interface DBOperation : NSObject {
    NSMutableArray *photos;
    NSDictionary *dic;
    int tagValue;
    sqlite3 *db;
    NSMutableArray *ary;
    NSMutableArray *tagary;
    NSMutableArray *playary;
    NSMutableArray *urlary;

}
@property(nonatomic,retain)NSMutableArray *urlary;
@property(nonatomic,retain)NSMutableArray *ary;
@property(nonatomic,retain)NSMutableArray *tagary;
@property(nonatomic,retain)NSMutableArray *playary;
-(void)openDB;
-(void)createTable:(NSString *)sql;
-(void)insertToTable:(NSString *)sql;
-(void)updateTable:(NSString *)sql;
-(void)selectFromIdTable:(NSString *)sql;
-(void)selectFromTAG:(NSString *)sql;
-(void)selectFromPlayTable:(NSString *)sql;
- (User*)getUserFromUserTable:(int)id;
- (User*)getUserFromPlayTable:(int)id;
-(BOOL)exitInDatabase:(NSString *)sql;
-(void)closeDB;
-(void)deleteDB:(NSString *)sql;
-(NSMutableArray *)selectPhotos:(NSString *)sql;
-(NSString *)filePath;
@end
