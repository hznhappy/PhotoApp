//
//  TextController.m
//  PhotoApp
//
//  Created by apple on 11-10-18.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "TextController.h"
#import "UserTableController.h"


@implementation TextController
@synthesize listName,nameIn,nameOut;
@synthesize str1,str2,str3;
-(void)viewDidLoad{
    self.listName.text = str1;
    self.nameIn.text = str2;
    self.nameOut.text =str3;
  }
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[listName resignFirstResponder];
	[nameIn resignFirstResponder];
    [nameOut resignFirstResponder];

	
}

-(IBAction)cance:(id)sender
{	
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)save:(id)sender
{
    da=[[DBOperation alloc]init];
    [da openDB];
    [da createTable3];
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

    NSString *insertUsername = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(Name,With,WithOut) VALUES('%@','%@','%@')",TableName3,listName.text,nameIn.text,nameOut.text];
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
