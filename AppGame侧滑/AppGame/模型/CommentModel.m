//
//  CommentModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/28.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentModel.h"
#import "ReplyModel.h"

@implementation CommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"content":@"attributes.content",
             @"replied":@"attributes.replied",
             @"thumbs_up":@"attributes.thumbs_up",
             @"replies":@"attributes.replies",
             @"is_thumb":@"attributes.is_thumb",
             @"created_at":@"attributes.created_at",
             @"user":@"relationships.author",
             
             
             @"comment_thumbs_up":@"attributes.taged",
             @"commented":@"attributes.commented"
             };
}

+ (NSDictionary *)objectClassInArray

{
    return @{@"replies":[ReplyModel class]
             };
    
}


@end
