//
//  RankModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

//头衔模型

@interface RankModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *uid;

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSURL *icon;

@end
