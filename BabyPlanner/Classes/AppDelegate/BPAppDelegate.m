//
//  BPAppDelegate.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPAppDelegate.h"
#import "BPTabBarController.h"
#import "BPNavigationController.h"
#import "BPMyTemperatureViewController.h"
#import "BPMyChartsViewController.h"
#import "BPMyPregnancyViewController.h"
#import "BPSettingsViewController.h"
#import "TTSwitch.h"
#import "BPUtils.h"

@implementation BPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[TTSwitch appearance] setMaskInLockPosition:@0];
    [[TTSwitch appearance] setTrackImage:[BPUtils imageNamed:@"round-switch-track"]];
    [[TTSwitch appearance] setOverlayImage:[BPUtils imageNamed:@"round-switch-overlay"]];
    [[TTSwitch appearance] setTrackMaskImage:[BPUtils imageNamed:@"round-switch-mask"]];
    [[TTSwitch appearance] setThumbImage:[BPUtils imageNamed:@"round-switch-thumb"]];
    [[TTSwitch appearance] setThumbHighlightImage:[BPUtils imageNamed:@"round-switch-thumb-highlight"]];
    [[TTSwitch appearance] setThumbMaskImage:[BPUtils imageNamed:@"round-switch-mask"]];
    [[TTSwitch appearance] setThumbInsetX:-3.0f];
    [[TTSwitch appearance] setThumbOffsetY:-3.0f];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    BPNavigationController *myTemperatureViewController = [[BPNavigationController alloc] initWithRootViewController:[BPMyTemperatureViewController new]];
    BPNavigationController *myChartsViewController = [[BPNavigationController alloc] initWithRootViewController:[BPMyChartsViewController new]];
    BPNavigationController *myPregnancyViewController = [[BPNavigationController alloc] initWithRootViewController:[BPMyPregnancyViewController new]];
    BPNavigationController *settingsViewController = [[BPNavigationController alloc] initWithRootViewController:[BPSettingsViewController new]];

    BPTabBarController *tabBarController = [[BPTabBarController alloc] init];
    tabBarController.viewControllers = @[myTemperatureViewController, myChartsViewController, myPregnancyViewController, settingsViewController];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
