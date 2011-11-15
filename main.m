//
//  main.m
//   PhotoApp
//
//  Created by Andy .
//  Copyright 2011 chinarewards. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
   // NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];  
    /// 取得 iPhone 支持的所有语言设置  
   // NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];  
   // NSLog ( @"%@" , languages); 
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
