//
//  AGFile.m
//  AGVideo
//
//  Created by Mao on 16/4/15.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "AGFile.h"

@implementation AGFile
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"url": @"url",
             @"objectId": @"id",
             };
}
- (void)getDataInBackgroundWithBlock:(AGDataResultBlock)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:self.url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            if (block) {
                block(responseObject, nil);
            }
        }
        else{
//            block(nil, [NSError ag_errorWithCode:AGErrorCodeInvalidFormat]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (void)getThumbnail:(BOOL)scaleToFit
               width:(int)width
              height:(int)height
           withBlock:(AGImageResultBlock)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[self getThumbnailURLWithScaleToFit:scaleToFit width:width height:height] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            UIImage *aImage = [UIImage imageWithData:responseObject];
            if (aImage) {
                if (block) {
                    block(aImage, nil);
                }
            }else{
//                block(nil, [NSError ag_errorWithCode:AGErrorCodeInvalidFormat]);
            }
        }
        else{
//            block(nil, [NSError ag_errorWithCode:AGErrorCodeInvalidFormat]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (NSString *)getThumbnailURLWithScaleToFit:(BOOL)scaleToFit
                                      width:(int)width
                                     height:(int)height{
    if (scaleToFit) {
        return [NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d", self.url,width, height];
    }
    return [NSString stringWithFormat:@"%@?imageView2/2/w/%d", self.url,width];
}
@end
