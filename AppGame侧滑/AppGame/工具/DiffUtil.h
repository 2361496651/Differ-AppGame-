//
//  DiffUtil.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

typedef enum
{
    clickResultYes,
    clickResultNo,
    clickResultCancel,
    
}ClickResult;

typedef void(^AlertCallback)(ClickResult result);


@interface DiffUtil : NSObject

+ (UIColor *)getDifferColor;
+ (UIFont *)getDifferFont:(CGFloat)size;

+ (NSString *)dateStrWithYMD;

// 创建导航控制器
+ (UINavigationController *)initNavigationWithRootViewController:(UIViewController *)viewController;
//创建导航栏item
+ (UIBarButtonItem *)initButtonItemWithTitle:(NSString *)title action:(SEL)target delegate:(id)delegate;
+ (UIBarButtonItem *)initButtonItemWithImage:(NSString *)image action:(SEL)target delegate:(id)delegate;

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message presenViewController:(UIViewController *)viewController;

+ (void)showTwoAlertControllerWithTitle:(NSString *)title message:(NSString *)message presenViewController:(UIViewController *)viewController callBack:(AlertCallback)alerCallback;
+ (void)showThreeAlertControllerWithTitle:(NSString *)title message:(NSString *)message presenViewController:(UIViewController *)viewController callBack:(AlertCallback)alerCallback;

// base64编码后的字符串
+ (NSString *)encodingBase64WithOriginStr:(NSString *)originStr;
// base64解码后的字符串
+ (NSString *)decodingBase64WithEncodingStr:(NSString *)encodingStr;

// 字典转json字符串
+ (NSString *)jsonStringWithDict:(NSDictionary *)dict;
//json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


// 获取 设备与应用绑定 的唯一标识
+ (NSString *)getIdentifierForVendor;

// UUID是一个32位的十六进制序列，UUID再某一时空下是唯一的
+ (NSString *)getUUID;

// 创建/获取 账户路径
+ (NSString *)getAccountPathAtDocument;
+ (NSString *)getUserPathAtDocument;
//用户头像路径
+ (NSString *)getAccountAvataPath;

//每日探索到的游戏ID
+ (NSString *)getSearchGameIdsPath;
// 删除保存的游戏ID
+ (void)removeSearchGameIds;

// 获取探索游戏id字符串，多个用，隔开
+ (NSString *)getSearchGameIdString;

//获取当前版本
+ (NSString *)getCurrentVersion;


// 改变头像尺寸
+ (UIImage *)resizeImageToUpdaloadAvata:(UIImage *)image;



/**
 *  短暂显示在底部的提示框
 *
 *  @param title           提示的内容
 *  @param backgroundColor 提示框的背景颜色,默认为黑色
 *  @param textColor       提示文本的颜色，默认为白色
 *
 */
+ (void)showInBottomWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;

+ (void)showInCenterWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;

+ (void)showInTopWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;


/**
 *  返回一段文字在指定字体和宽度的情况下的大小
 *
 *  @param text     文字
 *  @param width    显示的宽度
 *  @param textFont 文字的字号
 *
 *  @return 返回CGSize
 */
+ (CGSize)sizeWithText:(NSString *)text width:(CGFloat)width textFont:(CGFloat)textFont;


+ (UIColor *)colorWithHexString: (NSString *)color;

+ (void)monitorNetwork:(void(^)(AFNetworkReachabilityStatus status))reach;


// 判断是否登录 ，未登录直接弹出登录界面
+ (BOOL)judgIsLoginWithViewController:(UIViewController *)viewControll;

// 判断是否是手机号码
+ (BOOL)judgePhoneNumber:(NSString *)phoneNum;

// 获取当前的viewcontroller
+ (UIViewController*)currentViewController;

//标签数量限制
+ (NSString *)tagCountLimitWithCount:(NSInteger)count;

@end
