//
//  ViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/14.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self testCocoapodsNetwork];
}

-(void)testCocoapodsNetwork
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES; // 允许未知的证书
    manager.securityPolicy.validatesDomainName = NO; // 允许未知的域名
    
    //    [manager GET:@"http://httpbin.org/get?userName=zengchunjun&password=123" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSLog(@"NSThread:%@ \n Class:%@ \n result:%@",[NSThread currentThread],[responseObject class],responseObject);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"请求错误：%@",error);
    //    }];
    
    [manager GET:@"https://httpbin.org/get?show_env=1" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"NSThread:%@ \n Class:%@ \n result:%@",[NSThread currentThread],[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求错误：%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
