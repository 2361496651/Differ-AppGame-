//
//  EcmSettingBaseTVC.h
//  ecmSetting
//
//  Created by zengchunjun on 16/12/2.
//  Copyright © 2016年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DifferSettingGroup;

@interface DifferSettingBaseTVC : UITableViewController

//  数据源
@property (nonatomic,strong)NSMutableArray<DifferSettingGroup *> *cellDatas;

@end
