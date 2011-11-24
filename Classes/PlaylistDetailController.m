//
//  PlaylistDetailController.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistDetailController.h"
#import "DBOperation.h"
#import "AnimaSelectController.h"

@implementation PlaylistDetailController
@synthesize listTable;
@synthesize textFieldCell,switchCell,tranCell,musicCell;
@synthesize tranLabel,musicLabel,state,stateButton;
@synthesize textField;
@synthesize mySwitch;
@synthesize listName,photos;
@synthesize userNames;
@synthesize selectedIndexPaths,Transtion;
@synthesize mySwc,a,playrules_idList,playIdList,orderList;

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
    //[dataBase release];
    [listName release];
    [userNames release];
    [state release];
    [a release];
    [photos release];
    [playrules_idList release];
    [playIdList release];
    [orderList release];
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
{ if(Transtion!=nil)
  {
      self.tranLabel.text=Transtion;
  }
    NSString *b=NSLocalizedString(@"Back", @"title");
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(huyou) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:b forState:UIControlStateNormal];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =backItem;
    [backItem release];

    key=0;
    mySwc = NO;
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
    self.textField.delegate=self;
    [IdOrderArray release];
    [IdArray release];
    [tempArray release];
    [temArray release];
    [playArray release];
    [self creatTable];

    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    [dataBase selectOrderId:selectIdOrder];
    self.orderList=dataBase.orderIdList;
    for (id object in orderList) {
        [dataBase getUserFromUserTable:[object intValue]];
        [self.userNames addObject:dataBase.name];
    }
    //[dataBase selectFromUserTable];
    //self.userNames=dataBase.UserTablename;
    
        NSString *selectTagName= @"SELECT DISTINCT NAME FROM TAG";
    [dataBase selectUserNameFromTag:selectTagName];
   // self.photos = [dataBase selectPhotos:selectSql];
    NSLog(@"tagname:%@",dataBase.tagName);
 

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTransitionAccessoryLabel:) name:@"changeTransitionLabel" object:nil];
    [super viewDidLoad];
}
-(void)huyou
{
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];
    

    [self.navigationController popViewControllerAnimated:YES]; 
}
#pragma mark -
#pragma mark UITableView  method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(void)international
{
    
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
                if(a!=nil)
                {
                    if(key==0)
                    {
                self.textField.text = listName;
                    }
                }
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
            {
                NSString *selectRules= [NSString stringWithFormat:@"select user_id,user_name,playlist_rules from rules where user_id=%d and playlist_id=%d",[[orderList objectAtIndex:indexPath.row]intValue],[a intValue]];
                [dataBase selectFromRules:selectRules];
                 cell.accessoryView = [self getStateButton];
                [selectedIndexPaths addObject:indexPath];
                [selectButton setImage:selectImg forState:UIControlStateNormal];
                for(NSString * rule in dataBase.playlist_UserRules)
                {NSLog(@"ew%d",[rule intValue]);
                    if([rule intValue]==1)
                    {
                        [stateButton setTitle:MUST forState:UIControlStateNormal];
                       stateButton.backgroundColor = [UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
                    }
                    else if([rule intValue]==0)
                    {
                        stateButton.backgroundColor = [UIColor colorWithRed:44/255.0 green:100/255.0 blue:196/255.0 alpha:1.0];
                        [stateButton setTitle:EXCLUDE forState:UIControlStateNormal];
                    }
                    else if([rule intValue]==2)
                    {  
                       stateButton.backgroundColor =  [UIColor colorWithRed:81/255.0 green:142/255.0 blue:72/255.0 alpha:1.0];
                        [stateButton setTitle:OPTIONAL forState:UIControlStateNormal];
                    }
                }
               

            }

            [cell.contentView addSubview:selectButton];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textField resignFirstResponder];
    if (indexPath.section ==0 && indexPath.row == 1) {
        AnimaSelectController *animateController = [[AnimaSelectController alloc]init];
        animateController.tranStyle = self.tranLabel.text;
        animateController.play_id=a;
        animateController.Text=textField.text;
        NSLog(@"anima%@",animateController.play_id);
        [self.navigationController pushViewController:animateController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [animateController release];
    }
    if (indexPath.section ==0 && indexPath.row == 2)
    {
        [textField resignFirstResponder];
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
        if(textField.text==nil||textField.text.length==0)
        { NSString *c=NSLocalizedString(@"note", @"title");
            NSString *b=NSLocalizedString(@"ok", @"title");
            NSString *d=NSLocalizedString(@"Please fill out the rule name", @"title");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:c
                                  message:d
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:b,nil];
            [alert show];
            [alert release];
           // [message release];
            

        }
        else
        {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *button = [self getStateButton];
        if (cell.accessoryView==nil) {
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
          NSInteger Row=indexPath.row;
        int playID=0;
            playID=[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1;
            for (UIButton *button in cell.contentView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) {
                if ([button.currentImage isEqual:unselectImg]) {
                    [button setImage:selectImg forState:UIControlStateNormal];
                    [selectedIndexPaths addObject:indexPath];
                [button setImage:selectImg forState:UIControlStateNormal];
                    if(a==nil)
                    {
                      [self insert:Row playId:playID];
                    }
                    else{
                          [self insert:Row playId:[a intValue]];
                    
                    }
                }else{
                    if(a==nil)
                    {
                           [self deletes:Row playId:playID];
                    }
                    else{
                        [self deletes:Row playId:[a intValue]];

                 
                    }
                    [button setImage:unselectImg forState:UIControlStateNormal];
                    [selectedIndexPaths removeObject:indexPath];
                }
            }
        }
    }
    }
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];
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
    NSString *createIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INT PRIMARY KEY)",idOrder];//OrderID INTEGER PRIMARY KEY,
    [dataBase createTable:createIdOrder];
    NSString *createPlayTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INTEGER PRIMARY KEY,playList_name,Transtion)",PlayTable];
    [dataBase createTable:createPlayTable];
    NSString *createPlayIdOrder= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT PRIMARY KEY)",playIdOrder];
    [dataBase createTable:createPlayIdOrder];
    NSString *selectPlayIdOrder=[NSString stringWithFormat:@"select id from playIdOrder"];
    [dataBase selectOrderId:selectPlayIdOrder];
    
    NSString *selectPlayTable = [NSString stringWithFormat:@"select playlist_id from PlayTable"];
    [dataBase selectFromPlayTable:selectPlayTable];
     self.playIdList=dataBase.playIdAry;
    NSString *createRules=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(playList_id INT,playList_rules INT,user_id INT,user_name)",Rules];
    [dataBase createTable:createRules];
    NSString *selectRules= [NSString stringWithFormat:@"select user_id,user_name from rules where playlist_id=%d",[a intValue]];
    [dataBase selectFromRules:selectRules];
    self.playrules_idList=dataBase.playlist_UserId;
    NSLog(@"YYYY%@",playrules_idList);

}


-(void)insert:(NSInteger)Row playId:(int)playId
{
    NSString *insertRules= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_id,playList_rules,user_id,user_name) VALUES('%d','%d','%@','%@')",Rules,playId,1,[orderList objectAtIndex:Row],[userNames objectAtIndex:Row]];
    NSLog(@"%@",insertRules);
    [dataBase insertToTable:insertRules];  
}


-(void)deletes:(NSInteger)Row playId:(int)playId
{
    NSString *deleteRules= [NSString stringWithFormat:@"DELETE FROM Rules WHERE playlist_id=%d and user_id='%@'",playId,[orderList objectAtIndex:Row]];
    NSLog(@"%@",deleteRules);
    [dataBase deleteDB:deleteRules];
}


-(void)update:(NSInteger)Row rule:(int)rule playId:(int)playId
{
    NSString *updateRules= [NSString stringWithFormat:@"UPDATE %@ SET playList_rules=%d WHERE playlist_id=%d and user_id='%@'",Rules,rule,playId,[orderList objectAtIndex:Row]];
	NSLog(@"%@",updateRules);
	[dataBase updateTable:updateRules];
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
    UITableViewCell *cell = (UITableViewCell *)[button superview];
    NSLog(@"rrrr%@",[button superview]);
    NSIndexPath *index = [listTable indexPathForCell:cell];
    NSInteger Row=index.row;
    NSLog(@"FFFFF%d",Row);
    int playID=0;
        playID=[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1;
       [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    if ([button.titleLabel.text isEqualToString:MUST]) {
        button.backgroundColor = [UIColor colorWithRed:44/255.0 green:100/255.0 blue:196/255.0 alpha:1.0];
        [button setTitle:EXCLUDE forState:UIControlStateNormal];
        if(a==nil)
        {
        [self update:Row rule:0 playId:playID];
        }
        else
        {
            [self update:Row rule:0 playId:[a intValue]];
        }
    }else if([button.titleLabel.text isEqualToString:EXCLUDE]){
        button.backgroundColor = [UIColor colorWithRed:81/255.0 green:142/255.0 blue:72/255.0 alpha:1.0];
        [button setTitle:OPTIONAL forState:UIControlStateNormal];
        if(a==nil)
        {
        [self update:Row rule:2 playId:playID];
        }
        else
        {
            [self update:Row rule:2 playId:[a intValue]];
            
        }
    }else{
        button.backgroundColor = [UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
        [button setTitle:MUST forState:UIControlStateNormal];
        if(a==nil)
        {
            [self update:Row rule:1 playId:playID];
        }
        else
        {
            [self update:Row rule:1 playId:[a intValue]];
            
        }
    }
}
-(void)setSelectState:(id)sender{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath *index = [listTable indexPathForCell:cell];
     NSInteger Row=index.row;
    int playID=0;
         playID=[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1;
     if ([button.currentImage isEqual:selectImg]) {
        if(a==nil)
        {
            [self deletes:Row playId:playID];
        }
        else{
        
            [self deletes:Row playId:[a intValue]];
        }
        [button setImage:unselectImg forState:UIControlStateNormal];
        NSIndexPath *index = [listTable indexPathForCell:cell];
        [selectedIndexPaths removeObject:index];
        cell.accessoryView = nil;
    }else{
        if(a==nil)
        {
            [self insert:Row playId:playID];
            
        }
        else
        {
        [self insert:Row playId:[a intValue]];
        }
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
    key=1;
   }
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"wpro");
}
-(void)textFieldDidEndEditing:(UITextField *)textField1
{
    NSLog(@"end");
    if(textField.text==nil||textField.text.length==0)
    {
        NSString *c=NSLocalizedString(@"note", @"title");
        NSString *b=NSLocalizedString(@"ok", @"title");
        NSString *d=NSLocalizedString(@"Rule name can not be empty!", @"title");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:c
                              message:d
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:b,nil];
        [alert show];
        [alert release];
        if(a!=nil)
        {
            textField.text=listName;
        }
        else
        {
            NSString *deletePlayTable = [NSString stringWithFormat:@"DELETE FROM PlayTable WHERE playList_id=%d",[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1];
            NSLog(@"%@",deletePlayTable );
            [dataBase deleteDB:deletePlayTable ]; 
            NSString *deleteplayIdOrder= [NSString stringWithFormat:@"DELETE FROM playIdOrder WHERE play_id=%d",[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1];
            NSLog(@"%@",deleteplayIdOrder);
            [dataBase deleteDB:deleteplayIdOrder]; 
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                               object:self 
                                                             userInfo:dic1];
            
        }

    }
    else
    {
        [self addPlay];
    }   
    

}
-(void)addPlay
{
    if(a==nil)
    {
        NSString *insertPlayTable= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(playList_name,playList_id) VALUES('%@',%d)",PlayTable,textField.text,[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1];
        NSLog(@"%@",insertPlayTable);
        [dataBase insertToTable:insertPlayTable];
        NSString *insertPlayIdOrder= [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(play_id) VALUES(%d)",playIdOrder,[[playIdList objectAtIndex:[playIdList count]-1]intValue]+1];
        NSLog(@"%@",insertPlayIdOrder);
        [dataBase insertToTable:insertPlayIdOrder];
    }
    else{
        key=1;
        NSString *updateRules= [NSString stringWithFormat:@"UPDATE %@ SET playlist_name='%@' WHERE playlist_id=%d",PlayTable,textField.text,[a intValue]];
        NSLog(@"%@",updateRules);
        [dataBase updateTable:updateRules];
    }
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];
    


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
    if(a==nil)
    {
    NSString *deleteRules=[NSString stringWithFormat:@"delete from Rules where playList_id=%d",[[playIdList objectAtIndex:[playIdList count]-1]intValue]];
        NSLog(@"%@",deleteRules);
        [dataBase deleteDB:deleteRules];
    }
    else
    {
        NSString *deleteRules1=[NSString stringWithFormat:@"delete from Rules where playList_id=%d",[a intValue]];
        NSLog(@"%@",deleteRules1);
        [dataBase deleteDB:deleteRules1];
    }
    [selectedIndexPaths removeAllObjects];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"def",@"name",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addplay" 
                                                       object:self 
                                                     userInfo:dic1];
}

#pragma mark -
#pragma mark Notification method
-(void)changeTransitionAccessoryLabel:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    NSString *labelText = [dic objectForKey:@"tranStyle"];
    self.tranLabel.text = labelText;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     NSLog(@"LOOOOO");
   // [textField resignFirstResponder];
   
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
    //dataBase = nil;
    listTable =nil;
    listName = nil;
    userNames = nil;
    state = nil;
}
@end
