//
//  DynamicsVC.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface DynamicsVC : BaseTableViewController

@property (nonatomic,copy)NSString *userId;
//@property (nonatomic,strong)UserModel *user;
@property (nonatomic,assign)BOOL isMyself;

@end
