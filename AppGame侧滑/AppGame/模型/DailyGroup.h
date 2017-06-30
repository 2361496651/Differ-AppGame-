//
//  DailyGroup.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyGroup : NSObject

@property (nonatomic,copy)NSString *date;

@property (nonatomic,copy)NSString *begin_at;

@property (nonatomic,copy)NSString *end_at;

@property (nonatomic,copy)NSString *count;

@property (nonatomic,strong)NSArray *list;

@end
