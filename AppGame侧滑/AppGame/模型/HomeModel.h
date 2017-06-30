//
//  HomeModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameModel.h"


// 主页模型
@interface HomeModel : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *position;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *descrip;
@property (nonatomic,copy)NSString *display;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSString *extra_data;
@property (nonatomic,copy)NSString *published_type;
@property (nonatomic,copy)NSString *published_at;

@property (nonatomic,strong)GameModel *info;

@end
