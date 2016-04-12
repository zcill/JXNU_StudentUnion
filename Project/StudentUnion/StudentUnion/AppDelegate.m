//
//  AppDelegate.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/5.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "AppDelegate.h"
#import "ZCTabBarController.h"
#import "ZCLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - private method
// 检查版本
- (void)checkVersionNubmer {
    
    NSString *app_version = [[NSUserDefaults standardUserDefaults] objectForKey:SU_APP_VERSION];
    if (!app_version) {
        [self saveVersionNumber];
    } else {
        
        DLog(@"current version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
        DLog(@"last version: %@", app_version);
    }
    
}
- (void)saveVersionNumber {
    NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:app_version forKey:SU_APP_VERSION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// leancloud的一些设置
- (void)setLeanCloud {
    [AVOSCloud setApplicationId:LeanCloud_AppID
                      clientKey:LeanCloud_AppKey];
    
    // 如果Debug模式，开启log
    [AVOSCloud setAllLogsEnabled:NO];
#ifdef DEBUG
    [AVOSCloud setAllLogsEnabled:YES];
#endif
    
}

// UI的一些修改
- (void)whiteStatusBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

// 设置rootViewController
- (void)setRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if (![AVUser currentUser]) {
        ZCLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ZCLoginViewController"];
        [self.window setRootViewController:loginVC];
    } else {
        ZCTabBarController *tabBar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ZCTabBarController"];
        [self.window setRootViewController:tabBar];
    }
    [self.window makeKeyAndVisible];
    
}

#pragma mark - Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setLeanCloud];
    [self checkVersionNubmer];
    [self whiteStatusBar];
    [self setRootViewController];
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
