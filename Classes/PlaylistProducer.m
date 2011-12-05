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
@synthesize list,allUrl;
- (id) initWithAssetProcuder:(AssetProducer *)_assetProducer {
    self = [super init];
    da=[DBOperation getInstance];
    [self creatTable];
    if (self) {
        self.playlists = [[NSMutableArray alloc]init];
        self.assetProducer = _assetProducer;
        
       //[self doFetchPlaylists];
        [self performSelectorOnMainThread:@selector(doFetchPlaylists) withObject:nil waitUntilDone:YES];
        //[self performSelector:@selector(doFetchPlaylists) withObject:nil afterDelay:1];

    }
    return self;
}

- (void) doFetchPlaylists {
    self.playlists = [[NSMutableArray alloc]init];
    // 1: all
     for (NSString *_id in self.list) {
          [da getUserFromPlayTable:_id];
         //[self.assetProducer fetchAssets];
        // NSLog(@"assert:%@",assetProducer.assetsUrlOrdering);
         NSInteger allPhotoscount = self.assetProducer.gCount;//[self.assetProducer.assetsUrlOrdering count];
    AlbumClass *album = [[AlbumClass alloc]init];
       //  NSLog(@"ALLUIR:%@",allPhotoscount);
    album.albumId = _id;
    album.albumName = da.name;
    // XXX fixme
    album.photoCount = allPhotoscount;
    // .....
    
    [self.playlists addObject:album];
     }
    // 2: untag
    
    // 3: from DB
    
    /*for (NSString *_id in self.list) {
        [da getUserFromPlayTable:_id];
        AlbumClass *item = [[AlbumClass alloc]init];
        item.albumId = _id;
        item.albumName = da.name;
        NSLog(@"alubm item %@  %@",item.albumId,item.albumName);
        [self.albumItems addObject:item];
        [item release];
    }*/

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
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select play_id from playIdOrder"];
    self.list=[da selectOrderId:selectPlayIdOrder];
    
}

-(void)Special
{
    NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,@"ALL"];
    NSLog(@"%@",insertPlayTable);
    [da insertToTable:insertPlayTable];
    NSString *insertPlayTable1= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,@"UNTAG"];
    NSLog(@"%@",insertPlayTable1);
    [da insertToTable:insertPlayTable1];
    NSString *insertPlayIdOrder= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,1];
    NSLog(@"%@",insertPlayIdOrder);
    [da insertToTable:insertPlayIdOrder];
    NSString *insertPlayIdOrder1= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,2];
    NSLog(@"%@",insertPlayIdOrder1);
    [da insertToTable:insertPlayIdOrder1];
}

@end
