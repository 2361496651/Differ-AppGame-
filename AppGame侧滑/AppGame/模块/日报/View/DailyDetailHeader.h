//
//  DailyDetailHeader.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@class DailyDetailHeader;

@protocol DailyDetailHeaderDelegate <NSObject>

- (void)dailyDetailHeader:(DailyDetailHeader *)header iconClick:(CommentModel *)comment;
- (void)dailyDetailHeader:(DailyDetailHeader *)header likeClick:(CommentModel *)comment;
- (void)dailyDetailHeader:(DailyDetailHeader *)header commentClick:(CommentModel *)comment;


@end

@interface DailyDetailHeader : UITableViewHeaderFooterView

@property (nonatomic,strong)CommentModel *comment;

@property (nonatomic,weak)id<DailyDetailHeaderDelegate> delegate;

@end
