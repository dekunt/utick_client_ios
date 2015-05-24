//
//  AppDelegate.h
//  UTick
//
//  Created by dekunt on 15/5/22.
//  Copyright (c) 2015年 MeU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (void)addHandlerForEnterBackground:(void (^)())handler;
- (void)addHandlerForEnterForeground:(void (^)())handler;
@end

