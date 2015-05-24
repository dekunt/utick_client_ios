//
//  AppDelegate.m
//  UTick
//
//  Created by dekunt on 15/5/22.
//  Copyright (c) 2015年 MeU. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *backgroundHandlers;
@property (nonatomic, strong) NSMutableArray *foregroundHandlers;
@end

@implementation AppDelegate


-(NSMutableArray *)backgroundHandlers
{
    if (!_backgroundHandlers)
        _backgroundHandlers = [NSMutableArray array];
    return _backgroundHandlers;
}

-(NSMutableArray *)foregroundHandlers
{
    if (!_foregroundHandlers)
        _foregroundHandlers = [NSMutableArray array];
    return _foregroundHandlers;
}

- (void)addHandlerForEnterBackground:(void (^)())handler
{
    [self.backgroundHandlers addObject:handler];
}

- (void)addHandlerForEnterForeground:(void (^)())handler
{
    [self.foregroundHandlers addObject:handler];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (void(^handler)() in self.backgroundHandlers) {
        handler();
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (void(^handler)() in self.foregroundHandlers) {
        handler();
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
