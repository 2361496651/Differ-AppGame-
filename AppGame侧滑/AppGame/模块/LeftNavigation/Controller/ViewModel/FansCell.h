//
//  FansCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttentionModel;
@class FansCell;

@protocol fansCellDelegate <NSObject>

@optional
- (void)fansCellClickIconImage:(FansCell *)fansCell attentionModel:(AttentionModel *)fans;

@end

@interface FansCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)AttentionModel *fans;

@property (nonatomic,assign)id<fansCellDelegate> delegate;

@end
