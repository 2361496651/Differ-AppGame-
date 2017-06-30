//
//  GameDetailModel.h
//  AppGame
//
//  Created by chan on 17/5/16.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDetailModel : NSObject

@property(nonatomic, copy)NSString *uid;
@property(nonatomic, copy)NSString *type;

@property (nonatomic,copy)NSString *game_name_cn;
@property (nonatomic,copy)NSString *game_name_en;
@property (nonatomic,copy)NSString *avg_appraise_star;

@property (nonatomic,copy)NSString *intro; // 游戏介绍
@property (nonatomic,copy)NSString *describe;

@property (nonatomic,copy)NSURL *icon;
@property (nonatomic,strong)NSArray *picArray;
@property (nonatomic,strong)NSArray *downLinkArray;
@property (nonatomic,strong)NSArray *tagArray;
@property (nonatomic,strong)NSArray *relayGameArray;

@end
