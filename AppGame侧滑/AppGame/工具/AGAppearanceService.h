//
//  AppearanceService.h
//  LittleGame
//
//  Created by Mao on 14-8-22.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import "DfBaseManager.h"

/**
 *  外观服务
 */
@interface AGAppearanceService : DfBaseManager
+ (void)setDefaultAppearanceSetting;
@end

@interface UIColor (AGAppearance)
//墨黑色的主题
+ (UIColor*)ag_MAIN;
+ (UIColor*)ag_G0;
+ (UIColor*)ag_G1;
+ (UIColor*)ag_G2;
+ (UIColor*)ag_G3;
+ (UIColor*)ag_G4;
+ (UIColor*)ag_G5;
+ (UIColor*)ag_G6;
+ (UIColor*)ag_G7;

+ (UIColor*)ag_P1;
+ (UIColor*)ag_P2;

+ (UIColor*)ag_R1;

+ (UIColor*)ag_W1;

//画圆的线的背景颜色
+ (UIColor*)di_Circle1;
//绿色，主要显示文字
+ (UIColor*)di_MAIN2;
//页面的背景浅灰色
+ (UIColor*)di_Page1;
@end

@interface UIFont (AGAppearance)
+ (UIFont*)ag_lightFontOfSize:(NSInteger)size;
+ (UIFont*)ag_regularFontOfSize:(NSInteger)size;
+ (UIFont*)ag_mediumFontOfSize:(NSInteger)size;
@end
