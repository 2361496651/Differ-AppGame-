//
//  NSDate+AGExtension.m
//  AppGame
//
//  Created by Mao on 15/1/28.
//  Copyright (c) 2015年 计 炜. All rights reserved.
//

#import "NSDate+AGExtension.h"

@implementation NSDate (AGExtension)
+ (NSDate*)dateFromISO8601String:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return [dateFormatter dateFromString:dateString];
}
- (NSString*)toISO8601String{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return [dateFormatter stringFromDate:self];
}
+ (NSDate*)dateSinceNowRoundedToMinutes:(NSInteger)minutes{
    int64_t s = [[NSDate date] timeIntervalSince1970];
    int64_t m = s / 60;
    if (m % minutes) {
        m = ((m / minutes) + 1) * minutes;
    }
    return [NSDate dateWithTimeIntervalSince1970:m * 60];
}
- (NSDate*)dateRoundedToMinutes:(NSInteger)minutes{
    int64_t s = [self timeIntervalSince1970];
    int64_t m = s / 60;
    if (m % minutes) {
        m = ((m / minutes) + 1) * minutes;
    }
    return [NSDate dateWithTimeIntervalSince1970:m * 60];
}
@end
