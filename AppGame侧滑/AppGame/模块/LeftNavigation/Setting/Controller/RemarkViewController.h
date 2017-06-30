//
//  RemarkViewController.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/8.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^RemarkCompleteBlock)(NSString *remark);

@interface RemarkViewController : UIViewController

@property (nonatomic,copy)NSString *remark;

//block回调给设置界面，修改数据展示
@property (nonatomic,strong)void(^RemarkCompleteBlock)(NSString *remark);

@end
