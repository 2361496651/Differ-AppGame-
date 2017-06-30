//
//  UserModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "RankModel.h"
// 用户模型
@interface UserModel : NSObject

@property (nonatomic,copy)NSString *uid;// 用户id

@property (nonatomic,copy)NSString *username;// 用户名
@property (nonatomic,copy)NSString *nickname;// 昵称
@property (nonatomic,copy)NSURL *avatar;//"http://games-plante.dev/?t=1492485474",
@property (nonatomic,copy)NSString *sex;  //性别；0未知，1男，2女
@property (nonatomic,copy)NSString *birthday;//生日格式 1990-11-11
@property (nonatomic,copy)NSString *remark; //个人签名
@property (nonatomic,assign)NSInteger follower; //粉丝数
@property (nonatomic,assign)NSInteger following; //关注数
@property (nonatomic,assign)NSInteger public_follower; //是否公开粉丝；0否，1是
@property (nonatomic,assign)NSInteger public_following;//是否公开关注；0否，1是

@property (nonatomic,copy)NSString *is_followed;// 是否已关注

@property (nonatomic,strong)RankModel *rank; // 头衔
@property (nonatomic,strong)NSArray *achieves;//徽章



@end






