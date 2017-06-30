//
//  DifferAccount.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/25.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

// 账户模型
@interface DifferAccount : NSObject

@property (nonatomic,copy)NSString *access_token;

@property (nonatomic,copy)NSString *expires_in;

@property (nonatomic,copy)NSDate *expires_date;

@property (nonatomic,copy)NSString *refresh_token;

@property (nonatomic,copy)NSString *refresh_token_expires_in;

@property (nonatomic,copy)NSDate *refresh_token_expires_date;

//@property (nonatomic,copy)NSString *uid;
//
//@property (nonatomic,copy)NSString *username;



+ (instancetype)accountWithDic:(NSDictionary *)dict;


@end
