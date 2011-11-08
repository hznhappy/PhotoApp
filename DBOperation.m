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
@synthesize orderIdList,orderList,tagIdAry,playNameAry,playIdAry,playlist_UserName,tagUrl,playlist_UserId;
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
    photos = [[NSMutableArray arrayWithCapacity:40]retain];
    sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			char *value = (char *)sqlite3_column_text(stmt, 0);
            [photos addObject:[NSString stringWithFormat:@"%s",value]];
		}
	}
	sqlite3_finalize(stmt);
    return photos;
}
-(void)selectFromPlayTable:(NSString *)sql
{
    playIdAry=[[NSMutableArray arrayWithCapacity:40]retain];
    playNameAry=[[NSMutableArray arrayWithCapacity:40]retain];
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
{tagIdAry=[[NSMutableArray arrayWithCapacity:40]retain];
 tagUrl=[[[NSMutableSet alloc]init]retain];
    NSString *newid;
    NSString *newUrl;
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            newUrl=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)];
            
            [tagIdAry addObject:newid];
            [tagUrl addObject:newUrl];
            NSLog(@"TAGURL%@",tagUrl);
            
            
        }
		
    }	
    sqlite3_finalize(statement);  
}
-(void)selectOrderId:(NSString *)sql
{orderIdList=[[NSMutableArray arrayWithCapacity:40]retain];
    //orderList=[NSMutableArray arrayWithCapacity:40];
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
    playlist_UserId=[[NSMutableArray arrayWithCapacity:40]retain];
    NSString *newId;
    playlist_UserName=[[NSMutableArray arrayWithCapacity:40]retain];
    NSString *newname;
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newId=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)];
            [playlist_UserId addObject:newId];
            newname=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
            [playlist_UserName addObject:newname];
            // NSLog(@"FSD%@",playlist_nameIn);
        }
    }	
    sqlite3_finalize(statement);  
    
}
- (User*)getUserFromUserTable:(int)id
{
	User *user1 = [[User alloc] init];
	NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM UserTable WHERE ID= %d",id];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
			user1.id = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement,0)];
			user1.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
			user1.color = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,2)];
		}
		sqlite3_finalize(statement);
		return user1;
		
	}
    [user1 release];
	return nil;
    
}
- (User*)getUserFromPlayTable:(int)id
{
	User *user3 = [[User alloc] init];
	NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM PlayTable WHERE playList_id=%d",id];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
			user3.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
			
		}
		sqlite3_finalize(statement);
		return user3;
		
	}
	return nil;
    [user3 release];
    
}
-(BOOL)exitInDatabase:(NSString *)sql{
    sqlite3_stmt *stmt;
    int *value;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            value = (int*)sqlite3_column_int(stmt, 0);
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
{
    [orderIdList release];
    [orderList release];
    [tagIdAry release];
    [playIdAry release];
    [playlist_UserName release];
    [playlist_UserId release];
    // NSMutableArray *playlist_name;
    [tagUrl release];
    [photos release];

    
   
    [super dealloc];
}




@end
