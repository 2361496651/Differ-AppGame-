//
//  AppraiseModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TagsModel;
@class GameModel;
@class UserModel;

// 个人中心评论 模型
@interface AppraiseModel : NSObject

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *star;
@property (nonatomic,copy)NSString *taged;
@property (nonatomic,copy)NSString *commented;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *thumbs_up;
@property (nonatomic,copy)NSString *thumbs_down;
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *updated_at;
@property (nonatomic,copy)NSString *comment_count;
@property (nonatomic,copy)NSString *is_thumb;

@property (nonatomic,strong)NSArray *tags;

@property (nonatomic,strong)GameModel *game;

@property (nonatomic,strong)UserModel *author;

@property (nonatomic,assign)CGFloat cellHeight;


@end









