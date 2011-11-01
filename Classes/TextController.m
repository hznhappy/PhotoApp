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
@synthesize listName,nameIn,nameOut;
@synthesize str1,str2,str3;
-(void)viewDidLoad{
    bo=NO;
    self.listName.text = str1;
    self.nameIn.text = str2;
    self.nameOut.text =str3;
  //  self.list=[NSMutableArray arrayWithCapacity:100];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(text:) name:@"text1" object:nil];
  }
-(void)text:note
{
   // for(int j=0;j<2;j++)
   // {
    NSDictionary *dic = [note userInfo];
    if(bo==NO)
    {
        if(nameIn.text==nil||nameIn.text.length==0)
        {
            
    self.nameIn.text=[dic valueForKey:@"name"];
        }
        else
        {  self.nameIn.text=[self.nameIn.text stringByAppendingString:@","];
            self.nameIn.text=[self.nameIn.text stringByAppendingString:[dic valueForKey:@"name"]];
        }
    
    }
    if(bo==YES)
    {
        if(nameOut.text==nil||nameOut.text.length==0)
        {
            
            self.nameOut.text=[dic valueForKey:@"name"];
        }
        else
        {  self.nameOut.text=[self.nameOut.text stringByAppendingString:@","];
            self.nameOut.text=[self.nameOut.text stringByAppendingString:[dic valueForKey:@"name"]];
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
    NSString *readName=(NSString *)ABRecordCopyCompositeName(person);
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:readName,@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"text1" 
                                                       object:self 
                                                     userInfo:dic1];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
	
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return 0;
}

-(IBAction)addWith:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release]; 
    
}
-(IBAction)addWithout:(id)sender
{bo=YES;
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
    NSString *createSQL3= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [da createTable:createSQL3];
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
    NSString *insertUsername = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,listName.text];
    NSLog(@"%@",insertUsername);
    [da insertToTable:insertUsername];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];
    [self.navigationController popViewControllerAnimated:YES];
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
    [super dealloc];
}

@end
