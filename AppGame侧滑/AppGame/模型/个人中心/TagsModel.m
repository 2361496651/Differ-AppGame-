//
//  TagsModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "TagsModel.h"

@implementation TagsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             @"tagName":@"name",
             @"name":@"attributes.name",
             @"thumbs_up":@"attributes.thumbs_up",
             @"is_thumb":@"attributes.is_thumb"
             };
}

@end
