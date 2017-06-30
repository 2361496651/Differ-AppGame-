//
//  DynamicsCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/23.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DynamicModel;

@interface DynamicsCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)DynamicModel *dynamic;

@end
