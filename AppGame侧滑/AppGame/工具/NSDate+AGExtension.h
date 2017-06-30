//
//  NSDate+AGExtension.h
//  AppGame
//
//  Created by Mao on 15/1/28.
//  Copyright (c) 2015年 计 炜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AGExtension)
/**
 *  根据ISO 8601 标准和毫秒级精度储存的字符串对象返回NSDate对象
 *
 *  @param dateString 以 ISO 8601 标准和毫秒级精度储存:YYYY-MM-DDTHH:MM:SS.MMMMZ的日期时间字符串
 *
 *  @return date
 */
+ (NSDate*)dateFromISO8601String:(NSString*)dateString;
- (NSString*)toISO8601String;
/**
 *  以现在的时间算起，按给定分钟数取整。比如现在是9:01，按10分钟取整，则返回9:10。
 *
 *  @param minutes 给定取整的分钟数
 *
 *  @return 返回NSDate
 */
+ (NSDate*)dateSinceNowRoundedToMinutes:(NSInteger)minutes;
- (NSDate*)dateRoundedToMinutes:(NSInteger)minutes;
@end
