//
//  DBOperation.m
//  
//
//  Created by Andy on 9/19/11.
//  Copyright 2011 chinarewards. All rights reserved.
//
#import "DBOperation.h"
#import "User.h"
@implementation DBOperation
@synthesize orderIdList,orderList,tagIdAry,playNameAry,playIdAry,playlist_UserName,tagUrl,playlist_UserId,playlist_UserRules,photos;
@synthesize tagUserName,tagName;
-(NSString *)filePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
	return [directory stringByAppendingPathComponent:@"data.db"];
}

-(void)openDB{
    if (sqlite3_open([[self filePath]UTF8String],&db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"DataBase failed to open!");
    }
}

-(void)createTable:(NSString *)sql{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"Table failed to create.%s",err);
	}
}
-(void)insertToTable:(NSString *)sql{
    char* err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"Table failed to update.%s",err);
	}
}

-(void)updateTable:(NSString *)sql{
    char* err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"Table failed to update.%s",err);
	}
    
}
-(NSMutableArray *)selectPhotos:(NSString *)sql{
    NSMutableArray *playArray = [[NSMutableArray alloc]init];
    self.photos= playArray;
    [playArray release];
    sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			char *value = (char *)sqlite3_column_text(stmt, 0);
            //NSString *o=[NSString stringWithUTF8String:(char*) sqlite3_column_text(stmt,0)];
            [photos addObject:[NSString stringWithFormat:@"%s",value]];
		}
	}
	sqlite3_finalize(stmt);
    return photos;
}
-(void)selectFromPlayTable:(NSString *)sql
{NSMutableArray *playArray = [[NSMutableArray alloc]init];
     NSMutableArray *playArray1 = [[NSMutableArray alloc]init];
        
    self.playNameAry= playArray;

    self. playIdAry= playArray1;
    [playArray release];
    [playArray1 release];
    NSString *newid;
    NSString *newname;
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,0)];
            newname=[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)];
            [playIdAry addObject:newid];
            [playNameAry addObject:newname];
        }
    }	
    sqlite3_finalize(statement);  
    
    
}
-(void)selectFromTAG:(NSString *)sql
{ NSMutableArray *playArray = [[NSMutableArray alloc]init];
  NSMutableSet *playArray1 = [[NSMutableSet alloc]init];
  NSMutableArray *playArray2 = [[NSMutableArray alloc]init];
    self.tagIdAry= playArray;
    self.tagUrl= playArray1;
    self.tagUserName=playArray2;
    [playArray release];
    [playArray1 release];
    [playArray2 release];
    NSString *newid;
    NSString *newUrl;
    NSString *newName;
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            newUrl=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)];
            newName=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement, 2)];
            [tagIdAry addObject:newid];
            [tagUrl addObject:newUrl];
            [tagUserName addObject:newName];
        }
    }	
    sqlite3_finalize(statement);  
}



-(void)selectUserNameFromTag:(NSString *)sql;
{
     NSMutableArray *playArray = [[NSMutableArray alloc]init];
    self.tagName=playArray;
    [playArray release];
       NSString *newName;
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newName=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,0)];
            [tagName addObject:newName];
        }
    }
    sqlite3_finalize(statement);  
}



-(void)selectOrderId:(NSString *)sql
{
    NSMutableArray *playArray = [[NSMutableArray alloc]init];
    self.orderIdList = playArray;
    [playArray release];
    NSString *newid;
    
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            
            [orderIdList addObject:newid];
           
            
        }
    }	
    sqlite3_finalize(statement);  
    
}
-(void)selectFromRules:(NSString *)sql
{
    NSMutableArray *playArray = [[NSMutableArray alloc]init];
    NSMutableArray *playArray1 = [[NSMutableArray alloc]init];
     NSMutableArray *playArray2 = [[NSMutableArray alloc]init];
    self.playlist_UserId= playArray;
    self.playlist_UserName= playArray1;
    self.playlist_UserRules= playArray2;
    [playArray release];
    [playArray1 release];
    [playArray2 release];
    NSString *newId;
    NSString *newname;
    NSString *newRule;
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newId=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)];
            [playlist_UserId addObject:newId];
            newname=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
            [playlist_UserName addObject:newname];
             newRule=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,2)];
            [playlist_UserRules addObject:newRule];
        }
    }	
    sqlite3_finalize(statement);  
    
}
- (User*)getUserFromUserTable:(int)id
{
	User *user1 = [[[User alloc] init] autorelease];
	NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM UserTable WHERE ID= %d",id];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
			user1.Uid = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement,0)];
			user1.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
		}
		sqlite3_finalize(statement);
		return user1;
		
	}
   
	return nil;
    
}
- (User*)getUserFromPlayTable:(int)id
{
	User *user3 = [[[User alloc] init]autorelease];
	NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM PlayTable WHERE playList_id=%d",id];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
			user3.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
            user3.Transtion=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)];
			
		}
		sqlite3_finalize(statement);
		
        return user3;
		
	}
	return nil;
    
    
}
-(BOOL)exitInDatabase:(NSString *)sql{
    sqlite3_stmt *stmt;
    int value=0;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            value = (int)sqlite3_column_int(stmt, 0);
        }
	}
    
	sqlite3_finalize(stmt);
    if (value == 0) {
        return NO;
    }else
        return YES;
    
}

-(void)deleteDB:(NSString *)sql
{char *et;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &et) != SQLITE_OK) {
        NSAssert1(0,@"Updating table failed.%s",et);
    }    
    
}

-(void)closeDB{
    sqlite3_close(db);
}

-(void)dealloc
{   [tagName release];
    [orderIdList release];
    [orderList release];
    [tagIdAry release];
    [playIdAry release];
    [playlist_UserName release];
    [playlist_UserId release];
    [tagUserName release];
    [tagUrl release];
    [photos release];
    [playlist_UserRules release];
    [super dealloc];
}




@end
