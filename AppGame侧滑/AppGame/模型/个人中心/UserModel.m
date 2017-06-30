//
//  UserModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "UserModel.h"
#import "AchievesModel.h"

@implementation UserModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"username":@"attributes.username",
             @"nickname":@"attributes.nickname",
             @"avatar":@"attributes.avatar",
             @"sex":@"attributes.sex",
             @"birthday":@"attributes.birthday",
             @"remark":@"attributes.remark",
             @"follower":@"attributes.follower",
             @"following":@"attributes.following",
             @"is_followed":@"attributes.is_followed",
             @"public_follower":@"attributes.public_follower",
             @"public_following":@"attributes.public_following",
             @"rank":@"attributes.rank",
             @"achieves":@"attributes.achieves"
             };
}

+ (NSDictionary *)objectClassInArray
{
    
    return @{@"achieves":[AchievesModel class]};
    
}

@end
