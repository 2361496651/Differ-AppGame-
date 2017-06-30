//
//  GameServices.m
//  AppGame
//
//  Created by supozheng on 2017/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameServices.h"
#import "DifferNetwork.h"
#import "GameListGroup.h"
#import <MJExtension.h>
#import "DiffUtil.h"
#import "DifferNetwork.h"

@implementation GameServices

static GameServices *g_services;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_services = [[GameServices alloc] init];
        
    });
    return g_services;
}


-(void)commentThumbWithCommentId:(NSString*)appraiseId type:(NSString*)type{
    
    [[[DifferNetwork shareInstance] postThumb:appraiseId type:@"1" isCancel:@"0" ]subscribeNext:^(id x) {
        NSLog(@"喜欢评论成功");
    } error:^(NSError *error) {
        NSLog(@"喜欢评论失败");
    }];

}

- (void)addTagOrCommentWithTarget:(NSString *)target targetId:(NSString *)targetId name:(NSString *)content isTag:(BOOL)isTag isSuccess:(void(^)(BOOL))isSuccess failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure{
    
    [[[DifferNetwork shareInstance] addTagOrCommentWithTarget:target targetId:targetId name:content isTag:isTag] subscribeNext:^(id x) {
        NSLog(@"用户评论成功");
        isSuccess(YES);
    } error:^(NSError *error) {
        failure(error,[error code],[error description]);
    }];
}


@end
