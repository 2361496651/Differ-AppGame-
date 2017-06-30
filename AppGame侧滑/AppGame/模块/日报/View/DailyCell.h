//
//  DailyCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyModel.h"

@interface DailyCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)DailyModel *dailyModel;

@property (nonatomic,assign)BOOL isHiddenBgView;//只有第一个不隐藏，

@end
