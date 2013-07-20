//
//  TYSAppDelegate.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/20/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSAppDelegate.h"

#import "TYSViewController.h"
#import "TYSTimer.h"
#import "Appirater.h"

@implementation TYSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure appirator (app review reminder)
    [Appirater setAppId:@"yourAppId"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[TYSViewController alloc] initWithNibName:@"TYSViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [Appirater appLaunched:YES];
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
    TYSTimer *timer = [TYSTimer sharedTimer];
    if ([timer isRunning]) {
        [timer suspend];
        [(TYSViewController *)self.window.rootViewController toggleTimerLabel];
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    TYSTimer *timer = [TYSTimer sharedTimer];
    if (timer.isSuspended) {
        [(TYSViewController *)self.window.rootViewController toggleTimerLabel];
        [timer resume];
    } else {
        if ([self.window.rootViewController isMemberOfClass:[TYSViewController class]]) {
            TYSViewController *viewController = (TYSViewController *) self.window.rootViewController;
            if (!viewController.isTimerRunning) {
                [viewController resetTimer];
            }
        }
    }
    
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Start timer if not started and current view controller is main view controller
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if (oldNotifications.count > 0) {
        [app cancelAllLocalNotifications];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        // Application was in the background when notification was delivered. Do nothing.
        return;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timer done!"
                                                        message:@"Your tea is ready to be enjoyed!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

@end
