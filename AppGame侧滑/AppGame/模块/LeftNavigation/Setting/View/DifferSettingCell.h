//
//  EcmSettingCell.h
//  ecmSetting
//
//  Created by zengchunjun on 16/12/2.
//  Copyright © 2016年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DifferSettingItem;
@interface DifferSettingCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)DifferSettingItem *item;

@end
