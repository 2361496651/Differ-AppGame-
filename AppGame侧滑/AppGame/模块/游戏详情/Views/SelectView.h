//
//  SelectView.h
//  AppGame
//
//  Created by chan on 17/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectView;

@protocol SelectViewDelegate <NSObject>

@optional
//当按钮点击时通知代理
- (void)selectView:(SelectView *)selectView didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

- (void)selectView:(SelectView *)selectView didChangeSelectedView:(NSInteger)to;
@end

@interface SelectView : UIView

@property(nonatomic, weak) id <SelectViewDelegate> delegate;

//提供给外部一个可以滑动底部line的方法
- (void)lineToIndex:(NSInteger)index;

@end
