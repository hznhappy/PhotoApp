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
    UIButton *btn = [UIButton buttonWithType:102];
	btn.frame = CGRectMake(100.0, 288, 50.0, 20.0);
	[btn setTitle:@"保存" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
	UIButton *btn1 = [UIButton buttonWithType:102];
	btn1.frame = CGRectMake(160.0, 288, 50.0, 20.0);
	[btn1 setTitle:@"查看" forState:UIControlStateNormal];
	[btn1 addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn1];
}
/*
- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
    UILabel *listName = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 50.0, 80.0, 20.0)];
	listName.text = @"ListName:";
    [self.view addSubview:listName];
    UITextField *txtName = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 50.0, 180.0, 20.0)];
	txtName.placeholder = @"请在此输入列表名字";
	txtName.font = [UIFont systemFontOfSize:12.0];
	[self.view addSubview:txtName];

	UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 50.0, 80.0, 20.0)];
	lbl1.text = @"with:";
	[self.view addSubview:lbl1];
    txt1 = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 50.0, 180.0, 20.0)];
	txt1.placeholder = @"请在此输入包含的人";
	txt1.font = [UIFont systemFontOfSize:12.0];
	[self.view addSubview:txt1];
    UILabel *lbl2= [[UILabel alloc] initWithFrame:CGRectMake(50.0, 80.0, 80.0, 20.0)];
	lbl2.text = @"without:";
	[self.view addSubview:lbl2];
    txt2 = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 80.0, 180.0, 20.0)];
	txt2.placeholder = @"请在此输入不包含的人";
	txt2.font = [UIFont systemFontOfSize:12.0];
	[self.view addSubview:txt2];

   
    //[lbl1 release];
    //[lbl2 release];
	
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[listName resignFirstResponder];
	[nameIn resignFirstResponder];
    [nameOut resignFirstResponder];

	
}

-(void)loadData
{	
    UserTableController *us = [[UserTableController alloc]init];
	[self.navigationController pushViewController:us animated:YES];
    [us release];
}
-(void)save
{
    da=[[DBOperation alloc]init];
    [da openDB];
    [da createTable3];
   // UserTableController *parent=(UserTableController *)[(UINavigationController *)[self parentViewController]topViewController];
	//int i;
	//int index=[parent.tableView indexPathForSelectedRow].row;	
	//[parent.list removeObjectAtIndex:index];
	//index+=2;
	//parent.list insertObject:txt1.text atIndex:index];
   /* if(txt1.text==nil)
    {
    }
    if(txt2.text==nil)
    {
        
    }
    else{*/
    NSString *insertUsername = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(Name,With,WithOut) VALUES('%@','%@','%@')",TableName3,listName.text,nameIn.text,nameOut.text];
        NSLog(@"%@",insertUsername);
        [da insertToTable:insertUsername];
        //[parent.tableView reloadData];
   // }
    UserTableController *us = [[UserTableController alloc]init];
    [self.navigationController pushViewController:us animated:YES];
    [us release];
	//[self dismissModalViewControllerAnimated:YES];
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
