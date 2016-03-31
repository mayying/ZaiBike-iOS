//
//  AppDelegate.m
//  ZaiBike-iOS
//
//  Created by May Ying on 1/11/15.
//  Copyright © 2015 ZaiBike. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

// force potrait screen mode
-(BOOL)shouldAutorotate{
    return NO;
}

// Override point for customization after application launch.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyDpwE-Th5qAi72ROgMBBMX1tqDKRiY4k1o"];
    
    //Your View Controller Identifiers defined in Interface Builder
    NSString *mainViewControllerIdentifier  = @"MainViewController";
    NSString *loginViewControllerIdentifier = @"WelcomeViewController";
    
    //check if the key exists and its value
    NSString* appHasLaunchedOnce = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
    
    //check which view controller identifier should be used
    NSString *viewControllerIdentifier = appHasLaunchedOnce != NULL ? mainViewControllerIdentifier : loginViewControllerIdentifier;
    
    //IF THE STORYBOARD EXISTS IN YOUR INFO.PLIST FILE AND YOU USE A SINGLE STORYBOARD
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    
    //instantiate the view controller
    UIViewController *presentedViewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    //IF YOU DON'T USE A NAVIGATION CONTROLLER:
    [self.window setRootViewController:presentedViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
