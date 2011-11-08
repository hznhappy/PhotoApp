//
//  TextController.m
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "TextController.h"
#import "UserTableController.h"
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"
@implementation TextController
@synthesize listName,nameIn,nameOut,nameOr,listUserIdIn,listUserNameIn,listUserNameOut,listUserIdOut,listUserIdOr,listUserNameOr,list;
@synthesize strListName,strNameIn,strNameOut,strNameOr;
-(void)viewDidLoad{
    //bo=NO;
    e=NO;
    self.listName.text = strListName;
    self.nameIn.text = strNameIn;
    self.nameOut.text =strNameOut;
    self.nameOr.text =strNameOr;
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(text:) name:@"text1" object:nil];
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [da createTable:createRules];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [da createTable:createPlayIdOrder];

    self.listUserIdIn=[NSMutableArray arrayWithCapacity:40];
    self.listUserNameIn=[NSMutableArray arrayWithCapacity:40];
    self.listUserIdOut=[NSMutableArray arrayWithCapacity:40];
    self.listUserNameOut=[NSMutableArray arrayWithCapacity:40];
    self.listUserIdOr=[NSMutableArray arrayWithCapacity:40];
    self.listUserNameOr=[NSMutableArray arrayWithCapacity:40];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(edit:) name:@"edit" object:nil];
  }
-(void)edit:note
{
    e=YES;
    NSDictionary *dic = [note userInfo];
    playlist_id=[NSString stringWithFormat:@"%@",[dic valueForKey:@"playlist_id"]];
    [playlist_id retain];
    
}
-(void)text
{
    if(bo==0)
    {
        if(nameOut.text==nil||nameOut.text.length==0)
        {
            
            self.nameOut.text=readName;
        }
        else
        {  self.nameOut.text=[self.nameOut.text stringByAppendingString:@","];
            self.nameOut.text=[self.nameOut.text stringByAppendingString:readName];
        }
        [listUserIdOut addObject:fid];
        [listUserNameOut addObject:readName];
      
        
    }

    if(bo==1)
    {
        if(nameIn.text==nil||nameIn.text.length==0)
        {
            
    self.nameIn.text=readName;
        }
        else
        {  self.nameIn.text=[self.nameIn.text stringByAppendingString:@","];
            self.nameIn.text=[self.nameIn.text stringByAppendingString:readName];
        }
        [listUserIdIn addObject:fid];
        [listUserNameIn addObject:readName];
        }
    if(bo==2)
    {
        if(nameOr.text==nil||nameOr.text.length==0)
        {
            
            self.nameOr.text=readName;
        }
        else
        {  self.nameOr.text=[self.nameOr.text stringByAppendingString:@","];
            self.nameOr.text=[self.nameOr.text stringByAppendingString:readName];
        }
        [listUserIdOr addObject:fid];
        [listUserNameOr addObject:readName];
           }

        
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[listName resignFirstResponder];
	[nameIn resignFirstResponder];
    [nameOut resignFirstResponder];

	
}
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[self dismissModalViewControllerAnimated:YES];
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
    da=[[DBOperation alloc]init];
    [da openDB];
    readName=(NSString *)ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
   fid=[NSString stringWithFormat:@"%d",recId];
    [self text];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
	
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return 0;
}

-(IBAction)addWith:(id)sender
{bo=1;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release]; 
    
}
-(IBAction)addWithout:(id)sender
{bo=0;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release]; 
    
}
-(IBAction)addNameOr:(id)sender
{bo=2;
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}
-(IBAction)cance:(id)sender
{	
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)save:(id)sender
{
    da=[[DBOperation alloc]init];
    [da openDB];
    if(listName.text==nil)
    {
        
        NSString *message=[[NSString alloc] initWithFormat:
                           @"规则名不能为空!"];
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:message
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"确定!",nil];
        [alert show];
        [alert release];
        [message release];
        
    }
else
{
    if(e==YES)
    {
        
        [self EDIT];         
    } 
 else{
          NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,listName.text];
    NSLog(@"%@",insertPlayTable);
    [da insertToTable:insertPlayTable];
   
        NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
        [da selectFromPlayTable:selectPlayTable];
        self.list=da.playIdAry;
    NSString *insertPlayIdOrder= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,[[list objectAtIndex:[list count]-1]intValue]];
     NSLog(@"%@",insertPlayIdOrder);
     [da insertToTable:insertPlayIdOrder];
        
     NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                        object:self 
                                                      userInfo:dic1];
     for(int i=0;i<[listUserIdIn count];i++)
     {
         NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%@',%d,'%@','%@')",Rules,[list objectAtIndex:[list count]-1],1,
                                 [listUserIdIn objectAtIndex:i],[listUserNameIn objectAtIndex:i]];
         NSLog(@"%@",insertRules);
         [da insertToTable:insertRules];  
     }
     for(int i=0;i<[listUserIdOut count];i++)
     {
         NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%@',%d,'%@','%@')",Rules,[list objectAtIndex:[list count]-1],0,
                                 [listUserIdOut objectAtIndex:i],[listUserNameOut objectAtIndex:i]];
         NSLog(@"%@",insertRules);
         [da insertToTable:insertRules];  
     }
     for(int i=0;i<[listUserIdOr count];i++)
     {
         NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%@',%d,'%@','%@')",Rules,[list objectAtIndex:[list count]-1],2,
                                 [listUserIdOr objectAtIndex:i],[listUserNameOr objectAtIndex:i]];
         NSLog(@"%@",insertRules);
         [da insertToTable:insertRules];  
     }
     
 }
    

    
}
   [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)EDIT
{
    NSString *updateRules= [NSString stringWithFormat:@"UPDATE %@ SET playlist_name='%@' WHERE playlist_id=%d",PlayTable,listName.text,[playlist_id intValue]];
	NSLog(@"%@",updateRules);
	[da updateTable:updateRules];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];
    [self insert];    
       
    

    [self deletes];
    }
-(void)insert
{
    for(int i=0;i<[listUserIdIn count];i++)
    {
        NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%d',%d,'%@','%@')",Rules,[playlist_id intValue],1,
                                [listUserIdIn objectAtIndex:i],[listUserNameIn objectAtIndex:i]];
        NSLog(@"%@",insertRules);
        [da insertToTable:insertRules];  
    }
    for(int i=0;i<[listUserIdOut count];i++)
    {
        NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%d',%d,'%@','%@')",Rules,[playlist_id intValue],0,
                                [listUserIdOut objectAtIndex:i],[listUserNameOut objectAtIndex:i]];
        NSLog(@"%@",insertRules);
        [da insertToTable:insertRules];  
    }
    for(int i=0;i<[listUserIdOr count];i++)
    {
        NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%d',%d,'%@','%@')",Rules,[playlist_id intValue],2,
                                [listUserIdOr objectAtIndex:i],[listUserNameOr objectAtIndex:i]];
        NSLog(@"%@",insertRules);
        [da insertToTable:insertRules];  
    }
}

-(void)deletes
{
    NSArray *withNameList= [nameIn.text componentsSeparatedByString:@","];
    NSArray *withoutNameList= [nameOut.text componentsSeparatedByString:@","];
    NSArray *withOrNameList= [nameOr.text componentsSeparatedByString:@","];
    NSString *selectRules= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",[playlist_id intValue],1];
    [da selectFromRules:selectRules];
    for(int i=0;i<[da.playlist_UserName count];i++)
    {
        if([withNameList containsObject:[da.playlist_UserName objectAtIndex:i]])
        {
            continue;
        }
        else
        {
            NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playlist_id=%d and playlist_rules=%d and user_name='%@'",[playlist_id intValue],1,[da.playlist_UserName objectAtIndex:i]];
            NSLog(@"%@",deleteRules);
            [da deleteDB:deleteRules];
            
        }
    }
    NSString *selectRules1= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",[playlist_id intValue],0];
    [da selectFromRules:selectRules1];
    NSLog(@"play%@",da.playlist_UserName);
    for(int j=0;j<[da.playlist_UserName count];j++)
    {
        if([withoutNameList containsObject:[da.playlist_UserName objectAtIndex:j]])
        {
            continue;
        }
        else
        {
            NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playlist_id=%d and playlist_rules=%d and user_name='%@'",[playlist_id intValue],0,[da.playlist_UserName objectAtIndex:j]];
            NSLog(@"%@",deleteRules);
            [da deleteDB:deleteRules];
            
            
        }
    }
    NSString *selectRules2= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",[playlist_id intValue],2];
    [da selectFromRules:selectRules2];
    for(int k=0;k<[da.playlist_UserName count];k++)
    {
        if([withOrNameList containsObject:[da.playlist_UserName objectAtIndex:k]])
        {
            continue;
        }
        else
        {
            NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playlist_id=%d and playlist_rules=%d and user_name='%@'",[playlist_id intValue],2,[da.playlist_UserName objectAtIndex:k]];
            NSLog(@"%@",deleteRules);
            [da deleteDB:deleteRules];
            
        }
    }

   }
- (void)dealloc
{ 
    
    [strListName release];
    [strNameIn release];
    [strNameOr release];
    [strNameOut release];
    [list release];
    [listName release];
    [nameOut release];
    [nameIn release];
    [listUserIdIn release];
    [listUserNameIn release];
    [listUserIdOut release];
    [listUserIdIn release];
    [listUserNameIn release];
    [listUserIdOut release];
    [super dealloc];
}

@end
