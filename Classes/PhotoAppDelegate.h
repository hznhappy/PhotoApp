//
//   PhotoAppDelegate.h
//   PhotoApp
//
//  Created by Andy .
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOperation.h"
@interface PhotoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *rootViewController;
    DBOperation *da;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootViewController;

@end
@interface UITabBarController (MyApp)
@end

@interface UINavigationController (MyApp)
@end
