//
//  TopicModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "TopicModel.h"
#import "GameModel.h"

@implementation TopicModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"title":@"attributes.title",
             @"cover":@"attributes.cover",
             @"user_id":@"attributes.user_id",
             @"content":@"attributes.content",
             @"from":@"attributes.from",
             @"taged":@"attributes.taged",
             @"commented":@"attributes.commented",
             @"layout":@"attributes.layout",
             @"status":@"attributes.status",
             @"bg_color":@"attributes.extra_data.bg_color",
             @"font_color":@"attributes.extra_data.font_color",
             @"games":@"attributes.games",
             @"user":@"relationships.user"
             };
}

+ (NSDictionary *)objectClassInArray

{
    return @{@"games":[GameModel class]
             };
    
}



@end
