//
//  ReplyModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/28.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ReplyModel : NSObject

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *is_replied;
@property (nonatomic,copy)NSString *reply_id;
@property (nonatomic,copy)NSString *reply_user_id;
@property (nonatomic,copy)NSString *created_at;

@property (nonatomic,strong)UserModel *user;

@property (nonatomic,assign)CGFloat cellHeight;

@end
