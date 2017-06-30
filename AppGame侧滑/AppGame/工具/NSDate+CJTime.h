//
//  NSDate+CJTime.h
//  Ecm
//
//  Created by zengchunjun on 16/6/28.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (CJTime)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;
- (NSString *)dateStrWithYMD;

/**
 *  返回当前时间戳
 */
- (NSString *)currentDateString;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

// 生成时间间隔字符串
- (NSString *)diff2now; //距离现在
- (NSDateComponents *)components;

// 用于收藏内的时间展示
- (NSString *)diff2nowOfCollectoin;

// 主页信息的时间
- (NSString *)currentDateDayString;
- (NSString *)currentDateYearMonthString;


@end
