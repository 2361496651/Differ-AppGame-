//
//  AppraiseModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AppraiseModel.h"
#import <MJExtension.h>
#import "TagsModel.h"
@implementation AppraiseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"star":@"attributes.star",
             @"taged":@"attributes.taged",
             @"commented":@"attributes.commented",
             @"content":@"attributes.content",
             @"thumbs_up":@"attributes.thumbs_up",
             @"thumbs_down":@"attributes.thumbs_down",
             @"created_at":@"attributes.created_at",
             @"updated_at":@"attributes.updated_at",
             @"comment_count":@"attributes.comment_count",
             @"is_thumb":@"attributes.is_thumb",
             
             @"tags":@"attributes.tags",
             @"game":@"relationships.game",
             @"author":@"relationships.author"
             };
}
+(NSDictionary *)objectClassInArray{
    return @{
             @"tags":[TagsModel class]
             };
}
@end
