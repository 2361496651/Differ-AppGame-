//
//  DifferAccount.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/25.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DifferAccount.h"
#import <MJExtension.h>



@implementation DifferAccount
MJCodingImplementation

+ (instancetype)accountWithDic:(NSDictionary *)dict
{
    DifferAccount *account = [[self alloc] init];
//    [account setValuesForKeysWithDictionary:dict];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.refresh_token_expires_in = dict[@"refresh_token_expires_in"];
//    account.uid = dict[@"id"];
    account.refresh_token = dict[@"refresh_token"];
//    account.username = dict[@"username"];
    
    return account;
}

// 设置账号的过期时间
- (void)setExpires_in:(NSString *)expires_in
{
    _expires_in = expires_in;
    
    // 账号的过期时间 = 现在 + 有效期
    _expires_date = [NSDate dateWithTimeIntervalSinceNow:[expires_in longLongValue]];
//    _expires_date = [NSDate dateWithTimeIntervalSinceNow:10];
    
    
}

- (void)setRefresh_token_expires_in:(NSString *)refresh_token_expires_in
{
    _refresh_token_expires_in = refresh_token_expires_in;
    _refresh_token_expires_date = [NSDate dateWithTimeIntervalSinceNow:[refresh_token_expires_in longLongValue]];
//    _refresh_token_expires_date = [NSDate dateWithTimeIntervalSinceNow:10];
}

@end
