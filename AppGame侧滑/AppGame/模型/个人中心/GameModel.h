//
//  GameModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@class AppraisePoints;

// 游戏模型
@interface GameModel : NSObject

@property (nonatomic,copy)NSString *uid;

@property (nonatomic,copy)NSString *game_id;

@property (nonatomic,copy)NSString *game_name_cn;
@property (nonatomic,copy)NSString *game_name_en;

@property (nonatomic,copy)NSString *game_name_alias;

@property (nonatomic,copy)NSString *avg_appraise_star;

@property (nonatomic,copy)NSString *recommend_reason;// 推荐理由
@property (nonatomic,copy)NSURL *icon;

@property (nonatomic,copy)NSString *intro; // 游戏介绍
@property (nonatomic,copy)NSString *describe;

@property (nonatomic,copy)NSString *publisher;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *activity_label;
@property (nonatomic,copy)NSString *activity_url;
@property (nonatomic,copy)NSString *update_info;
@property (nonatomic,copy)NSString *updated_at;
@property (nonatomic,copy)NSString *origin_updated_at;



@property (nonatomic,strong)NSArray *categoryArray; // 注意数组中还需要转换成相应模型

@property (nonatomic,strong)NSArray *downLinkArray; // 注意数组中还需要转换成相应模型

@property (nonatomic,strong)NSArray *tags;
@property (nonatomic,strong)NSArray *pics;
@property (nonatomic,strong)NSArray *relay_games;

//todo: appraise_points
@property (nonatomic,strong)AppraisePoints *appraise_points;

@property (nonatomic,strong)NSURL *video;

@property (nonatomic,strong)NSURL *cover;

@property (nonatomic,strong)UserModel *user;

//服务端暂时没有这个字段
@property (nonatomic,copy)NSString *isCollect;//是否已经喜欢 1:喜欢  0:未喜欢

@property (nonatomic,assign)CGFloat cellHeight;// differ日报里面的topic类型 详情页有用到

@end
