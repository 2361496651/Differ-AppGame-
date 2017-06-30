//
//  TagsModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

// 游戏标签模型
@interface TagsModel : NSObject

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *tagName;

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *thumbs_up;
@property (nonatomic,copy)NSString *is_thumb;

@end
