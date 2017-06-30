//
//  AchievesModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AchievesModel.h"
#import <MJExtension.h>

@implementation AchievesModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             
             @"name":@"attributes.name",
             @"icon":@"attributes.icon",
             @"status":@"attributes.status"
             };
}

@end
