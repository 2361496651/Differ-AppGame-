//
//  NSDate+CJTime.m
//  Ecm
//
//  Created by zengchunjun on 16/6/28.
//
//

#import "NSDate+CJTime.h"

@implementation NSDate (CJTime)
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

- (NSString *)dateStrWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    return [fmt stringFromDate:self];
}

- (NSString *)currentDateString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMddHHmmss";
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    return [fmt stringFromDate:self];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}


- (NSDateComponents *)components {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unitFlags fromDate:self];
}

- (NSString *)diff2now {
    NSString *timeStr;
    /*
    int distances = abs((int)[self timeIntervalSinceNow]);

    if (distances < 60) {// 一分钟内
        timeStr = @"刚刚";
    }else if (distances < 60*60){ // 一小时内
        timeStr = [NSString stringWithFormat:@"%d分钟前",distances/60];
    }else if ([self isToday]){// 大于一小时并且是今天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:ss";
        timeStr = [formatter stringFromDate:self];
    }else if ([self isYesterday]){ // 昨天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:ss";
        timeStr = [@"昨天" stringByAppendingString:[formatter stringFromDate:self]];
    }else if ([self components].year == [[NSDate date] components].year){ // 今年
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日HH:ss";
        timeStr = [formatter stringFromDate:self];
    }else{ // 非今年
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy年MM月dd日HH:ss";
        timeStr = [formatter stringFromDate:self];
    }
    */
    NSDate *now = [NSDate date];
    
    // 计算当前时间和发表时间的差距
    int diff = -1 * [self timeIntervalSinceDate:now];
    
    if (diff < 60) {// 1分钟内
        timeStr = @"刚刚";
    } else if (diff < 60 * 60) {// 1个小时内
        timeStr = [NSString stringWithFormat:@"%i分钟前", diff/60];
    } else if (diff < 60 * 60 * 24) {// 1天内
        timeStr = [NSString stringWithFormat:@"%i小时前", diff/(60 * 60)];
    } else if (diff < 60 * 60 * 24 * 7) { // 1个星期内
        diff = diff / 60 / 60 / 24;
        timeStr = [NSString stringWithFormat:@"%i天前", diff];
    } else if (diff < 60 * 60 * 24 * 7 * 4) { // 1个月内
        diff = diff / 60 / 60 / 24 / 7;
        timeStr = [NSString stringWithFormat:@"%i星期前", diff];
    } else if ([now components].year == [self components].year) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"MM-dd HH:mm";
        timeStr = [format stringFromDate:self];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        timeStr = [format stringFromDate:self];
    }
    
    return timeStr;
}

- (NSString *)diff2nowOfCollectoin {
    NSString *timeStr;
    
     int distances = abs((int)[self timeIntervalSinceNow]);
     
     if (distances < 60) {// 一分钟内
         timeStr = @"刚刚";
     }else if (distances < 60*60){ // 一小时内
         timeStr = [NSString stringWithFormat:@"%d分钟前",distances/60];
     }else if ([self isToday]){// 大于一小时并且是今天
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"HH:ss";
         timeStr = [formatter stringFromDate:self];
     }else if ([self isYesterday]){ // 昨天
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"HH:ss";
         timeStr = [@"昨天" stringByAppendingString:[formatter stringFromDate:self]];
     }else {
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyy年MM月dd日";
         timeStr = [formatter stringFromDate:self];
     }
    /*
    NSDate *now = [NSDate date];
    
    // 计算当前时间和发表时间的差距
    int diff = -1 * [self timeIntervalSinceDate:now];
    
    if (diff < 60) {// 1分钟内
        timeStr = @"刚刚";
    } else if (diff < 60 * 60) {// 1个小时内
        timeStr = [NSString stringWithFormat:@"%i分钟前", diff/60];
    } else if (diff < 60 * 60 * 24) {// 1天内
        timeStr = [NSString stringWithFormat:@"%i小时前", diff/(60 * 60)];
    } else if (diff < 60 * 60 * 24 * 7) { // 1个星期内
        diff = diff / 60 / 60 / 24;
        timeStr = [NSString stringWithFormat:@"%i天前", diff];
    } else if (diff < 60 * 60 * 24 * 7 * 4) { // 1个月内
        diff = diff / 60 / 60 / 24 / 7;
        timeStr = [NSString stringWithFormat:@"%i星期前", diff];
    } else if ([now components].year == [self components].year) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"MM-dd HH:mm";
        timeStr = [format stringFromDate:self];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        timeStr = [format stringFromDate:self];
    }
    */
    return timeStr;
}

- (NSString *)currentDateDayString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"dd";
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    return [fmt stringFromDate:self];
}
- (NSString *)currentDateYearMonthString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy.MM月";
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    return [fmt stringFromDate:self];
}

@end
