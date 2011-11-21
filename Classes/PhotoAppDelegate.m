//
//   PhotoAppDelegate.m
//   PhotoApp
//
//  Created by Andy .
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "PhotoAppDelegate.h"

@implementation PhotoAppDelegate

@synthesize window;
@synthesize rootViewController;
#pragma mark -
#pragma mark Application lifecycle



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after application launch.
    // Add the view controller's view to the window and display.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [window addSubview:rootViewController.view];
    [window makeKeyAndVisible];

    return YES;
}
//- (BOOL)getSortAppPref {
   // NSLog(@"KOE");
	/* As this application provides a Settings.bundle for application
     preferences, the following is a simple example that retrieves the
     current user-set preferences. */
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	/* Similar to the AppPrefs sample, we first test to see if the preferences
     settings exist, and create if needed. */
	/*NSData *testValue = [defaults dataForKey:kSettingKey]; /* setting exists? */
	/*if (testValue == nil) {
        NSLog(@"NIL");
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"PhotoSettings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
		NSNumber *settingDefault = nil;
		NSDictionary *prefItem;
		
		for (prefItem in prefSpecifierArray) {
            NSLog(@"LO");
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:kSettingKey]) {
				settingDefault = defaultValue;
			}
		}
		
		if (settingDefault != nil) {
            NSLog(@"ARE");
			NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                         settingDefault, kSettingKey, nil];		
			[defaults registerDefaults:appDefaults];
			[defaults synchronize];
		}
	}
	return [defaults boolForKey:kSettingKey];
}*/


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}


@end
@implementation UITabBarController (MyApp) 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) || toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

@implementation UINavigationController (MyApp) 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) || toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
@end