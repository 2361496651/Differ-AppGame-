//
//  UIViewController+AGExtension.h
//  LittleGame
//
//  Created by Mao on 14-8-25.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AGTools)
- (UIViewController *)ag_fatherViewController;

///获取当前展示view的view controller
+ (UIViewController *)ag_currentViewController;

//获取root view controller
+ (UIViewController *)ag_rootController;

//获取当前的导航控制器
+ (UINavigationController*)ag_currentNavigationController;
@end
