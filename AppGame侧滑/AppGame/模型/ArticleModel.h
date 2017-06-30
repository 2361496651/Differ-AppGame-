//
//  ArticleModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@class TagsModel;


@interface ArticleModel : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSURL *cover;

@property (nonatomic,copy)NSString *descript;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSString *taged;
@property (nonatomic,copy)NSString *commented;

@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *updated_at;

@property (nonatomic,copy)NSString *tags_thumbs_up;//标签数
@property (nonatomic,strong)NSArray *tags;

@property (nonatomic,strong)UserModel *user;

@property (nonatomic,strong)NSURL *url;

@end
