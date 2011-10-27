//
//  ResultViewController.m
//  ELCImagePickerDemo
//
//  Created by apple on 11-9-16.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "new.h"
//#import "User1.h"
#import "ResultViewController.h"
@implementation ResultViewController
@synthesize txt1;
@synthesize name;
//@synthesize txt2;
//@synthesize txt3;

-(NSString*)databasePath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *pathname = [path objectAtIndex:0];
	return [pathname stringByAppendingPathComponent:DataFile];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 50.0, 50.0, 20.0)];
	lbl1.text = @"地点:";
	//UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 100.0, 50.0, 20.0)];
	//lbl2.text = @"时间:";
	//UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 150.0, 50.0, 20.0)];
	//lbl3.text = @"性别:";
	
	[self.view addSubview:lbl1];
	//[self.view addSubview:lbl2];
	//[self.view addSubview:lbl3];
	
	txt1 = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 50.0, 180.0, 20.0)];
	txt1.placeholder = @"请在此输入地点";
	txt1.font = [UIFont systemFontOfSize:12.0];
	
	//txt2 = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 100.0, 180.0, 20.0)];
	//txt2.placeholder = @"请在此输入时间";
	//txt2.font = [UIFont systemFontOfSize:12.0];
	
	//txt3 = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 150.0, 180.0, 20.0)];
	//txt3.placeholder = @"请在此输入您的性别";
	//txt3.font = [UIFont systemFontOfSize:12.0];
	
	[self.view addSubview:txt1];
	//[self.view addSubview:txt2];
	//[self.view addSubview:txt3];
	
	UIButton *btn = [UIButton buttonWithType:102];
	btn.frame = CGRectMake(60.0, 180.0, 50.0, 20.0);
	[btn setTitle:@"保存" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
	
	UIButton *btn1 = [UIButton buttonWithType:102];
	btn1.frame = CGRectMake(160.0, 180.0, 50.0, 20.0);
	[btn1 setTitle:@"查看" forState:UIControlStateNormal];
	[btn1 addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn1];
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[txt1 resignFirstResponder];
	//[txt2 resignFirstResponder];
	//[txt3 resignFirstResponder];
}
-(void)loadData
{//[self dismissModalViewControllerAnimated:YES];//
	//[self.navigationController popViewControllerAnimated:YES];	
	new *res = [[new alloc]init];
	[self.navigationController pushViewController:res animated:YES];
}

-(void)save
{
	if ([txt1.text isEqualToString:@""]) {
		return;
	}
	//User1 *new_user = [[User1 alloc] init];
	name = txt1.text;
//	new_user.age = txt2.text;
	//new_user.sex = txt3.text;
	if (sqlite3_open([[self databasePath] UTF8String],&database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0,@"open database faild!");
	}
	
	char *erroMsg;
	NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ROW INTEGER PRIMARY KEY,NAME TEXT)",TableName1];
	if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert1(0,@"create table %@ faild",TableName1);
		NSAssert1(0,@"the error is %s",erroMsg);
	}
	
	NSString *insertUser = [NSString stringWithFormat:@"INSERT INTO %@(NAME) VALUES('%@')",TableName1,name];
	NSLog(@"%@",insertUser);
	if (sqlite3_exec (database, [insertUser UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK)
	{
		NSAssert1(0, @"Error updating tables: %s", erroMsg);
	}
	
	txt1.text = @"";
	//txt2.text = @"";
	//txt3.text = @"";
	
}
- (void)dealloc {
    [super dealloc];
	[txt1 release];
	//[txt2 release];
	//[txt3 release];
}

@end
