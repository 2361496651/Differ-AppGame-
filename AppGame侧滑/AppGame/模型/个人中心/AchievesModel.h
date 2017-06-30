//
//  AchievesModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

//徽章模型

@interface AchievesModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSURL *icon;
@property (nonatomic,copy)NSString *status;//是否展示

@end
