//
//  DiffBaseNetwork.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DiffBaseNetwork.h"
#import "NSError+DfExtension.h"

@implementation DiffBaseNetwork
//static DifferNetwork *diffeNetwork;
//+ (instancetype)shareInstance
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        diffeNetwork = [DifferNetwork manager];
//        diffeNetwork.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,nil];
//
//    });
//    return diffeNetwork;
//}

// get请求
- (RACSignal*)getOfDiffer:(NSString *)url params:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) {
                NSDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                NSArray *array = [errorInfo arrayForKey:@"errors"];
                NSUInteger errorCode = 0;
                NSString *notice;
                for (NSDictionary *dic in array) {
                    errorCode = [dic integerForKey:@"code"];
                    notice = [dic objectForKey:@"title"];
                }
                if (errorCode && notice) {
                    NSLog(@"【服务器返回】：%ld,%@",errorCode,notice);

                    [subscriber sendError:[NSError df_errorWithCode:errorCode description:notice]];
                }else{
                    [subscriber sendError:[NSError df_errorWithCode:-1 description:@"未知错误"]];
                }
                
            }else{
                [subscriber sendError:[NSError df_errorWithCode:-1 description:@"未知错误"]];
            }
        }];
        return nil;
    }];
}

// post请求
- (RACSignal *)postOfDiffer:(NSString *)url params:(NSDictionary *)params
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) {
                NSDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                NSArray *array = [errorInfo arrayForKey:@"errors"];
                NSUInteger errorCode = 0;
                NSString *notice;
                for (NSDictionary *dic in array) {
                    errorCode = [dic integerForKey:@"code"];
                    notice = [dic objectForKey:@"title"];
                }
                if (errorCode && notice) {
                    [subscriber sendError:[NSError df_errorWithCode:errorCode description:notice]];
                }else{
                    [subscriber sendError:[NSError df_errorWithCode:-1 description:@"未知错误"]];
                }
                
            }else{
                [subscriber sendError:[NSError df_errorWithCode:-1 description:@"未知错误"]];
            }
        }];
        return nil;
    }];
}

- (void)updateImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传文件
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 AFHTTPSessionManager *sessionManager = [DifferNetwork shareInstance];
 //JSON
 AFHTTPRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
 [sessionManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
 // 上传文件
 NSData *imageData = UIImageJPEGRepresentation(image, 1);
 
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 formatter.dateFormat = @"yyyyMMddHHmmss";
 NSString *str = [formatter stringFromDate:[NSDate date]];
 NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
 
 [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg"];
 } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 NSLog(@"%@",responseObject);
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 NSLog(@"%@",error);
 }];
 */


@end
