//
//  DailyDetailFooter.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsDetailCell;
@class CommentModel;
@class DailyDetailFooter;

@protocol DailyDetailFooterDelegate <NSObject>

- (void)DailyDetailFooterCell:(DailyDetailFooter *)commentCell moreCommentClick:(CommentModel *)comment;

@end

@interface DailyDetailFooter : UITableViewHeaderFooterView

@property (nonatomic,weak)id<DailyDetailFooterDelegate> delegate;

//@property (nonatomic,copy)NSString *showContent;

@property (nonatomic,strong)CommentModel *comment;

@end
