//
//  AccountNetwork.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DiffBaseNetwork.h"

@interface AccountNetwork : DiffBaseNetwork


+ (instancetype)shareInstance;

// 获取账户信息 token。。。
- (void)loginWithProvider:(NSString *)providerId baseStr:(NSString *)dataJsonStr success:(void(^)(id responseObj))success failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure;

// 刷新token
- (void)refreshToken:(NSString *)refreshToken Success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

// 手机号码登录，获取验证码
- (void)getVertyCodeWithMobile:(NSString *)mobile success:(void(^)(id responseObj))success failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure;
// 手机号码登录，验证 验证码
- (void)loginWithMobile:(NSString *)mobile captcha:(NSString *)vertyCode success:(void(^)(id responseObj))success failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure;


@end
