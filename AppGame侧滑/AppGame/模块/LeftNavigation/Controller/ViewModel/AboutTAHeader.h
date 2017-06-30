//
//  AboutTAHeader.h
//  AppGame
//
//  Created by zengchunjun on 2017/6/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface AboutTAHeader : UIView

@property (nonatomic,strong)UserModel *user;

@property (nonatomic,assign)NSInteger guestCount;

@end
