//
//  AccountNetwork.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AccountNetwork.h"
#import "GlobelConst.h"
#import "NSDate+CJTime.h"
#import "DiffUtil.h"
#import "NSString+Hash.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"

@implementation AccountNetwork
static AccountNetwork *g_account;

//baseURL使用这用类
//@"http://passport.test.appgame.com";

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_account = [[AccountNetwork alloc]initWithBaseURL:[NSURL URLWithString:user_base_service]];
//        g_account.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,nil];

    });
    return g_account;
}

// 传过来的dataJsonStr是json字符串  获取账户信息
- (void)loginWithProvider:(NSString *)providerId baseStr:(NSString *)dataJsonStr success:(void(^)(id responseObj))success failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure
{
    //将json字符串进行base64编码
    NSString *data = [DiffUtil encodingBase64WithOriginStr:dataJsonStr];
    
    NSString *url = @"/social/provider-login";
    
    // 时间戳
    NSString *t_str = [[NSDate date] currentDateString];
    NSLog(@"%@",t_str);
    
    //安全令牌
    NSString *appendStr = [[data stringByAppendingString:differ_client_id] stringByAppendingString:t_str];
    NSString *dataClientidMd5 = [appendStr md5String];

    NSString *sign = [[dataClientidMd5 stringByAppendingString:differ_client_secret] md5String];
    
    NSDictionary *paramet = @{
                              @"provider_id":providerId,
                              @"data":data,
                              @"client_id":differ_client_id,
                              @"t":t_str,
                              @"sign":sign
                              };
    [[self postOfDiffer:url params:paramet] subscribeNext:^(id responseObj) {
        success(responseObj);
    } error:^(NSError *error) {
        failure(error,[error code],[error description]);
    }];
}

// 刷新token
- (void)refreshToken:(NSString *)refreshToken Success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
//    DifferAccount *account = [DifferAccountTool account];
    NSString *url = @"/oauth/access_token";
//    if (account.refresh_token == nil) return;
    NSDictionary *paramet = @{
                              @"grant_type":@"refresh_token",
                              @"client_id":differ_client_id,
                              @"client_secret":differ_client_secret,
                              @"refresh_token":refreshToken
                              };
    [[self postOfDiffer:url params:paramet]subscribeNext:^(id responseObj) {
        success(responseObj);
    } error:^(NSError *error) {
        failure(error);
    }];
}

// 手机号码登录，获取验证码
- (void)getVertyCodeWithMobile:(NSString *)mobile success:(void(^)(id responseObj))success failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure
{
    NSString *url = @"/oauth/access_token";
    
    NSDictionary *paramet = @{
                              @"grant_type":@"mobile",
                              @"action":@"send",
                              @"client_id":differ_client_id,
                              @"client_secret":differ_client_secret,
                              @"scope":@"userinfo",
                              @"mobile":mobile
                              };
    [[self postOfDiffer:url params:paramet] subscribeNext:^(id responseObj) {
        success(responseObj);
    } error:^(NSError *error) {
        failure(error,[error code],[error description]);
    }];
    
}

// 手机号码登录，验证 验证码
- (void)loginWithMobile:(NSString *)mobile captcha:(NSString *)vertyCode success:(void(^)(id responseObj))success failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure
{
    NSString *url = @"/oauth/access_token";
    
    NSDictionary *paramet = @{
                              @"grant_type":@"mobile",
                              @"action":@"verify",
                              @"client_id":differ_client_id,
                              @"client_secret":differ_client_secret,
                              @"scope":@"userinfo",
                              @"mobile":mobile,
                              @"captcha":vertyCode
                              };
    [[self postOfDiffer:url params:paramet] subscribeNext:^(id responseObj) {
        success(responseObj);
    } error:^(NSError *error) {
        failure(error,[error code],[error description]);
    }];
    
}


@end
