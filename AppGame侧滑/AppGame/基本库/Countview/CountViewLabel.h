//
//  CountViewLabel.h
//  AppGame
//
//  Created by supozheng on 17/5/15.
//
//

#import <UIKit/UIKit.h>
#import "CountViewCount.h"

@interface CountViewLabel : UIView


@property (nonatomic) CGFloat fontSize;

/**
 *  起始值
 */
@property (nonatomic) CGFloat fromValue;

/**
 *  结束值
 */
@property (nonatomic) CGFloat toValue;

/**
 *  动画引擎
 */
@property (nonatomic, strong) CountViewCount   *count;

/**
 *  显示用的label
 */
@property (nonatomic, strong) UILabel         *countLabel;

/**
 *  显示动画
 *
 *  @param duration 动画时间
 */
- (void)showDuration:(CGFloat)duration animated:(BOOL)animated;

/**
 *  隐藏动画
 *
 *  @param duration 隐藏时间
 */
- (void)hideDuration:(CGFloat)duration;

@end
