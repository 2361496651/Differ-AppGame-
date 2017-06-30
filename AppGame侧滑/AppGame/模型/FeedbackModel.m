//
//  FeedbackModel.m
//  AppGame
//
//  Created by supozheng on 2017/5/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "FeedbackModel.h"

@implementation FeedbackModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uid":@"id",
             
             @"name":@"attributes.name"
             
             };
}
@end
