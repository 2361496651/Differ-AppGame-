//
//  CommentPageBelowCell.h
//  AppGame
//
//  Created by chan on 17/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "ReplyModel.h"

@protocol CommentPageBelowCelllDelegate

-(void)clickCellCommentCount:(NSString*)userName commentModel:(CommentModel*)commentModel;
-(void)clickOpenConment:(CommentModel*)comment;
-(void)clickCommentReply:(ReplyModel*)reply commentModel:(CommentModel*)commentModel;
-(void)clickHeadIcon:(NSString*)userId;
@end


@interface CommentPageBelowCell : UITableViewCell
@property(nonatomic,strong)CommentModel *commentModel;

@property(nonatomic)id<CommentPageBelowCelllDelegate> delegate;

-(float)getBelowCellCommentReplyHeight;

@end
