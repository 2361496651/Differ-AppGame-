//
//  ReplyModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/28.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ReplyModel.h"

@implementation ReplyModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"content":@"attributes.content",
             @"is_replied":@"attributes.is_replied",
             @"reply_id":@"attributes.reply_id",
             @"reply_user_id":@"attributes.reply_user_id",
             @"created_at":@"attributes.created_at",
             @"user":@"relationships.author"
             };
}



@end
