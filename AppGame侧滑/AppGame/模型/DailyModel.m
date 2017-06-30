//
//  DailyModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyModel.h"

@implementation DailyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"target":@"attributes.target",
             @"target_id":@"attributes.target_id",
             @"published_at":@"attributes.published_at",
             @"article":@"attributes.info",
             @"topic":@"attributes.info"
             };
}

@end
