//
//  CategoryModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

// 游戏分类模型
@interface CategoryModel : NSObject

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSURL *icon;

@end
