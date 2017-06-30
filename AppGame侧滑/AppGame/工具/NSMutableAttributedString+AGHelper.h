//
//  NSMutableAttributedString+AGHelper.h
//  AGJointOperationSDK
//
//  Created by Mao on 16/3/3.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (AGHelper)
- (NSMutableAttributedString*(^)(UIFont*))ag_setFont;
- (NSMutableAttributedString*(^)(UIColor*))ag_setColor;
- (NSMutableAttributedString*(^)(UIColor*))ag_setBackgroundColor;
- (NSMutableAttributedString*(^)(NSString*))ag_addString;
@end

@interface NSString (AGAttributedString)
- (NSMutableAttributedString*)ag_toAttributedString;
@end
