//
//  PlaylistProducer.m
//  PhotoApp
//
//  Created by Andy on 12/1/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistProducer.h"
#import "AlbumClass.h"
#import "AssetProducer.h"


@implementation PlaylistProducer
@synthesize playlists;
@synthesize assetProducer;
@synthesize list;
@synthesize TagUrl;
@synthesize assetGroups;
@synthesize allCount;
@synthesize SUM;
@synthesize dbUrl;
@synthesize dbCount;
- (id) initWithAssetProcuder:(AssetProducer *)_assetProducer {
    self = [super init];
    da=[DBOperation getInstance];
    [self creatTable];
    [self selectID];
     self.assetGroups=[[NSMutableArray alloc]init];
    if (self) {
        self.playlists = [[NSMutableArray alloc]init];
        self.assetProducer = _assetProducer;
       
        [self doFetchPlaylists];
        [self count];
         
      }
    return self;
}

- (void) doFetchPlaylists {
    self.playlists = [[NSMutableArray alloc]init];
    
    for (NSString *_id in self.list) 
    {
        [da getUserFromPlayTable:_id];
        
        AlbumClass *album = [[AlbumClass alloc]init];
        album.albumId = _id;
        album.albumName = da.name;
        [self.playlists addObject:album];
        [album release];
    }

        //NSInteger allPhotoscount =allCount;
      /*  if([_id intValue]==-1)
        {
            album.photoCount = allCount;
            NSLog(@"photoCount:%d",album.photoCount);
        }
        else if([_id intValue]==-2)
        {
         //album.photoCount=[]  
            album.photoCount=allCount-[TagUrl count];
        }*/
         // .....
         
      
}
-(void)count
{
   [self.assetGroups removeAllObjects];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
    { 
        if (group == nil) 
        { allCount=0;
              NSLog(@"gcount22:%d",allCount);
            ALAssetsGroup *group;
            for(int i=0;i<[assetGroups count];i++)
            {
                group = (ALAssetsGroup*)[assetGroups objectAtIndex:i];
                [group setAssetsFilter:[ALAssetsFilter allAssets]];
                allCount +=[group numberOfAssets];
                NSLog(@"gcount33:%d",allCount);
            }
            NSLog(@"gcount11:%d",allCount);
            [self photoCount];
            return;
        }               
        [self.assetGroups addObject:group];
};

void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[NSString stringWithFormat:@"Error: %@", [error description]] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles:nil];
    [alert show];
    [alert release];                                 
};	
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
[library enumerateGroupsWithTypes:ALAssetsGroupAll
                       usingBlock:assetGroupEnumerator 
                     failureBlock:assetGroupEnumberatorFailure];

[library release];
[pool release];

}
-(void)photoCount
{
    NSLog(@"gcount:%d",allCount);
    for (AlbumClass *album in self.playlists) {
        if ([album.albumId intValue]==-1) {
            album.photoCount = allCount;
        }else if([album.albumId intValue]==-2){
            [self getTagUrl];
            NSInteger j =allCount-[self.TagUrl count];
            
            album.photoCount = j;
            NSLog(@"item dfdf %d",album.photoCount);
            
        }else{
            [self playlistUrl:[album.albumId intValue]];
        album.photoCount = dbCount;
            
        }
    }
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addcount" 
                                                       object:self 
                                                     userInfo:dic1];
    

}
-(void)deleteTable:(NSInteger)index
{
    NSString *deletePlayTable = [NSString stringWithFormat:@"DELETE FROM PlayTable WHERE playList_id=%d",[[list objectAtIndex:index]intValue]];
    NSLog(@"%@",deletePlayTable );
    [da deleteDB:deletePlayTable ]; 
    NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playList_id=%d",[[list objectAtIndex:index]intValue]];
    NSLog(@"%@",deleteRules);
    [da deleteDB:deleteRules]; 
    NSString *deleteplayIdOrder= [NSString stringWithFormat:@"DELETE FROM playIdOrder WHERE play_id=%d",[[list objectAtIndex:index]intValue]];
    NSLog(@"%@",deleteplayIdOrder);
    [da deleteDB:deleteplayIdOrder]; 

}
-(void)creatTable
{
    
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [da createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT PRIMARY KEY)",playIdOrder];
    [da createTable:createPlayIdOrder];
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [da createTable:createRules];
    NSString *createTag= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT,URL TEXT,NAME,PRIMARY KEY(ID,URL))",TAG];
    [da createTable:createTag];
    NSString *createPassTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(LOCK,PASSWORD,PLAYID)",PassTable];
    [da createTable:createPassTable];
    NSString *selectPlayTable = [NSString stringWithFormat:@"select count(*) from PlayTable"];
    NSInteger count=[[[da selectFromPlayTable:selectPlayTable]objectAtIndex:0]intValue];
    if(count==0)
    {  
        [self Special];
    }
    
}
-(void)selectID
{
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select play_id from playIdOrder"];
    self.list=[da selectOrderId:selectPlayIdOrder];
    
}
-(void)tableorder
{ da=[DBOperation getInstance];
    NSString *deleteIdTable= [NSString stringWithFormat:@"DELETE FROM playIdOrder"];	
     NSLog(@"%@",deleteIdTable);
     [da deleteDB:deleteIdTable];
    for(AlbumClass *al in self.playlists)
    {NSLog(@"AlbumClass:%@",al.albumId);
     NSString *insertIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(play_id) VALUES(%d)",playIdOrder,[al.albumId intValue]];
     NSLog(@"%@",insertIdOrder);
     [da insertToTable:insertIdOrder];    
    }
}
-(void)Special
{
    NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_id,playList_name) VALUES(%d,'%@')",PlayTable,-1,@"ALL"];
    NSLog(@"%@",insertPlayTable);
    [da insertToTable:insertPlayTable];
    NSString *insertPlayTable1= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_id,playList_name) VALUES(%d,'%@')",PlayTable,-2,@"UNTAG"];
    NSLog(@"%@",insertPlayTable1);
    [da insertToTable:insertPlayTable1];
    NSString *insertPlayIdOrder= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,-1];
    NSLog(@"%@",insertPlayIdOrder);
    [da insertToTable:insertPlayIdOrder];
    NSString *insertPlayIdOrder1= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,-2];
    NSLog(@"%@",insertPlayIdOrder1);
    [da insertToTable:insertPlayIdOrder1];
}
-(void)getTagUrl
{
    [self.TagUrl removeAllObjects];
    NSString *selectSql = @"SELECT DISTINCT URL FROM TAG";
    self.TagUrl = [da selectPhotos:selectSql];
}
-(void)playlistUrl:(int)row_id
{   dbCount=0;
    BOOL P=YES;
    [SUM removeAllObjects];
    [dbUrl removeAllObjects];
    NSString *selectRules1= [NSString stringWithFormat:@"select user_id from rules where playlist_id=%d and playlist_rules=%d",row_id,1];
    NSMutableArray *playlist_UserId1=[da selectFromRules:selectRules1];
    for(int i=0;i<[playlist_UserId1 count];i++)
    {
        NSString *selectTag= [NSString stringWithFormat:@"select URL from tag where ID=%d",[[playlist_UserId1 objectAtIndex:i]intValue]];
        NSMutableSet *play_url1=[da selectFromTAG1:selectTag];
        if([play_url1 count]==0)
        {
            [SUM removeAllObjects];
            P=NO;
            break;
        }
        else
        {
            if([self.SUM count]==0)
            {
                self.SUM=play_url1;
                
            }
            else
            {
                [self.SUM intersectSet:play_url1];
            }
        }
        dbCount=[SUM count];
    }
    if(P==YES)
    {NSLog(@"yes");
        NSString *selectRules0= [NSString stringWithFormat:@"select user_id from rules where playlist_id=%d and playlist_rules=%d",row_id,0];
        NSMutableArray *playlist_UserId0=[da selectFromRules:selectRules0];
        for(int i=0;i<[playlist_UserId0 count];i++)
        {
            NSString *selectTag= [NSString stringWithFormat:@"select URL from tag where ID=%d",[[playlist_UserId0 objectAtIndex:i]intValue]];
            NSMutableSet *play_url0=[da selectFromTAG1:selectTag];
            if([self.SUM count]==0)
            {
                NSMutableSet *t=[[NSMutableSet alloc]init];
                for (NSString *url in self.assetProducer.assetsUrlOrdering) {
                    [t addObject:url];
                }
                
                self.SUM=t;
                dbCount=self.allCount;
                NSLog(@"dbCount11:%d",dbCount);
                [t release];
                for (NSString *data in play_url0)
                {
                    if([self.SUM containsObject:data]) 
                    {
                        [self.SUM removeObject:data];
                    }
                    
                }
                dbCount=dbCount-[play_url0 count];
            }
            else
            {
                for (NSString *data in play_url0)
                {
                    if([self.SUM containsObject:data]) 
                    {
                        
                        [self.SUM removeObject:data];
                        dbCount=dbCount-1;
                    }
                }
            }
        }
        
        NSString *selectRules2= [NSString stringWithFormat:@"select user_id from rules where playlist_id=%d and playlist_rules=%d",row_id,2];
        NSMutableArray *playlist_UserId2=[da selectFromRules:selectRules2];
        for(int i=0;i<[playlist_UserId2 count];i++)
        {
            NSString *selectTag= [NSString stringWithFormat:@"select URL from tag where ID=%d",[[playlist_UserId2 objectAtIndex:i]intValue]];
            NSMutableSet *play_url2=[da selectFromTAG1:selectTag];
            
            NSLog(@"WE%@",playlist_UserId2);
            if([self.SUM count]==0)
                
            {
                self.SUM=play_url2;
            }
            else
            {
                [SUM unionSet:play_url2];
            }
        }
        
    }
    NSLog(@"dbCount:%d",dbCount);
    /*for (NSString *dataStr in self.SUM) {
        NSURL *dbStr = [NSURL URLWithString:dataStr];
        [dbUrl addObject:dbStr];
    }*/
}


@end
