//
//  AnimaSelectController.m
//  PhotoApp
//
//  Created by Andy on 11/4/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AnimaSelectController.h"
#import "PlaylistDetailController.h"
#import "DBOperation.h"

@implementation AnimaSelectController
@synthesize animaArray;
@synthesize tranStyle,Trans_list,play_id,Text;

- (void)dealloc
{
    [tranStyle release];
    [animaArray release];
    [database release];
    [Trans_list release];
    [play_id release];
    [Text release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{NSLog(@"YUYUYU%@",play_id);
    NSString *a=NSLocalizedString(@"fade", @"title");
    NSString *b=NSLocalizedString(@"cube", @"title");
    NSString *c=NSLocalizedString(@"reveal", @"title");
    NSString *d=NSLocalizedString(@"push", @"title");
    NSString *e=NSLocalizedString(@"moveIn", @"title");
    NSString *f=NSLocalizedString(@"suckEffect", @"title");
    NSString *g=NSLocalizedString(@"oglFlip", @"title");
    NSString *h=NSLocalizedString(@"rippleEffect", @"title");
    NSString *i=NSLocalizedString(@"pageCurl", @"title");
     NSString *j=NSLocalizedString(@"pageUnCurl", @"title");
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:a,b,c,d,e,f,g,h,i,
                                 j,nil];
    NSMutableArray *tempArray1=[[NSMutableArray alloc]initWithObjects:@"fade",@"cube",@"reveal",@"push",@"moveIn",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",nil];
    self.Trans_list=tempArray1;
    self.animaArray = tempArray;
    [tempArray release];
    [tempArray1 release];
    [self creatTable];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)creatTable;
{
    database=[DBOperation getInstance];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [database createTable:createPlayTable];
}
#pragma mark -
#pragma mark TableView delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [animaArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
    }
    NSString *animateString = [animaArray objectAtIndex:indexPath.row];
    cell.textLabel.text = animateString;
    if ([animateString isEqualToString:self.tranStyle]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"JEE");
    if(play_id!=nil)
    {
        NSString *updatePlayTable= [NSString stringWithFormat:@"UPDATE %@ SET Transtion='%@' WHERE playlist_id=%d",PlayTable,[Trans_list objectAtIndex:indexPath.row],[play_id intValue]];
        NSLog(@"%@",updatePlayTable);
        [database updateTable:updatePlayTable];

    }
    else
    {  
        NSString *selectPlayTable = [NSString stringWithFormat:@"select playlist_id from PlayTable"];
        [database selectFromPlayTable:selectPlayTable];
      //database.playIdAry
        NSLog(@"KU");
        if(Text==nil||Text.length==0)
        {
          int  playID=[[database.playIdAry objectAtIndex:[database.playIdAry count]-1]intValue]+1;
            NSLog(@"HAHA%d",playID);
            NSString *updatePlayTable= [NSString stringWithFormat:@"UPDATE %@ SET Transtion='%@' WHERE playlist_id=%d",PlayTable,[Trans_list objectAtIndex:indexPath.row],playID];
            NSLog(@"%@",updatePlayTable);
            [database updateTable:updatePlayTable];

        }
        else
        {
          int playID=[[database.playIdAry objectAtIndex:[database.playIdAry count]-1]intValue];
             NSLog(@"HeHe%d",playID);
            NSString *updatePlayTable= [NSString stringWithFormat:@"UPDATE %@ SET Transtion='%@' WHERE playlist_id=%d",PlayTable,[Trans_list objectAtIndex:indexPath.row],playID];
            NSLog(@"%@",updatePlayTable);
            [database updateTable:updatePlayTable];

        }

    }
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:cell.textLabel.text forKey:@"tranStyle"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTransitionLabel" object:nil userInfo:dictionary];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    tranStyle = nil;
    animaArray = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
