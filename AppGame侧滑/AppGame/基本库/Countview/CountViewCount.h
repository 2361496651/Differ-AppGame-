//
//  CountViewCount.h
//  supozheng
//
//  Created by supozheng on 17/5/15.
//
//


#import "POPBasicAnimation.h"

@protocol NumberCountDelegate <NSObject>

@optional

/**
 *  子类可以实现的方法
 *
 *  @param string      子类返回的富文本
 */
- (void)numberCount:(NSAttributedString *)string;

@end

//---------------------------------------------

@interface CountViewCount : NSObject


/**
 *  初始值
 */
@property (nonatomic) CGFloat fontSize;

/**
 *  初始值
 */
@property (nonatomic) CGFloat fromValue;

/**
 *  结束值
 */
@property (nonatomic) CGFloat toValue;

/**
 *  动画实体
 */
@property (nonatomic, strong) POPBasicAnimation *conutAnimation;


/**
 *  动画持续时间
 */
@property (nonatomic) CGFloat duration;

/**
 *  代理
 */
@property (nonatomic, weak) id<NumberCountDelegate> delegate;


- (void)startAnimation;

//文本处理
- (NSAttributedString *)accessNumber:(float )number;

@end
