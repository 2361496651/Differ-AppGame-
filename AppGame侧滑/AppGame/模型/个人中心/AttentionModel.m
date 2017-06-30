//
//  AttentionModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AttentionModel.h"
#import <MJExtension.h>

@implementation AttentionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
//             @"author":@"attributes",
             @"username":@"attributes.username",
             @"nickname":@"attributes.nickname",
             @"avatar":@"attributes.avatar",
             @"sex":@"attributes.sex",
             @"birthday":@"attributes.birthday",
             @"remark":@"attributes.remark",
             @"follower":@"attributes.follower",
             @"following":@"attributes.following",
             @"public_follower":@"attributes.public_follower",
             @"public_following":@"attributes.public_following",
             @"rank":@"attributes.rank",
             @"lastAppraise":@"attributes.last_appraise",
             };
    
}

@end
