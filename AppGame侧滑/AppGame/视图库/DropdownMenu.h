//
//  DropdownMenu.h
//  AppGame
//
//  Created by chan on 17/5/15.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenu;

@protocol DropdownMenuDelegate <NSObject>
// 当选择某个选项时调用
-(void)dropdownMenu:(DropdownMenu *)menu selectedCellNumber:(NSInteger)number;

@end

@interface DropdownMenu : UIView

@property(nonatomic,assign)id<DropdownMenuDelegate>delegate;

- (void)setMenuTitles:(NSArray *)titlesArr;  // 设置下拉菜单控件标题

- (void)showDropDown; // 显示下拉菜单
- (void)hideDropDown; // 隐藏下拉菜单

@end
