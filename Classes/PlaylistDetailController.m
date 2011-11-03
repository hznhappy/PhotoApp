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

@implementation PlaylistDetailController
@synthesize listTable;
@synthesize listName;
@synthesize mySwitch;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [mySwitch release];
    [listTable release];
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
    UISwitch *tempSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 94, 27)];
    self.mySwitch = tempSwitch;
    [tempSwitch release];
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[playlistName resignFirstResponder];
}

#pragma mark -
#pragma mark UITableView Delegate method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (mySwitch.on == YES) 
        return 4;
    else
        return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.row == 0) {
        playlistName = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 280, 40)];
        playlistName.text = listName;
        playlistName.returnKeyType = UIReturnKeyDone;
        [playlistName addTarget:self
                          action:@selector(hidekeyBoard)
                forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:playlistName];
        [playlistName release];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Transitions";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"PlayMusic";
        cell.accessoryView = self.mySwitch;
    }
    if (mySwitch.on == YES) {
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Music";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    editing = mySwitch.on;
    if (editing) {
        [self.listTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3  inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        
    }else {
        [self.listTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    [super setEditing:editing animated:animated];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)hidekeyBoard{
    [playlistName resignFirstResponder];
}
- (void)viewDidUnload
{
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
