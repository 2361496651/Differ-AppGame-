//
//  ViewFactory.h
//  AppGame
//
//  Created by supozheng on 2017/5/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTextView.h"

@interface ViewFactory : NSObject

+(UIView*)createView:(UIView*)ParentView backgroundColor:(UIColor*)backgroundColor;

+(UIView*)createLineView:(UIView*)ParentView;

+(UIView*)createCircleView:(UIView*)ParentView backgroundColor:(UIColor*)backgroundColor size:(CGSize)size;

+(UIView*)createEmptyCircleView:(UIView*)ParentView borderColor:(UIColor*)borderColor size:(CGSize)size borderWidth:(CGFloat)borderWidth;

+(UILabel*)createLabel:(UIView*)ParentView fontSize:(CGFloat)fontSize text:(NSString*)text textcolor:(UIColor*)textcolor;

+(UIButton*)createButton:(UIView*)ParentView titleColor:(UIColor*)titleColor titleLabelFontSize:(CGFloat)fontSize title:(NSString*)title;

+(UITextField*)createTextField:(UIView*)ParentView holder:(NSString*)holder textFontSize:(CGFloat)textFontSize;

+(SZTextView*)createTextView:(UIView*)ParentView holder:(NSString*)holder textFontSize:(CGFloat)textFontSize;

+(UITableView*)createTabelView:(id<UITableViewDataSource>)sourceDelegate delegate:(id <UITableViewDelegate>)delegate;
@end
