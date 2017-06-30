//
//  DailyModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ArticleModel;
@class TopicModel;

@interface DailyModel : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *target; // 两种类型 article topic ,决定了使用下面的文章或主题
@property (nonatomic,copy)NSString *target_id;
@property (nonatomic,copy)NSString *published_at;


@property (nonatomic,strong)ArticleModel *article;
@property (nonatomic,strong)TopicModel *topic;


@property (nonatomic,assign)CGFloat cellHeight;





@end
