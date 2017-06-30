//
//  CommentsDetailCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyModel;
@class CommentsDetailCell;
@class CommentModel;



@interface CommentsDetailCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)ReplyModel *reply;




@end
