//
//  GlobelConst.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/14.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

/*******************宏定义*********************/

#define SETVIEWCONTROLLERNOINSETS                                                  \
if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) \
{                                                                                  \
self.automaticallyAdjustsScrollViewInsets = NO;                                \
}                                                                                  \
if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])               \
{                                                                                  \
self.edgesForExtendedLayout = UIRectEdgeNone;                                  \
}


/*******************API接口*********************/

// 客户端在 SDK 服务器注册的 id
extern NSString *const differ_client_id;
extern NSString *const differ_client_secret;

// baseURL
extern NSString *const user_base_service;
extern NSString *const differ_base_service;


/*******************偏好设置*********************/
// 启动动画
extern NSString * const gifAnimation;

// 保存最新探索到的游戏ID，在主页请求数据时作为参数发送给服务器
extern NSString *const lastSearchGameId;

// 保存游戏探索的剩余探索次数，每天限定为5次
extern NSString *const lastSearchCount;

extern NSString * const remoteNotification;
// 探索设置索引
extern NSString *const searchSettingIndex;

// 版本记录
extern NSString *const differNewVersionKey;

/*******************通知名*********************/

// 动态 图片放大的通知
extern NSString *const ShowPhotoBrowserNote;

// 图片放大通知中保存的信息key
extern NSString *const ShowPhotoBrowserIndexKey;
extern NSString *const ShowPhotoBrowserUrlsKey;
