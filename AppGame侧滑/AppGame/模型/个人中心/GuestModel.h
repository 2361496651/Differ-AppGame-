//
//  GuestModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/22.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;


// 留言模型
@interface GuestModel : NSObject

@property (nonatomic,copy)NSString *uid;

//@property (nonatomic,copy)NSString *parent_id;

@property (nonatomic,strong)UserModel *author;

@property (nonatomic,copy)NSString *is_thumb;//我是否对这条留言点赞

@property (nonatomic,copy)NSString *content;

@property (nonatomic,copy)NSString *thumbs_up;//点赞数

@property (nonatomic,strong)NSArray *childGuests;//子留言

@property (nonatomic,copy)NSString *created_at;//创建时间

@property (nonatomic,assign)CGFloat cellHeight;

@end
