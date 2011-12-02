//
//  DBOperation.m
//  
//
//  Created by Andy on 9/19/11.
//  Copyright 2011 chinarewards. All rights reserved.
//
#import "DBOperation.h"
@implementation DBOperation
@synthesize orderIdList,tagList,playTableList,RulesList;
@synthesize tag1List,tagName,photos,PassTable;
@synthesize name;
@synthesize Transtion;
-(NSString *)filePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
	return [directory stringByAppendingPathComponent:@"data.db"];
}

static DBOperation* singleton;

+(DBOperation*)getInstance {
    if (singleton == nil) {
        singleton = [[DBOperation alloc] init];
    }
    return singleton;
}

-(id)init {
    [self openDB];
    return self;
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
            [photos addObject:[NSString stringWithFormat:@"%s",value]];
		}
	}
	sqlite3_finalize(stmt);
    return photos;
}
-(NSMutableArray *)selectFromPlayTable:(NSString *)sql
{NSMutableArray *playArray = [[NSMutableArray alloc]init];
    self.playTableList= playArray;
    [playArray release];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *newid=[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,0)];
            [playTableList addObject:newid];
        }
    }	
    sqlite3_finalize(statement);  
    return playTableList;
    
    
}
-(NSMutableArray *)selectFromTAG:(NSString *)sql
{ NSMutableArray *playArray = [[NSMutableArray alloc]init];
     self.tagList= playArray;
    [playArray release];
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *newName=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement, 0)];
            [tagList addObject:newName];
        }
    }	
    sqlite3_finalize(statement); 
    return tagList;
}

-(NSMutableSet *)selectFromTAG1:(NSString *)sql
{NSMutableSet *playArray = [[NSMutableSet alloc]init];
    self.tag1List= playArray;
    [playArray release];
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *newName=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement, 0)];
            [tag1List addObject:newName];
        }
    }	
    sqlite3_finalize(statement); 
    return tag1List;

    
}
-(NSMutableArray *)selectOrderId:(NSString *)sql
{
    NSMutableArray *playArray = [[NSMutableArray alloc]init];
    self.orderIdList = playArray;
    [playArray release];
 	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *newid=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
            [orderIdList addObject:newid];
            }
    }	
    sqlite3_finalize(statement);  
    return orderIdList;

    
}
-(NSMutableArray *)selectFromRules:(NSString *)sql
{
    NSMutableArray *playArray = [[NSMutableArray alloc]init];
    self.RulesList= playArray;
    [playArray release];
   	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *newId=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,0)];
            [RulesList addObject:newId];
    }
    }	
    sqlite3_finalize(statement);  
    return RulesList;
    
}
-(NSMutableArray *)selectFromPassTable:(NSString *)sql
{
    NSMutableArray *playArray = [[NSMutableArray alloc]init];
    self.PassTable= playArray;
    [playArray release];
   	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *new=[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,0)];
            [PassTable addObject:new];
        }
    }	
    sqlite3_finalize(statement);  
    return PassTable;

}
- (NSString *)getUserFromUserTable:(int)id
{
	NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM UserTable WHERE ID= %d",id];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
        self.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
		}
		sqlite3_finalize(statement);
        return name;
	}
   
	return nil;
    
}
- (void)getUserFromPlayTable:(int)_id
{
	NSString *countSQL = [NSString stringWithFormat:@"SELECT * FROM PlayTable WHERE playList_id=%d",_id];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, [countSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
			self.name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(statement,1)];
            self.Transtion=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)];
			
		}
		sqlite3_finalize(statement);
        }
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
    [photos release];
    [name release];
    [Transtion release];
    [singleton release];
    [tagList release];
    [playTableList release];
    [RulesList release];
    [tag1List release];
    [super dealloc];
}




@end
