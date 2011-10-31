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
@synthesize ary,tagary,playary;
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

-(void)updateTable:(NSString *)sql{
    char* err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"Table failed to update.%s",err);
	}

}

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

-(NSMutableArray *)selectNameID:(NSString *)sql{
    NSMutableArray *nameID = [NSMutableArray arrayWithCapacity:20];
    sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            [nameID addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 0)]];
        }
	}
    
	sqlite3_finalize(stmt);
    
    return nameID;
}

-(void)closeDB{
    sqlite3_close(db);
}

- (NSMutableDictionary*)getUser1
{    
    User *user = [[User alloc]init]; 
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:40];
	NSString *countSQL = [NSString stringWithFormat:@"SELECT ID,NAME,COLOR FROM UserTable"];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NSMutableArray *arry = [NSMutableArray arrayWithCapacity:40];
            
			user.id = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement,0)];
			
			user.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
			
			user.color =[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,2)];
            
            [arry addObject:user.name];
            [arry addObject:user.color];
            [arry addObject:user.id];
            [dic1 setObject:arry forKey:user.id];
            }
		sqlite3_finalize(statement);
        return dic1;
    }

	return nil;
}

- (User*)getUser:(int)id
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
- (User*)getUser3:(NSString *)name
{
	User *user3 = [[User alloc] init];
	NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM PlayTable WHERE Name='%@'",name];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
			user3.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,0)];
			user3.with = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
			user3.without = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,2)];
		}
		sqlite3_finalize(statement);
		return user3;
		
	}
	return nil;
    [user3 release];
    
}
-(void)selectFromTable3:(NSString *)sql
{
    playary=[NSMutableArray arrayWithCapacity:100];
    NSString *newid;
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,0)];
            [playary addObject:newid];
        }
    }	
    sqlite3_finalize(statement);  

    
}



-(void)createTable1{
    char *erroMsg;
    NSString *createSQL2= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY,NAME,COLOR)",TableName1];
	if (sqlite3_exec(db, [createSQL2 UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"create table %@ faild",TableName1);
		NSAssert1(0,@"the error is %s",erroMsg);
	}
}
-(void)createTable2{
    char *erroMsg;
    NSString *createSQL2= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY)",TableName2];
	if (sqlite3_exec(db, [createSQL2 UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"create table %@ faild",TableName2);
		NSAssert1(0,@"the error is %s",erroMsg);
	}
}
-(void)insertToTable:(NSString *)sql{
    char* err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"Table failed to update.%s",err);
	}
}
-(void)createTAG
{
    char *erroMsg;
    NSString *createSQL2= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,PRIMARY KEY(ID,URL))",TableName];
	if (sqlite3_exec(db, [createSQL2 UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"create table %@ faild",TableName);
		NSAssert1(0,@"the error is %s",erroMsg);
	}

}
-(void)createTable3
{
    char *erroMsg;
    NSString *createSQL2= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(Name PRIMARY KEY NOT NULL,With,WithOut)",TableName3];
	if (sqlite3_exec(db, [createSQL2 UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"create table %@ faild",TableName3);
		NSAssert1(0,@"the error is %s",erroMsg);
	}

}
-(void)insertTAG:(NSString *)sql;
{char* err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"Table failed to update.%s",err);
	}
}
-(void)selectFromTAG:(NSString *)sql
{tagary=[NSMutableArray arrayWithCapacity:1000];
    NSString *newid;
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];

            [tagary addObject:newid];
            
           
        }
		
    }	
    sqlite3_finalize(statement);  

    
}


-(void)selectFromTable2:(NSString *)sql
{ary=[NSMutableArray arrayWithCapacity:100];
    NSString *newid;
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            newid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            [ary addObject:newid];
        }
    }	
    sqlite3_finalize(statement);  
    
}
-(void)deleteDB:(NSString *)sql
{char *et;
       if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &et) != SQLITE_OK) {
     NSAssert1(0,@"Updating table failed.%s",et);
    }    
    
}







@end
