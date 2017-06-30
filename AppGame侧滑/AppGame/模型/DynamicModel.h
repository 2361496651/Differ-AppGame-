//
//  DynamicModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameModel;
@class UserModel;
@class DynamicModel;

@interface DynamicModel : NSObject

@property (nonatomic,copy)NSString *uid;

@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *commented;
@property (nonatomic,copy)NSString *thumbs_up;
@property (nonatomic,copy)NSString *shared;
@property (nonatomic,copy)NSString *created_at;

@property (nonatomic,strong)NSArray *images;

@property (nonatomic,copy)NSString *is_forward;//是否转发

@property (nonatomic,copy)NSString *is_thumb;

@property (nonatomic,strong)GameModel *game;
@property (nonatomic,strong)UserModel *author;
@property (nonatomic,strong)DynamicModel *forward;

@property (nonatomic,assign)CGFloat cellHeight;

@end
