//
//  CategoryModel.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id"
             };
}

@end
