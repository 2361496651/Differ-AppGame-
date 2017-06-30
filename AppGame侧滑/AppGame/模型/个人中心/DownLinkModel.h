//
//  DownLinkModel.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
// 游戏下载模型
@interface DownLinkModel : NSObject

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *platform;
@property (nonatomic,copy)NSString *lang;
@property (nonatomic,copy)NSString *size;
@property (nonatomic,copy)NSString *version;
@property (nonatomic,strong)NSURL *link;
@property (nonatomic,copy)NSString *package_name;

@end
