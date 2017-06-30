//
//  UIViewController+AGExtension.m
//  LittleGame
//
//  Created by Mao on 14-8-25.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import "UIViewController+AGExtension.h"
#import "SVProgressHUD.h"


static NSTimeInterval DefaultDelay = 2;

@implementation UIViewController (AGTools)
- (UIViewController *)ag_fatherViewController
{
    UIViewController *viewController = (UIViewController *)self.nextResponder;
    while (![viewController isKindOfClass:[UIViewController class]]) {
        viewController = (UIViewController *)viewController.nextResponder;
    }
    return viewController;
}
+ (UIViewController *)ag_currentViewController{
    UIView *aView = [UIApplication sharedApplication].windows.firstObject;
    NSMutableArray *views = [NSMutableArray arrayWithArray:aView.subviews];
    while (views.count) {
        UIView *each = views.firstObject;
        if ([each.nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *aVC = (UIViewController*)each.nextResponder;
            return aVC;
        }else{
            [views removeObjectAtIndex:0];
            [views addObjectsFromArray:each.subviews];
        }
    }
    return nil;
    
}
+ (UIViewController *)ag_rootController{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
+ (UINavigationController*)ag_currentNavigationController{
    UIView *aView = [UIApplication sharedApplication].windows.firstObject;
    NSMutableArray *views = [NSMutableArray arrayWithArray:aView.subviews];
    while (views.count) {
        UIView *each = views.firstObject;
        if ([each.nextResponder isKindOfClass:[UINavigationController class]]) {
            UINavigationController *aVC = (UINavigationController*)each.nextResponder;
            return aVC;
        }else{
            [views removeObjectAtIndex:0];
            [views addObjectsFromArray:each.subviews];
        }
    }
    return nil;
}

@end

