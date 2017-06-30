//
//  GameDetailModel.m
//  AppGame
//
//  Created by chan on 17/5/16.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameDetailModel.h"
#import "DownLinkModel.h"
#import "TagsModel.h"
#import "GameModel.h"

@implementation GameDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"uid":@"id",
             @"type":@"type",
             @"game_name_cn":@"attributes.game_name_cn",
             @"game_name_en":@"attributes.game_name_en",
             @"avg_appraise_star":@"attributes.avg_appraise_star",
             @"intro":@"attributes.intro",
             @"describe":@"attributes.describe",
             @"icon":@"attributes.icon",
             
             @"picArray":@"attributes.pic",
             @"downLinkArray":@"attributes.down_link",
             @"tagArray":@"attributes.tags",
             @"relayGameArray":@"attributes.relay_games",
             };
}

+(NSDictionary *)objectClassInArray{
    return @{
             @"downLinkArray":[DownLinkModel class],
             @"tagArray":[TagsModel class],
             @"relayGameArray":[GameModel class]
             };
}

@end
