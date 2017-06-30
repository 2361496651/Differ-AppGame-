//
//  DifferAccountTool.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/25.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DifferAccountTool.h"
#import "DifferAccount.h"
#import "DiffUtil.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SVProgressHUD.h>
#import "AccountNetwork.h"


//static DifferAccount *_account;
@implementation DifferAccountTool
+ (void)saveAccount:(DifferAccount *)account
{
    BOOL result =  [NSKeyedArchiver archiveRootObject:account toFile:[DiffUtil getAccountPathAtDocument]];
    if (!result) {
        NSLog(@"归档失败");
    }
    
}


+ (DifferAccount *)account
{
    DifferAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getAccountPathAtDocument]];

    
    if ([[NSDate date] compare:account.expires_date] == NSOrderedDescending) { // 过期
    
        //刷新token未过期去刷新token
        if (!([[NSDate date] compare:account.refresh_token_expires_date] == NSOrderedDescending)){
            
//            NSString *urlStr = @"http://passport.test.appgame.com/oauth/access_token";
            NSString *urlStr = [NSString stringWithFormat:@"%@/oauth/access_token",user_base_service];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
            request.HTTPMethod = @"POST";
            
            NSString *bodyStr = [NSString stringWithFormat:@"grant_type=%@&client_id=%@&client_secret=%@&refresh_token=%@",@"refresh_token",differ_client_id,differ_client_secret,account.refresh_token];
            request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
            
            NSHTTPURLResponse *response = nil;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                            
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDict = [DiffUtil dictionaryWithJsonString:dataStr];
            if (responseDict[@"error"]) {//刷新token失败
                
                return account;
            }
            
            account = [DifferAccount accountWithDic:responseDict];
            
            [self saveAccount:account];
            
            return account;
            

        }else{
            
            [self deleteAccount];//刷新token也过期了，就需要重新登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
            [SVProgressHUD showInfoWithStatus:@"账号已过期，请重新登录！"];
            return nil;
        }
        
        
        
    }
    
    
    return account;

}

// 退出登录，删除本地账户
+ (BOOL)deleteAccount
{
    NSFileManager *manage = [NSFileManager defaultManager];
    NSString *accountPath = [DiffUtil getAccountPathAtDocument];
    NSString *avataPath = [DiffUtil getAccountAvataPath];
    NSString *userPath = [DiffUtil getUserPathAtDocument];
    NSString *searchGameListPath = [DiffUtil getSearchGameIdsPath];
    
    BOOL result1 = NO;
    BOOL result2 = NO;
    BOOL result3 = NO;
    BOOL result4 = NO;
    
    if ([manage fileExistsAtPath:accountPath]) {
        result1 = [manage removeItemAtPath:accountPath error:nil];
        if (!result1) {
            NSLog(@"删除账户数据失败");
        }
    }
    
    if ([manage fileExistsAtPath:avataPath]) {
        result2 = [manage removeItemAtPath:avataPath error:nil];
        if (!result2) {
            NSLog(@"删除头像失败");
        }
    }
    
    if ([manage fileExistsAtPath:userPath]) {
        result3 = [manage removeItemAtPath:userPath error:nil];
        if (!result3) {
            NSLog(@"删除用户数据失败");
        }
    }
    
    if ([manage fileExistsAtPath:searchGameListPath]) {
        result4 = [manage removeItemAtPath:searchGameListPath error:nil];
        if (!result4) {
            NSLog(@"删除用户探索的游戏数据失败");
        }
    }
    
    
    return (result1 && result2 && result3 && result4);
}


+ (void)downloadAvata:(NSURL *)avata
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:avata options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [self savaAvata:image];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
    }];
}

+ (void)savaAvata:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    NSString *path = [DiffUtil getAccountAvataPath];
    BOOL result = [data writeToFile:path atomically:YES];
    NSLog(@"%d",result);
}

+ (UIImage *)getAvata
{
    UIImage *image = [UIImage imageWithContentsOfFile:[DiffUtil getAccountAvataPath]];
    if (image == nil) {
        image = [UIImage imageNamed:@"menu_user_default"];
    }
    return image;
}



@end
