//
//  AttentionCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttentionModel;
@class AttentionCell;

@protocol AttentionCellDelegate <NSObject>

@optional
// 点击了头像
- (void)attentionCellClickIconImage:(AttentionCell *)attentionCell attentionModel:(AttentionModel *)attention;
// 点击了游戏名
- (void)attentionCellClickGameName:(AttentionCell *)attentionCell attentionModel:(AttentionModel *)attention;

@end

@interface AttentionCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)AttentionModel *attention;

@property (nonatomic,assign)id<AttentionCellDelegate> delegate;

@end
