//
//  PlaylistDetailController.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistDetailController.h"
#import "TextFieldCell.h"
#import "SwitchButtonCell.h"
#import "TextController.h"
#import "User.h"
#import "DBOperation.h"
#import "AnimaSelectController.h"

@implementation PlaylistDetailController
@synthesize listTable;
@synthesize listName;
@synthesize mySwc,a;

- (void)dealloc
{
   //
    [dataBase release];
    [listName release];
     //[listTable release];
    [a release];
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
{ NSLog(@"EE%@",a);
        mySwc = NO;
    dataBase=[[DBOperation alloc]init];
    
    [super viewDidLoad];
}


#pragma mark -
#pragma mark UITableView Delegate method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (mySwc) 
        return 4;
    else
        return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int rowNum=indexPath.row;
    UIViewController *tmpCon=nil;
    UITableViewCell * cell=nil;
    NSString * cellIdentifier=nil;
    NSString *textField= @"textFieldCell";
    NSString *switchField=@"switchFieldCell";
    NSString *transField=@"Transitions";
    NSString *musicField=@"Music";
    switch (rowNum) {
        case 0:
            cellIdentifier = textField;
            TextFieldCell *textCell =(TextFieldCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (textCell == nil) {
                tmpCon=[[UIViewController alloc] initWithNibName:@"TextFieldCell" bundle:nil];
                textCell=(TextFieldCell *) tmpCon.view;
                [tmpCon release];
            }
            textCell.myTextField.text = listName;
            cell=(UITableViewCell *) textCell;
            break;
        case 1:
            cellIdentifier = transField;
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] 
                         initWithStyle:UITableViewCellStyleDefault 
                         reuseIdentifier:cellIdentifier]
                        autorelease];
                
            }
            cell.textLabel.text = @"Transitions";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case 2:
            cellIdentifier = switchField;
            SwitchButtonCell *switchCell =(SwitchButtonCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (switchCell == nil) {
                tmpCon=[[UIViewController alloc] initWithNibName:@"SwitchButtonCell" bundle:nil];
                switchCell=(SwitchButtonCell* )tmpCon.view;
                [tmpCon release];
            }
            switchCell.myLabel.text = @"PlayMusic";
            switchCell.selectionStyle = UITableViewCellEditingStyleNone;
            [switchCell.myCellSwitch addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventTouchUpInside];
            cell=(UITableViewCell *) switchCell;
            break;
        case 3:
            cellIdentifier = musicField;
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] 
                         initWithStyle:UITableViewCellStyleDefault 
                         reuseIdentifier:cellIdentifier]
                        autorelease ];
                
            }
            cell.textLabel.text = @"Music";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell=nil;
            break;
    }
    return cell;  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        AnimaSelectController *animateController = [[AnimaSelectController alloc]init];
        [self.navigationController pushViewController:animateController animated:YES];
        [animateController release];
    }
}
-(void)creatTable
{
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name)",PlayTable];
    [dataBase createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [dataBase createTable:createPlayIdOrder];
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select id from playIdOrder"];
    [dataBase selectOrderId:selectPlayIdOrder];
    
    NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
    [dataBase selectFromPlayTable:selectPlayTable];
    //self.list=da.playIdAry;
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [dataBase createTable:createRules];
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    [dataBase openDB];
    [self creatTable];
    User *user3 = [dataBase getUserFromPlayTable:[a intValue]];
    TextController *ts=[[TextController alloc]init];
    ts.strListName = user3.name;
    NSString *selectRulesIn= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],1];
    [dataBase selectFromRules:selectRulesIn];
    for(int i=0;i<[dataBase.playlist_UserName count];i++)
    {
        if(ts.strNameIn==nil||ts.strNameIn.length==0)
        {
            ts.strNameIn=[dataBase.playlist_UserName objectAtIndex:i];
        }
        else
        {  ts.strNameIn=[ts.strNameIn stringByAppendingString:@","];
            ts.strNameIn=[ts.strNameIn stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:i]];
        }
        
    }
    NSString *selectRulesOut= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],0];
    [dataBase selectFromRules:selectRulesOut];
    for(int j=0;j<[dataBase.playlist_UserName count];j++)
    {
        if(ts.strNameOut==nil||ts.strNameOut.length==0)
        {
            
            ts.strNameOut=[dataBase.playlist_UserName objectAtIndex:j];
        }
        else
        {  ts.strNameOut=[ts.strNameOut stringByAppendingString:@","];
            ts.strNameOut=[ts.strNameOut stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:j]];
        }
    }
    NSString *selectRulesOr= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],2];
    [dataBase selectFromRules:selectRulesOr];
    for(int k=0;k<[dataBase.playlist_UserName count];k++)
    {
        if(ts.strNameOr==nil||ts.strNameOr.length==0)
        {
            
            ts.strNameOr=[dataBase.playlist_UserName objectAtIndex:k];
        }
        else
        {  ts.strNameOr=[ts.strNameOr stringByAppendingString:@","];
            ts.strNameOr=[ts.strNameOr stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:k]];
        }
    }
    [dataBase closeDB];
    [self.navigationController pushViewController:ts animated:YES];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:a,@"playlist_id",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"edit" 
                                                       object:self 
                                                     userInfo:dic1];
}
-(void)updateTable:(id)sender{
    UISwitch *newSwitcn  = (UISwitch *)sender;
    mySwc = newSwitcn.on;
    if (newSwitcn.on) {
        [listTable beginUpdates];
        [listTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [listTable endUpdates];
    }else{
        [listTable beginUpdates];
        [listTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [listTable endUpdates];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    listTable =nil;
    listName = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (UIInterfaceOrientationIsPortrait(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
