//
//  GlobelConst.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/14.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>


/*******************API接口*********************/

//正式  客户端在 SDK 服务器注册的 id
//NSString *const differ_client_id = @"dad92827941075a0";
//NSString *const differ_client_secret = @"634d2518632ca421a796254f31950e6e";

//测试
NSString *const differ_client_id = @"shouyoushe";
NSString *const differ_client_secret = @"8da8d1d6b9f98229f4b465f68cd1a7c6";

//开关-正式与测试服务器

//用户系统 正式服务器地址
//NSString *const user_base_service = @"https://passport.appgame.com";
//用户系统 测试服务器地址
NSString *const user_base_service = @"http://passport.test.appgame.com";

//APP内部 正式服务器地址
//NSString *const differ_base_service = @"http://games-planet.4gvv.com";
//APP内部 测试服务器地址
NSString *const differ_base_service = @"http://games-planet.test.appgame.com";


/*******************偏好设置*********************/

NSString *const gifAnimation = @"GIFAnimationDate";

// 保存最新探索到的游戏ID，在主页请求数据时作为参数发送给服务器
NSString *const lastSearchGameId = @"lastSearchGameId";

// 保存游戏探索的剩余探索次数，每天限定为5次
NSString *const lastSearchCount = @"lastSearchCount";

NSString *const remoteNotification = @"remoteNotification";

NSString *const searchSettingIndex = @"searchSettingIndex";

// 版本记录
NSString *const differNewVersionKey = @"differNewVersionKey";


/*******************通知名*********************/

//动态 点击图片放大的通知
NSString *const ShowPhotoBrowserNote = @"ShowPhotoBrowserNote";

// 图片放大通知中保存的信息key
NSString *const ShowPhotoBrowserIndexKey = @"ShowPhotoBrowserIndexKey";
NSString *const ShowPhotoBrowserUrlsKey = @"ShowPhotoBrowserUrlsKey";

