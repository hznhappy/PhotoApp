//
//  PlaylistDetailController.m
//  PhotoApp
//
//  Created by Andy on 11/3/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlaylistDetailController.h"
#import "TextController.h"
#import "User.h"
#import "DBOperation.h"
#import "AnimaSelectController.h"

@implementation PlaylistDetailController
@synthesize listTable;
@synthesize textFieldCell,switchCell,tranCell,musicCell;
@synthesize tranLabel,musicLabel,state;
@synthesize textField;
@synthesize mySwitch;
@synthesize listName;
@synthesize userNames;
@synthesize selectedIndexPaths;
@synthesize mySwc,a;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{ 
    
    mySwc = YES;
    
    selectImg = [UIImage imageNamed:@"Selected.png"];
    unselectImg = [UIImage imageNamed:@"Unselected.png"];
    dataBase=[[DBOperation alloc]init];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSMutableArray *temArray = [[NSMutableArray alloc]init];
    self.selectedIndexPaths = temArray;
    self.userNames = tempArray;
    [tempArray release];
    [temArray release];
    [dataBase openDB];
    NSString *selectIdOrder=[NSString stringWithFormat:@"select id from idOrder"];
    [dataBase selectOrderId:selectIdOrder];
    NSMutableArray *orderList=dataBase.orderIdList;   //dataBase.orderIdlist count is 0;
    for (id object in orderList) {
        User *userName = [dataBase getUserFromUserTable:[object intValue]];
        [userNames addObject:userName.name];
    }
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
        for (UIButton *button in cell.contentView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) {
                if ([button.currentImage isEqual:unselectImg]) {
                    [button setImage:selectImg forState:UIControlStateNormal];
                    [selectedIndexPaths addObject:indexPath];
                }else{
                    [button setImage:unselectImg forState:UIControlStateNormal];
                    [selectedIndexPaths removeObject:indexPath];
                }
            }
        }
    }
    [self.textField resignFirstResponder];
}

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
    NSString *createPlayIdTable= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(play_id INT)",playIdOrder];
    [dataBase createTable:createPlayIdTable];
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
    ts.str1 = user3.name;
    NSString *selectRulesIn= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],1];
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
    NSString *selectRulesOut= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],0];
    [dataBase selectFromRules:selectRulesOut];
    for(int j=0;j<[dataBase.playlist_UserName count];j++)
    {
        if(ts.str3==nil||ts.str3.length==0)
        {
            
            ts.str3=[dataBase.playlist_UserName objectAtIndex:j];
        }
        else
        {  
            ts.str3=[ts.str3 stringByAppendingString:@","];
            ts.str3=[ts.str3 stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:j]];
        }
    }
    NSString *selectRulesOr= [NSString stringWithFormat:@"select user_id,user_name from Rules where playList_id=%d and playList_rules=%d",[a intValue],2];
    [dataBase selectFromRules:selectRulesOr];
    for(int k=0;k<[dataBase.playlist_UserName count];k++)
    {
        if(ts.str4==nil||ts.str4.length==0)
        {
            
            ts.str4=[dataBase.playlist_UserName objectAtIndex:k];
        }
        else
        {  ts.str4=[ts.str4 stringByAppendingString:@","];
            ts.str4=[ts.str4 stringByAppendingString:[dataBase.playlist_UserName objectAtIndex:k]];
        }
    }

    [dataBase closeDB];
    [self.navigationController pushViewController:ts animated:YES];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:a,@"playlist_id",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"edit" 
                                                       object:self 
                                                     userInfo:dic1];
    [ts release];
}

#pragma mark -
#pragma mark Coustom method
-(UIButton *)getStateButton{
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(0, 0, 75, 28);
    [stateButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [stateButton setTitle:MUST forState:UIControlStateNormal];
    stateButton.backgroundColor = [UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
    [stateButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    return stateButton;
}
-(void)changeState:(id)sender{
    UIButton *button = (UIButton *)sender;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    if ([button.titleLabel.text isEqualToString:MUST]) {
        button.backgroundColor = [UIColor colorWithRed:44/255.0 green:100/255.0 blue:196/255.0 alpha:1.0];
        [button setTitle:EXCLUDE forState:UIControlStateNormal];
    }else if([button.titleLabel.text isEqualToString:EXCLUDE]){
        button.backgroundColor = [UIColor colorWithRed:81/255.0 green:142/255.0 blue:72/255.0 alpha:1.0];
        [button setTitle:OPTIONAL forState:UIControlStateNormal];
    }else{
        button.backgroundColor = [UIColor colorWithRed:167/255.0 green:124/255.0 blue:83/255.0 alpha:1.0];
        [button setTitle:MUST forState:UIControlStateNormal];
    }
}
-(void)setSelectState:(id)sender{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
    if ([button.currentImage isEqual:selectImg]) {
        [button setImage:unselectImg forState:UIControlStateNormal];
        NSIndexPath *index = [listTable indexPathForCell:cell];
        [selectedIndexPaths removeObject:index];
        cell.accessoryView = nil;
    }else{
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
