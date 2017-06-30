//
//  GameGroup.m
//  AppGame
//
//  Created by supozheng on 2017/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameListGroup.h"

@implementation GameListGroup
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"game":@"relationships.game",
             };
    
}
@end
