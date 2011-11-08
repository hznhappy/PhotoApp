//
//  AnimaSelectController.m
//  PhotoApp
//
//  Created by Andy on 11/4/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "AnimaSelectController.h"


@implementation AnimaSelectController
@synthesize animaArray;
@synthesize tranStyle;

- (void)dealloc
{
    [tranStyle release];
    [animaArray release];
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
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:@"Dissolve",@"Cube",@"Ripple",@"Wipe Across",@"Wipe Down", nil];
    self.animaArray = tempArray;
    [tempArray release];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
