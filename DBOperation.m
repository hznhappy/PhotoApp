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
@synthesize orderIdList,orderList,tagIdAry,playIdAry,playlist_UserName,tagUrl,playlist_UserId;
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

/*-(void)selectFromRulesAndTag:(int)id;
{
    playlistUrl=[NSMutableArray arrayWithCapacity:40];
    NSString *newUrl;
    NSString *selectRuleAndTag= [NSString stringWithFormat:@"select t.url,t.id from tag t,rules r where r.playlist_id=%d and r.user_id=t.id and r.playlist_rules=1 and t.url not in (select t2.url from tag t2,rules r2 where r2.playlist_id=%d and r2.playlist_rules=0 and r2.user_id=t2.id);",id,id];
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [selectRuleAndTag UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newUrl=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            
            [playlistUrl addObject:newUrl];
            
        }
        
    }
}
*/
-(NSMutableArray *)selectPhotos:(NSString *)sql{
    photos = [NSMutableArray arrayWithCapacity:40];
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
    playIdAry=[NSMutableArray arrayWithCapacity:40];
    NSString *newid;
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,0)];;
            [playIdAry addObject:newid];
        }
    }	
    sqlite3_finalize(statement);  
    
    
}
-(void)selectFromTAG:(NSString *)sql
{tagIdAry=[NSMutableArray arrayWithCapacity:40];
 tagUrl=[[NSMutableSet alloc]init];
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
{orderIdList=[NSMutableArray arrayWithCapacity:40];
    //orderList=[NSMutableArray arrayWithCapacity:40];
    NSString *newid;
    // NSString *newOrderid;
	sqlite3_stmt *statement;
    NSLog(@"fewre");
    //NSString *selectIdTablendUserTable=[NSString stringWithFormat:@"select id from idtable" ]; 
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		NSLog(@"FG");
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            //newOrderid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            NSLog(@"EWEW%@",newid);
            [orderIdList addObject:newid];
            //[orderList addObject:newOrderid];
            
        }
    }	
    sqlite3_finalize(statement);  
    
}
-(void)selectFromRules:(NSString *)sql
{NSLog(@"frfrt");
    playlist_UserId=[NSMutableArray arrayWithCapacity:40];
    NSString *newId;
    playlist_UserName=[NSMutableArray arrayWithCapacity:40];
    NSString *newname;
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		NSLog(@"ONE");
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSLog(@"TWO");
            newId=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)];
            NSLog(@"weishenme%@",newId);
            [playlist_UserId addObject:newId];
            newname=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,1)];
            //NSLog(@"%@",newname);
            [playlist_UserName addObject:newname];
            // NSLog(@"FSD%@",playlist_nameIn);
        }
    }	
    sqlite3_finalize(statement);  
    
}
/*-(void)selectNameFromRules:(NSString *)sql
 {
 playlist_UserName=[NSMutableArray arrayWithCapacity:40];
 NSString *newname;
 sqlite3_stmt *statement;
 if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
 
 while (sqlite3_step(statement)==SQLITE_ROW) {
 newname=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)];
 //NSLog(@"%@",newname);
 [playlist_UserName addObject:newname];
 // NSLog(@"FSD%@",playlist_nameIn);
 }
 }	
 sqlite3_finalize(statement);  
 
 }*/
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






@end
