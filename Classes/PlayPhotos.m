//
//  PlayPhotos.m
//  PhotoApp
//
//  Created by Andy on 10/11/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PlayPhotos.h"


@implementation PlayPhotos
@synthesize assets;
@synthesize slider;
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
    [assets release];
    [slider release];
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
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:30];
    for (ALAsset *result in self.assets) {
        ALAssetRepresentation *rep = [result defaultRepresentation];
        UIImage *img = [UIImage imageWithCGImage:[rep fullResolutionImage]];
        [array addObject:img];
    }

    PhotoFrameView.animationImages = array;
	PhotoFrameView.animationDuration = 25.0f;
	[PhotoFrameView startAnimating];
    show = NO;
    slider.alpha=0.0f;
    self.navigationController.navigationBar.alpha = 0;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)sliderAction:(id)sender{
    UISlider* durationSlider = sender;
	PhotoFrameView.animationDuration = [durationSlider value];
	if (!PhotoFrameView.isAnimating)
		[PhotoFrameView startAnimating];
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
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView beginAnimations:@"touch" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
    self.navigationController.navigationBar.alpha = show ? 0.0f:1.0f;
    [[UIApplication sharedApplication]setStatusBarHidden:show];
    slider.alpha = show ? 0.0f:1.0f;
    show = !show;
    [UIView commitAnimations];
}

@end
