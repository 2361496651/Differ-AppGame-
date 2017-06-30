//
//  ArticleModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ArticleModel.h"
#import "TagsModel.h"

@implementation ArticleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"title":@"attributes.title",
             @"cover":@"attributes.cover",
             @"descript":@"attributes.description",
             @"from":@"attributes.from",
             @"taged":@"attributes.taged",
             @"commented":@"attributes.commented",
             @"created_at":@"attributes.created_at",
             @"updated_at":@"attributes.updated_at",
             @"tags_thumbs_up":@"attributes.tags_thumbs_up",
             @"tags":@"attributes.tags",
             @"user":@"attributes.user",
             @"url":@"attributes.url"
             };
}

+ (NSDictionary *)objectClassInArray

{
    return @{@"tags":[TagsModel class]
             };
    
}

@end
