//
//  AppDelegate.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "AppDelegate.h"
#import "UIViewController+YYYNavigationBar.h"
#import "YYYNavigationManager.h"
#import "BarBackgroundView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [YYYNavigationManager globalManager].customBarBackgroundView = [BarBackgroundView new];
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
    }
    //    [UIView appearanceWhenContainedIn:UITableView.class, nil].backgroundColor = kBackgroundColor;
    [UITableView appearance].rowHeight = 100;
    [UITableView appearance].sectionHeaderHeight = 0;
    [UITableView appearance].sectionFooterHeight = 0;
    [UITableView appearance].separatorColor = [UIColor cyanColor];
    
    // Override point for customization after application launch.
//      [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-60, 0) forBarMetrics:UIBarMetricsDefault];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
