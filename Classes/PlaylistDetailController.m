//
//  PlaylistDetailController.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistDetailController.h"
#import "User.h"
#import "DBOperation.h"
#import "AnimaSelectController.h"

@implementation PlaylistDetailController
@synthesize listTable;
@synthesize textFieldCell,switchCell,tranCell,musicCell;
@synthesize tranLabel,musicLabel,state,stateButton;
@synthesize textField;
@synthesize mySwitch;
@synthesize listName;
@synthesize userNames;
@synthesize selectedIndexPaths;
@synthesize mySwc,a,playrules_idList,playrules_nameList,playrules_ruleList,playIdList,orderList;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [selectedIndexPaths release];
    [musicLabel release];
    [tranLabel release];
    [mySwitch release];
    [textField release];
    [textFieldCell release];
    [switchCell release];
    [tranCell release];
    [musicCell release];
    [listTable release];
    [dataBase release];
    [listName release];
    [userNames release];
    [state release];
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
{ 
    
    mySwc = YES;
    selectImg = [UIImage imageNamed:@"Selected.png"];
    unselectImg = [UIImage imageNamed:@"Unselected.png"];
    dataBase=[[DBOperation alloc]init];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSMutableArray *playArray = [[NSMutableArray alloc]init];
    NSMutableArray *IdOrderArray = [[NSMutableArray alloc]init];
     NSMutableArray *IdArray = [[NSMutableArray alloc]init];
    NSMutableArray *temArray = [[NSMutableArray alloc]init];
    self.selectedIndexPaths = temArray;
    self.userNames = tempArray;
   // self.playIdList = playArray;
    //self.orderList =IdOrderArray;
    //self.playrules_idList =IdArray;
    [IdOrderArray release];
    [IdArray release];
    [tempArray release];
    [temArray release];
    [playArray release];
    [dataBase openDB];
    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    [dataBase selectOrderId:selectIdOrder];
    self.orderList=dataBase.orderIdList;
    NSLog(@"QQ%@",dataBase.orderList);//dataBase.orderIdlist count is 0;
    for (id object in orderList) {
        User *userName = [dataBase getUserFromUserTable:[object intValue]];
        [userNames addObject:userName.name];
    }
    [self creatTable];
    [dataBase closeDB];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTransitionAccessoryLabel:) name:@"changeTransitionLabel" object:nil];
    [super viewDidLoad];
}


#pragma mark -
#pragma mark UITableView  method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if (mySwc) {
                return 4;
            }
            else{
                return 3;
            }
            break;
        case 1:
            return [userNames count];
            break;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int rowNum=indexPath.row;
    if (indexPath.section == 0) {
        UITableViewCell *cell = nil;
        switch (rowNum) {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
                if (cell == nil) {
                    cell = self.textFieldCell;
                }
                self.textField.text = listName;
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"transitionsCell"];
                if (cell == nil) {
                    cell = self.tranCell;
                }
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"playMusicCell"];
                if (cell == nil) {
                    cell = self.switchCell;
                }
                break;
            case 3:
                cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell"];
                if (cell == nil) {
                    cell = self.musicCell;
                }
                break;
            default:
                cell = nil;
                break;
        }
        return cell;
    }else {
        static NSString *cellIdentifier = @"nameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
           
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(45, 11, 126, 20)];
            name.tag = indexPath.row;
            name.text = [userNames objectAtIndex:indexPath.row];
            [cell.contentView addSubview:name];
            [name release];

            UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            selectButton.tag = indexPath.row;
            [selectButton addTarget:self action:@selector(setSelectState:) forControlEvents:UIControlEventTouchUpInside];
            selectButton.frame = CGRectMake(10, 11, 30, 30);
            [selectButton setImage:unselectImg forState:UIControlStateNormal];
            if([playrules_idList containsObject:[orderList objectAtIndex:indexPath.row]])
            {[dataBase openDB];
                NSString *selectRules= [NSString stringWithFormat:@"select user_id,user_name,playlist_rules from rules where user_id=%d and playlist_id=%d",[[orderList objectAtIndex:indexPath.row]intValue],[a intValue]];
                [dataBase selectFromRules:selectRules];
                NSLog(@"F");
                 cell.accessoryView = [self getStateButton];
                [selectButton setImage:selectImg forState:UIControlStateNormal];
                for(NSString * rule in dataBase.playlist_UserRules)
                {NSLog(@"ew%d",[rule intValue]);
                    if([rule intValue]==1)
                    {
                        NSLog(@"1111");
                        [stateButton setTitle:MUST forState:UIControlStateNormal];
                        stateButton.backgroundColor = [UIColor greenColor];
                    }
                    else if([rule intValue]==0)
                    {
                          NSLog(@"000");
                        stateButton.backgroundColor = [UIColor redColor];
                        [stateButton setTitle:EXCLUDE forState:UIControlStateNormal];
                    }
                    else if([rule intValue]==2)
                    {  NSLog(@"2222");
                       stateButton.backgroundColor = [UIColor cyanColor];
                        [stateButton setTitle:OPTIONAL forState:UIControlStateNormal];
                    }
                }
               

                [dataBase closeDB];
            }

            [cell.contentView addSubview:selectButton];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 && indexPath.row == 1) {
        AnimaSelectController *animateController = [[AnimaSelectController alloc]init];
        animateController.tranStyle = self.tranLabel.text;
        [self.navigationController pushViewController:animateController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [animateController release];
    }
    if (indexPath.section ==0 && indexPath.row == 3) {
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
        
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = YES;
        mediaPicker.prompt = @"Select songs";
        
        [self.navigationController pushViewController:mediaPicker animated:YES];
        [mediaPicker release];    
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *button = [self getStateButton];
        if (cell.accessoryView==nil) {
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
          NSInteger Row=indexPath.row;
        for (UIButton *button in cell.contentView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) {
                if ([button.currentImage isEqual:unselectImg]) {
                    [button setImage:selectImg forState:UIControlStateNormal];
                    [selectedIndexPaths addObject:indexPath];
                [button setImage:selectImg forState:UIControlStateNormal];
                  
                    [self insert:Row];
                   // NSLog(@"")
                }else{
                    [self deletes:Row];
                    [button setImage:unselectImg forState:UIControlStateNormal];
                    [selectedIndexPaths removeObject:indexPath];
                }
            }
        }
    }
    [self.textField resignFirstResponder];
}

#pragma mark -
#pragma mark media picker delegate method
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
        self.musicLabel.text = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    }
    [self dismissModalViewControllerAnimated: YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
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
     self.playIdList=dataBase.playIdAry;
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [dataBase createTable:createRules];
    NSString *selectRules= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d",[a intValue]];
    [dataBase selectFromRules:selectRules];
    self.playrules_idList=dataBase.playlist_UserId;
    NSLog(@"YYYY%@",playrules_idList);

}
-(void)insert:(NSInteger)Row
{
    [dataBase openDB];
    NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%d','%d','%@','%@')",Rules,[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1,1,
                            [orderList objectAtIndex:Row],[userNames objectAtIndex:Row]];
    NSLog(@"%@",insertRules);
    [dataBase insertToTable:insertRules];  
    [dataBase closeDB];

}
-(void)deletes:(NSInteger)Row
{[dataBase openDB];
    NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playlist_id=%d and user_id='%@'",[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1,[orderList objectAtIndex:Row]];
    NSLog(@"%@",deleteRules);
    [dataBase deleteDB:deleteRules];
    [dataBase closeDB];
}
-(void)update:(NSInteger)Row rule:(int)rule
{[dataBase openDB];
    NSString *updateRules= [NSString stringWithFormat:@"UPDATE %@ SET playList_rules=%d WHERE playlist_id=%d and user_id='%@'",Rules,rule,[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1,[orderList objectAtIndex:Row]];
	NSLog(@"%@",updateRules);
	[dataBase updateTable:updateRules];
    [dataBase closeDB];
}
-(IBAction)save
{
    dataBase=[[DBOperation alloc]init];
    [dataBase openDB];
    if(textField.text==nil)
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
    NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(playList_name) VALUES('%@')",PlayTable,textField.text];
    NSLog(@"%@",insertPlayTable);
    [dataBase insertToTable:insertPlayTable];

    NSString *selectPlayTable = [NSString stringWithFormat:@"select * from PlayTable"];
    [dataBase selectFromPlayTable:selectPlayTable];
    //NSMutableArray *playIdList;
    playIdList=dataBase.playIdAry;
    NSString *insertPlayIdOrder= [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@(play_id) VALUES(%d)",playIdOrder,[[playIdList objectAtIndex:[playIdList count]-1]intValue]];
    NSLog(@"%@",insertPlayIdOrder);
    [dataBase insertToTable:insertPlayIdOrder];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];

    NSLog(@"D");
    
}
#pragma mark -
#pragma mark Coustom method
-(UIButton *)getStateButton{
   stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(0, 0, 75, 28);
    [stateButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [stateButton setTitle:MUST forState:UIControlStateNormal];
    stateButton.backgroundColor = [UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
    [stateButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    return stateButton;
}
-(void)changeState:(id)sender{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath *index = [listTable indexPathForCell:cell];
    NSInteger Row=index.row;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    if ([button.titleLabel.text isEqualToString:MUST]) {
        button.backgroundColor = [UIColor colorWithRed:44/255.0 green:100/255.0 blue:196/255.0 alpha:1.0];
        [button setTitle:EXCLUDE forState:UIControlStateNormal];
        [self update:Row rule:0];
    }else if([button.titleLabel.text isEqualToString:EXCLUDE]){
        button.backgroundColor = [UIColor colorWithRed:81/255.0 green:142/255.0 blue:72/255.0 alpha:1.0];
        [button setTitle:OPTIONAL forState:UIControlStateNormal];
        [self update:Row rule:2];
    }else{
        button.backgroundColor = [UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
        [button setTitle:MUST forState:UIControlStateNormal];
        [self update:Row rule:1];
    }
}
-(void)setSelectState:(id)sender{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath *index = [listTable indexPathForCell:cell];
     NSInteger Row=index.row;
    if ([button.currentImage isEqual:selectImg]) {
        [self deletes:Row];
        [button setImage:unselectImg forState:UIControlStateNormal];
        NSIndexPath *index = [listTable indexPathForCell:cell];
        [selectedIndexPaths removeObject:index];
        cell.accessoryView = nil;
    }else{
        [self insert:Row];
        [button setImage:selectImg forState:UIControlStateNormal];
        NSIndexPath *index = [listTable indexPathForCell:cell];
        [selectedIndexPaths addObject:index];
        cell.accessoryView = [self getStateButton];
    }
    
}
#pragma mark -
#pragma mark IBAction method
-(IBAction)hideKeyBoard:(id)sender{
    [sender resignFirstResponder];
}


-(IBAction)updateTable:(id)sender{
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

-(IBAction)resetAll{
    for (NSIndexPath *path in selectedIndexPaths) {
        if (path.section == 1) {
            UITableViewCell *cell = [listTable cellForRowAtIndexPath:path];
            cell.accessoryView = nil;
            for (UIButton *button in cell.contentView.subviews) {
                if ([button isKindOfClass:[UIButton class]]) {
                    if ([button.currentImage isEqual:selectImg]) {
                        [button setImage:unselectImg forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
    [selectedIndexPaths removeAllObjects];
}

#pragma mark -
#pragma mark Notification method
-(void)changeTransitionAccessoryLabel:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    NSString *labelText = [dic objectForKey:@"tranStyle"];
    self.tranLabel.text = labelText;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textField resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    selectedIndexPaths = nil;
    textFieldCell = nil;
    textField = nil;
    tranCell = nil;
    tranLabel = nil;
    switchCell = nil;
    mySwitch = nil;
    musicCell = nil;
    musicLabel = nil;
    a = nil;
    dataBase = nil;
    listTable =nil;
    listName = nil;
    userNames = nil;
    state = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
