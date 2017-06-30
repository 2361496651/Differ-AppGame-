//
//  CJNavigationController.h
//  Personal Application
//
//  Created by  zengchunjun on 16/3/14.
//  Copyright © 2016年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJNavigationController : UINavigationController

//设置一个属性保存系统的代理
@property (nonatomic, strong) id popDelegate;

@end
