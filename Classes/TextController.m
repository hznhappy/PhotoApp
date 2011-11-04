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
@synthesize listName,nameIn,nameOut,nameOr,listUserIdIn,listUserNameIn,listUserNameOut,listUserIdOut,list;
@synthesize str1,str2,str3;
-(void)viewDidLoad{
    //bo=NO;
    e=NO;
    self.listName.text = str1;
    self.nameIn.text = str2;
    self.nameOut.text =str3;
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(text:) name:@"text1" object:nil];
    da=[[DBOperation alloc]init];
    [da openDB];
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [da createTable:createRules];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createPlayTable];
    NSString *createPlayIdTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [da createTable:createPlayIdTable];

    self.listUserIdIn=[NSMutableArray arrayWithCapacity:40];
    self.listUserNameIn=[NSMutableArray arrayWithCapacity:40];
    self.listUserIdOut=[NSMutableArray arrayWithCapacity:40];
    self.listUserNameOut=[NSMutableArray arrayWithCapacity:40];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(edit:) name:@"edit" object:nil];
    //NSLog(@"%@",self.listUserId);
  }
-(void)edit:note
{
    e=YES;
    NSDictionary *dic = [note userInfo];
    NSLog(@"dsa%@",[dic valueForKey:@"playlist_id"]);
    playlist_id=[NSString stringWithFormat:@"%@",[dic valueForKey:@"playlist_id"]];
    NSLog(@"ID %@",playlist_id);
    [playlist_id retain];
    
}
-(void)text
{
   // for(int j=0;j<2;j++)
   // {
   // NSDictionary *dic = [note userInfo];
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
        /* NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_rules,user_id,user_name) VALUES(%d,%d,'%@')",Rules,0,[dic valueForKey:@"playid"],[dic valueForKey:@"name"]];
         NSLog(@"%@",insertRules);
         [da insertToTable:insertRules];*/
        [listUserIdOut addObject:fid];
        [listUserNameOut addObject:readName];
        NSLog(@"OUtID%@",listUserIdOut);
        NSLog(@"OUtNAME%@",listUserNameOut);
        
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
       // [listUserNameIn removeAllObjects];
        //[listUserIdIn removeAllObjects];
        NSLog(@"YYYYY%@",fid);
        [listUserIdIn addObject:fid];
        [listUserNameIn addObject:readName];
        NSLog(@"ID%@",listUserIdIn);
        NSLog(@"NAME%@",listUserNameIn);
      /*  NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_rules,user_id,user_name) VALUES(%d,%d,'%@')",Rules,1,[dic valueForKey:@"playid"],[dic valueForKey:@"name"]];
        NSLog(@"%@",insertRules);
        [da insertToTable:insertRules];*/
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
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];
        NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
        [da selectFromPlayTable:selectPlayTable];
        self.list=da.playIdAry;
     NSLog(@"%@",da.playIdAry);
        NSLog(@"HU%@",[list objectAtIndex:[list count]-1]);
     
     NSString *insertPlayIdTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,[[list objectAtIndex:[list count]-1]intValue]];
     NSLog(@"%@",insertPlayIdTable);
     [da insertToTable:insertPlayIdTable];
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
    
    for(int i=0;i<[listUserIdIn count];i++)
    {
        NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%@',%d,'%@','%@')",Rules,playlist_id,1,
                                [listUserIdIn objectAtIndex:i],[listUserNameIn objectAtIndex:i]];
        NSLog(@"%@",insertRules);
        [da insertToTable:insertRules];  
    }
    for(int i=0;i<[listUserIdOut count];i++)
    {
        NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%@',%d,'%@','%@')",Rules,playlist_id,0,
                                [listUserIdOut objectAtIndex:i],[listUserNameOut objectAtIndex:i]];
        NSLog(@"%@",insertRules);
        [da insertToTable:insertRules];  
    }
    NSArray *withNameList= [nameIn.text componentsSeparatedByString:@","];
    NSArray *withoutNameList= [nameOut.text componentsSeparatedByString:@","];
    NSString *selectRules= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d and playlist_rules=%d",[playlist_id intValue],1];
    [da selectFromRules:selectRules];
    NSLog(@"play%@",da.playlist_UserName);
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
    for(int i=0;i<[da.playlist_UserName count];i++)
    {
        if([withoutNameList containsObject:[da.playlist_UserName objectAtIndex:i]])
        {
            continue;
        }
        else
        {
            NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playlist_id=%d and playlist_rules=%d and user_name='%@'",[playlist_id intValue],0,[da.playlist_UserName objectAtIndex:i]];
            NSLog(@"%@",deleteRules);
            [da deleteDB:deleteRules];
            
        }
    }
}
- (void)dealloc
{ 
    
    [str1 release];
    [str3 release];
    [str2 release];
    [listName dealloc];
    [nameOut release];
    [nameIn release];
    [listUserIdIn release];
    [listUserNameIn release];
    [listUserIdOut release];
    [listUserNameOut release];

    [super dealloc];
}

@end
