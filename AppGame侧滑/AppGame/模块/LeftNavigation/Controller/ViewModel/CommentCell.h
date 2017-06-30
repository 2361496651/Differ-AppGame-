//
//  CommentCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/20.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppraiseModel;


@interface CommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,copy)AppraiseModel *appraise;



@end
