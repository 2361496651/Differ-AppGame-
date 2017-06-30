//
//  DailyGroup.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyGroup.h"
#import "DailyModel.h"

@implementation DailyGroup


+ (NSDictionary *)objectClassInArray

{
    return @{@"list":[DailyModel class]
             };
    
}

@end
