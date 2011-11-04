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

@implementation PlaylistDetailController
@synthesize listTable;
@synthesize listName;
@synthesize mySwc;

- (void)dealloc
{
    [listTable release];
    [dataBase release];
    [listName release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    dataBase = [[DBOperation alloc]init];
    mySwc = NO;
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
                NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:@"TextFieldCell" owner:self options:nil];
                for (id currentObject in cellArray) {
                    if([currentObject isKindOfClass:[UITableViewCell class]]){
                        textCell = (TextFieldCell *)currentObject;
                        break;
                    }
                }
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
            
            break;
        case 2:
            cellIdentifier = switchField;
            SwitchButtonCell *switchCell =(SwitchButtonCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (switchCell == nil) {
                NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:@"SwitchButtonCell" owner:self options:nil];
                for (id currentObject in cellArray) {
                    if([currentObject isKindOfClass:[UITableViewCell class]]){
                        switchCell = (SwitchButtonCell *)currentObject;
                        break;
                    }
                }
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
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    [dataBase openDB];
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select id from playIdTable"];
    [dataBase selectOrderId:selectPlayIdOrder];
    User *user3 = [dataBase getUserFromPlayTable:[[dataBase.playIdAry objectAtIndex:indexPath.row]intValue]];


    TextController *ts=[[TextController alloc]init];
    ts.str1 = user3.name;
    NSString *selectRulesIn= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[[dataBase.playIdAry objectAtIndex:indexPath.row]intValue],1];
    [dataBase selectFromRules:selectRulesIn];
    for(int i=0;i<[dataBase.playlist_UserName count];i++)
    {
        if(ts.str2==nil||ts.str2.length==0)
        {
            
            ts.str2=[dataBase.playlist_UserName objectAtIndex:i];
        }
        else
        {  ts.str2=[ts.str2 stringByAppendingString:@","];
            ts.str2=[ts.str2 stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:i]];
        }
        
    }
    NSString *selectRulesOut= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[[dataBase.playIdAry objectAtIndex:indexPath.row]intValue],0];
    [dataBase selectFromRules:selectRulesOut];
    for(int j=0;j<[dataBase.playlist_UserName count];j++)
    {
        if(ts.str3==nil||ts.str3.length==0)
        {
            
            ts.str3=[dataBase.playlist_UserName objectAtIndex:j];
        }
        else
        {  ts.str3=[ts.str3 stringByAppendingString:@","];
            ts.str3=[ts.str3 stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:j]];
        }
    }
    [dataBase closeDB];
    [self.navigationController pushViewController:ts animated:YES];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[dataBase.playIdAry objectAtIndex:indexPath.row],@"playlist_id",nil];
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
