//
//  DifferChooseRoot.m
//  AppGame
//
//  Created by zengchunjun on 2017/6/1.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DifferChooseRoot.h"
#import "DiffUtil.h"
#import "MainViewController.h"

@implementation DifferChooseRoot

+ (void)chooseRootControllerWithWindow:(UIWindow *)window
{
    // 获取当前版本
    NSString *newVersion = [DiffUtil getCurrentVersion];
    
    // 获取上一次版本
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:differNewVersionKey];
    
    
    // 选择根控制器，是否授权
    if ([newVersion isEqualToString:lastVersion]) { // 没有新版本，直接进入主界面
        
        MainViewController *tabBar = [[MainViewController alloc] init];
        
        window.rootViewController = tabBar;
        
    }else{ // 有新版本，进入新特性界面
        
        // todo:有新版本，进入新特性界面
        MainViewController *tabBar = [[MainViewController alloc] init];
        window.rootViewController = tabBar;
        
        // 保存最新版本信息
        [[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:differNewVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }

}

@end
