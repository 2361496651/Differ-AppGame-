//
//  GameModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameModel.h"
#import "CategoryModel.h"
#import "DownLinkModel.h"
#import "TagsModel.h"


@implementation GameModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"game_id":@"attributes.game_id",
             @"game_name_cn":@"attributes.game_name_cn",
             @"game_name_en":@"attributes.game_name_en",
             @"game_name_alias":@"attributes.game_name_alias",
             @"avg_appraise_star":@"attributes.avg_appraise_star",
             @"recommend_reason":@"attributes.recommend_reason",
             @"icon":@"attributes.icon",
             @"intro":@"attributes.intro",
             
             @"describe":@"attributes.describe",
             @"publisher":@"attributes.publisher",
             
             @"status":@"attributes.status",
             @"activity_label":@"attributes.activity_label",
             @"activity_url":@"attributes.activity_url",
             
             @"update_info":@"attributes.update_info",
             @"updated_at":@"attributes.updated_at",
             @"origin_updated_at":@"attributes.origin_updated_at",
             @"appraise_points":@"attributes.appraise_points",
             
             @"tags":@"attributes.tags",
             @"pics":@"attributes.pic",
             @"relay_games":@"attributes.relay_games",
             
             @"categoryArray":@"attributes.category",
             @"downLinkArray":@"attributes.down_link",
             
             @"cover":@"attributes.cover",
             @"video":@"attributes.video",
             @"user":@"attributes.user",
             @"isCollect":@"is_collected"
             };
}

+ (NSDictionary *)objectClassInArray

{
    return @{@"categoryArray":[CategoryModel class],
             
             @"downLinkArray":[DownLinkModel class],
             
             @"tags":[TagsModel class],
             
             @"relay_games":[GameModel class],
             
             @"pics":[NSURL class]
            };
    
}

@end
