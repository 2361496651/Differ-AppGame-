//
//  DynamicModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DynamicModel.h"

@implementation DynamicModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             
             @"content":@"attributes.content",
             @"commented":@"attributes.commented",
             @"thumbs_up":@"attributes.thumbs_up",
             @"shared":@"attributes.shared",
             @"created_at":@"attributes.created_at",
             
             @"images":@"attributes.images",
             
             @"is_forward":@"attributes.is_forward",
             @"is_thumb":@"attributes.is_thumb",
             
             @"game":@"relationships.game",
             @"author":@"relationships.author",
             @"forward":@"relationships.forward"
             
             };
}

+ (NSDictionary *)objectClassInArray
{
    
    return @{@"images":[NSURL class]};
    
}

@end
