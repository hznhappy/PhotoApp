//
//  ContactsController.m
//  PhotoApp
//
//  Created by apple on 11-11-8.
//  Copyright 2011年 chinarewards. All rights reserved.
//

#import "ContactsController.h"
@implementation ContactsController
@synthesize ContractTable,list; 
@synthesize names;  
@synthesize keys;  

- (void)viewDidLoad {  
  //  NSString *path=[[NSBundle mainBundle] pathForResource:@"sortednames"   
                              //                     ofType:@"plist"]; //获取属性列表的路径，赋给path   
   list=[[NSMutableArray alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];//WithContentsOfFile:list];  //将 路径path下的数据表 初始化字典dict  
    self.names = dict; //字典dict 赋给names  
    NSArray * a=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F" nil]
    [dict release];  
        ABAddressBookRef addressBook =ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople (addressBook);
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBook);
    for (id person in (NSArray *) allPeople)
        [self logContact:person];
    for (id group in (NSArray *) allGroups)
        [self logGroups:group];
    CFRelease(allGroups);
    CFRelease(allPeople);
    CFRelease(addressBook);
    
       NSLog(@"llll%d",[list count]);
    NSLog(@"www%d",[names count]);
    //names=[NSDictionary dictionaryWithObjectsAndKeys:list,1,nil];
    NSArray *array=[[names allKeys] sortedArrayUsingSelector:  
                    @selector(compare:)]; //给所有 keys 值按字母顺序排序  
        NSLog(@"DDDDDDD%@",array);
    self.keys = array; //将 array对象赋给 keys  
    NSLog(@"fffff%@",keys);
    
}  
-(void)logContact:(id)person
{
    CFStringRef name = ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
    NSLog(@"Person Name: %@ RecordID:%d",name, recId);
    NSString *newname=[NSString stringWithFormat:@"%@",name];
    // NSString *newid=[NSString stringWithFormat:@"%d",recId];
    [list addObject:newname];
   // [self.names setObject:newid forKey:newname];
   // NSLog(@"%@",names);
   // [self.names forKey:newname];
   // NSLog(@"EWEW%@",list);
}
-(void)logGroups:(id)group
{
    CFStringRef name = ABRecordCopyValue(group,kABGroupNameProperty);
    ABRecordID recId = ABRecordGetRecordID(group);
    NSLog(@"Group Name: %@ RecordID:%d",name, recId);
}

- (void)didReceiveMemoryWarning {  
    // Releases the view if it doesn't have a superview.  
    [super didReceiveMemoryWarning];  
    // Release any cached data, images, etc that aren't in use.  
}  
- (void)viewDidUnload {  
    // Release any retained subviews of the main view.  
    // e.g. self.myOutlet = nil;  
    self.names = nil;  
    self.keys = nil;  
}  

- (void)dealloc {  
    [names release];  
    [keys release];  
    [super dealloc];  
}  

#pragma mark -  
#pragma mark Table View Data Source Methods   
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  
{  
    return [keys count];  
}  
//返回 每个分区 有多少行  
- (NSInteger)tableView:(UITableView *)tableView   
 numberOfRowsInSection:(NSInteger)section  
{  
    NSString *key = [keys objectAtIndex:section]; //section为其中一个分区，获取section的索引  
    NSArray *nameSection = [names objectForKey:key];
    NSLog(@"%d",[nameSection count]);//根据索引获取分区里面的所有数据  
    return [nameSection count];     //返回分区里的行的数量  
}  

//返回 当前需要显示的cell， 可能是 为了节省内存  
- (UITableViewCell *)tableView:(UITableView *)tableView   
         cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    //NSLog(@"tianshi\n");  
    NSUInteger section = [indexPath section];//返回第几分区  
    NSUInteger row = [indexPath row];//获取第几分区的第几行  
    NSString *key = [keys objectAtIndex:section]; //返回 分区的索引key  
    NSArray *nameSection = [names objectForKey:key];//返回 根据key获得：当前分区的所有内容，  
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";  
    //判断cell是否存在，如果没有，则新建一个  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:  
                             SectionsTableIdentifier ];  
    if (cell == nil) {  
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   
                                       reuseIdentifier: SectionsTableIdentifier ] autorelease];  
    }  
    //给cell赋值  
    cell.textLabel.text = [nameSection objectAtIndex:row];  
    return cell;  
}  

//为每一个分区指定一个名称，现在的名称为key的值  
- (NSString *)tableView:(UITableView *)tableView   
titleForHeaderInSection:(NSInteger)section  
{  
    NSString *key = [keys objectAtIndex:section];  
    return key;  
}  
//添加索引的值，为右侧的A----E  
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
{  
    return keys;  
} 
/*-(void)viewDidLoad
{    NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:@"redColor",@"yellowColor",@"greenColor",@"grayColor",@"whiteColor",@"blueColor",nil];
       list=[[NSMutableArray alloc]init];
    NSDictionary *dict=[[NSDictionary alloc]   
                        init];  
    self.names = dict;
    ABAddressBookRef addressBook =ABAddressBookCreate();
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople (addressBook);
        CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBook);
        for (id person in (NSArray *) allPeople)
            [self logContact:person];
        for (id group in (NSArray *) allGroups)
            [self logGroups:group];
        CFRelease(allGroups);
        CFRelease(allPeople);
        CFRelease(addressBook);
        
    
    
    //self.list=arr;
    [arr release];
     [super viewDidLoad];
   	
}
-(void)logContact:(id)person
{
    CFStringRef name = ABRecordCopyCompositeName(person);
    ABRecordID recId = ABRecordGetRecordID(person);
    NSLog(@"Person Name: %@ RecordID:%d",name, recId);
    NSString *newname=[NSString stringWithFormat:@"%@",name];
    [list addObject:newname];
       NSLog(@"EWEW%@",list);
}
-(void)logGroups:(id)group
{
    CFStringRef name = ABRecordCopyValue(group,kABGroupNameProperty);
    ABRecordID recId = ABRecordGetRecordID(group);
    NSLog(@"Group Name: %@ RecordID:%d",name, recId);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return[list count];
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
		
	}
   
	cell.textLabel.text = [list objectAtIndex:indexPath.row];
    return cell;
}


- (void)dealloc
{
    [super dealloc];
}*/
/*- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return 0;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[self dismissModalViewControllerAnimated:YES];
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
}*/
@end
