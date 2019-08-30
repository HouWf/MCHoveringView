//
//  AppDelegate.m
//  MCHoveringView
//
//  Created by qinmuqiao on 2019/3/25.
//  Copyright © 2019年 MuYaQin. All rights reserved.
//

#import "AppDelegate.h"
#import "GKNavigationBarConfigure.h"
#import "UINavigationController+GKCategory.h"
@interface AppDelegate ()

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;//毛玻璃效果

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GKConfigure setupCustomConfigure:^(GKNavigationBarConfigure *configure) {
        configure.titleColor = [UIColor blackColor];
        configure.titleFont = [UIFont systemFontOfSize:18.0f];
        configure.gk_navItemLeftSpace = 4.0f;
        configure.gk_navItemRightSpace = 4.0f;
        configure.backStyle = GKNavigationBarBackStyleWhite;
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(@"MainTableViewController") class] new]];
     self.window.rootViewController = [UINavigationController rootVC:[[NSClassFromString(@"MainTableViewController") class] new] translationScale:NO];
    [self.window makeKeyAndVisible];
   
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _visualEffectView.alpha = 0.97f;
    _visualEffectView.frame =self.window.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:_visualEffectView];
    NSLog(@"取消活跃");
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"进入后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"进入前台");
    [_visualEffectView removeFromSuperview];
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"变得活跃");
    [_visualEffectView removeFromSuperview];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
