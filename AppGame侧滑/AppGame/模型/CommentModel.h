//
//  CommentModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/28.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class UserModel;

@interface CommentModel : NSObject

@property (nonatomic,copy)NSString *uid;

@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *replied;
@property (nonatomic,copy)NSString *thumbs_up;
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *is_thumb;

@property (nonatomic,strong)NSArray *replies;

@property (nonatomic,strong)UserModel *user;


//游戏评论使用，点赞数
@property (nonatomic, copy)NSString *comment_thumbs_up;
@property (nonatomic, copy)NSString *commented;

// differ日报中有使用到
// 评论头部高度
@property (nonatomic,assign)CGFloat headerHeight;
// 展开与收起回复，服务端并没有这个字段，
@property (nonatomic,assign)BOOL isFold;

@end
