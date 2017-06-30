//
//  UILabel+Extension.h
//  AppGame
//
//  Created by supozheng on 2017/5/25.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
//设置行间距
-(void)setLabelLineSpace:(NSString*)str spacing:(float)spacint withFont:(UIFont*)font;
//增加彩色用户名
-(void)setLabelLineSpace:(NSString*)str spacing:(float)spacint withFont:(UIFont*)font userName:(NSString *)userName;
@end
