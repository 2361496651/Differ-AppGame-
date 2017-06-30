//
//  GameServices.h
//  AppGame
//
//  Created by supozheng on 2017/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户收藏游戏类型
static const NSString *GAME_ACTION_TYPE_INSTALLED = @"installed";//已安装
static const NSString *GAME_ACTION_TYPE_PLAYED = @"played"; //已玩过
static const NSString *GAME_ACTION_TYPE_LIKED = @"liked"; //喜欢

@interface GameServices : NSObject

+ (instancetype)shareInstance;


-(void)commentThumbWithCommentId:(NSString*)commentId type:(NSString*)type;
- (void)addTagOrCommentWithTarget:(NSString *)target targetId:(NSString *)targetId name:(NSString *)content isTag:(BOOL)isTag isSuccess:(void(^)(BOOL))isSuccess failure:(void(^)(NSError *error ,NSUInteger code,NSString *notice))failure;
@end
