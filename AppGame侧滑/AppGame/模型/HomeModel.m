//
//  HomeModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{
//             @"type":@"attributes.type",
//             @"title":@"attributes.title",
//             @"position":@"attributes.position",
//             @"cover":@"attributes.cover",
//             @"descrip":@"attributes.description",
//             @"display":@"attributes.display",
//             @"from":@"attributes.from",
//             @"extra_data":@"attributes.extra_data",
//             @"published_type":@"attributes.published_type",
//             @"published_at":@"attributes.published_at",
//             @"info":@"attributes.info",
//             };
//}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"descrip":@"description"
             };
}

@end
