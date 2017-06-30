//
//  DifferAccountTool.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/25.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DifferAccount;
@class UserModel;

// 账户操作工具类
@interface DifferAccountTool : NSObject


+ (DifferAccount *)account;

+ (void)saveAccount:(DifferAccount *)account;

// 退出登录，删除本地账户
+ (BOOL)deleteAccount;


+ (void)downloadAvata:(NSURL *)avata;

+ (void)savaAvata:(UIImage *)image;

+ (UIImage *)getAvata;



@end
