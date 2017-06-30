//
//  TopicModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface TopicModel : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *uid;

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,strong)NSURL *cover;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *layout;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSString *taged;
@property (nonatomic,copy)NSString *commented;
@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *bg_color;
@property (nonatomic,copy)NSString *font_color;

@property (nonatomic,strong)NSArray *games;

@property (nonatomic,strong)UserModel *user;




@end
