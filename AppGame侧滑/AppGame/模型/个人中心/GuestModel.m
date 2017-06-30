//
//  GuestModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/22.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GuestModel.h"


@implementation GuestModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"content":@"attributes.content",
//             @"parent_id":@"attributes.parent_id",
             @"author":@"relationships.author",
             @"is_thumb":@"attributes.is_thumb",
             @"thumbs_up":@"attributes.thumbs_up",
             @"created_at":@"attributes.created_at",
             @"childGuests":@"attributes.childGuests"
             };
}

+ (NSDictionary *)objectClassInArray
{
    
    return @{@"childGuests":[GuestModel class]};
    
}

@end
