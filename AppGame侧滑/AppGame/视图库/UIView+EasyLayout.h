//
//  UIView+AGAutoLayout.h
//  AGJointOperationSDK
//
//  Created by Mao on 16/3/2.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EL_INGNORE MAXFLOAT

@interface UIView (EasyLayout)
///block版约束函数
//el_constraintTo(NSLayoutAttributeTop, NSLayoutRelationEqual, imageView, NSLayoutAttributeBottom, 20, 0);
- (UIView*(^)(NSLayoutAttribute attr1, NSLayoutRelation relation, UIView *toView, NSLayoutAttribute attr2, CGFloat multiplier, CGFloat constant))el_constraintTo;

///self.attr = view.attr * 1 + constant
- (UIView*(^)(UIView *view, NSLayoutAttribute attr1, CGFloat constant))el_constantToAttribute;

///self..attr1 = view.attr2 * 1 + constant
- (UIView*(^)(NSLayoutAttribute attr1, UIView *view, NSLayoutAttribute attr2))el_attributeToAttribute;


///设置当前约束的identifier
- (UIView*(^)(NSString *identifier))el_identifier;

///设置当前约束的multiplier
- (UIView*(^)(CGFloat multiplier))el_multiplier;

///设置当前约束的constan
- (UIView*(^)(CGFloat constant))el_constant;

///设置优先级
- (UIView*(^)(UILayoutPriority priority))el_priority;

///设置约束关系。注意有部分约束是和系统约束函数的关系相反的。
- (UIView*(^)(NSLayoutRelation relation))el_relationInEL;

//------------------------------------------------------

///设置长宽约束
- (UIView*(^)(CGSize size))el_toSize;

///设置宽度约束
- (UIView*(^)(CGFloat width))el_toWidth;

///设置高度约束
- (UIView*(^)(CGFloat height))el_toHeight;

///self.width = view.width * multiplier
- (UIView*(^)(UIView *view, CGFloat multiplier))el_toWidthToWidth;

///self.height = view.height * multiplier
- (UIView*(^)(UIView *view, CGFloat multiplier))el_toHeightToHeight;

///self.width = view.height * multiplier
- (UIView*(^)(CGFloat multiplier))el_widthEqualToHeight;

///self.height = view.width * multiplier
- (UIView*(^)(CGFloat multiplier))el_heightEqualTowidth;

- (UIView*(^)(CGPoint offset))el_centreToSuperView;

//在父视图x轴
- (UIView*(^)(CGFloat offsetX))el_axisXToSuperView;
- (UIView*(^)(CGFloat offsetY))el_axisYToSuperView;

///中心对齐
- (UIView*(^)(UIView *view, CGPoint offset))el_centreTo;

///X轴对齐
- (UIView*(^)(UIView *view, CGFloat offsetX))el_axisXToAxisX;

///Y轴对齐
- (UIView*(^)(UIView *view, CGFloat offsetY))el_axisYToAxisY;

///约束self.top到view.top距离为distance
- (UIView*(^)(UIView *view, CGFloat distance))el_topToTop;

///约束self.left到view.left距离为distance
- (UIView*(^)(UIView *view, CGFloat distance))el_leftToLeft;

///约束self.bottom到view.bottom距离为distance
- (UIView*(^)(UIView *view, CGFloat distance))el_bottomToBottom;

///约束self.right到view.right距离为distance
- (UIView*(^)(UIView *view, CGFloat distance))el_rightToRight;

///约束self.top到view.bottom距离为distance
- (UIView*(^)(UIView *toView, CGFloat distance))el_topToBottom;

///约束self.left到view.right距离为distance
- (UIView*(^)(UIView *toView, CGFloat distance))el_leftToRight;

///约束self.right到view.left距离为distance
- (UIView*(^)(UIView *toView, CGFloat distance))el_rightToLeft;

///约束self.bottom到view.top距离为distance
- (UIView*(^)(UIView *toView, CGFloat distance))el_bottomToTop;

///约束self.top到self.superView.top距离为distance
- (UIView*(^)(CGFloat distance))el_topToSuperView;

///约束self.left到self.superView.left距离为distance
- (UIView*(^)(CGFloat distance))el_leftToSuperView;

///约束self.bottom到self.superView.bottom距离为distance
- (UIView*(^)(CGFloat distance))el_bottomToSuperView;

///约束self.right到self.superView.right距离为distance
- (UIView*(^)(CGFloat distance))el_rightToSuperView;

///约束self四周贴合self.superView的四周
- (UIView*(^)())el_edgesStickToSuperView;

///约束self到self.superView四周的边距
- (UIView*(^)(CGFloat topInset, CGFloat leftInset, CGFloat bottomInset, CGFloat rightInset))el_edgesToSuperView;

- (UIView*(^)(UIViewController * viewController))el_stickToTopLayoutGuide;
- (UIView*(^)(UIViewController * viewController))el_stickToBottomLayoutGuide;

- (UIView*(^)(UIViewController * viewController, CGFloat inset))el_closeToTopLayoutGuide;
- (UIView*(^)(UIViewController * viewController, CGFloat inset))el_closeToBottomLayoutGuide;

- (UIView*(^)(UIViewController * viewController, CGFloat inset, NSLayoutRelation relation))el_toTopLayoutGuide;
- (UIView*(^)(UIViewController * viewController, CGFloat inset, NSLayoutRelation relation))el_toBottomLayoutGuide;


@end

@interface UIView (EasyLayout_Helper)

- (NSLayoutConstraint*)el_constraintTopToSuperView __attribute__((deprecated("el_constraintWithIdentifier: 代替")));
- (NSLayoutConstraint*)el_constraintLeftToSuperView __attribute__((deprecated("el_constraintWithIdentifier: 代替")));
- (NSLayoutConstraint*)el_constraintBottomToSuperView __attribute__((deprecated("el_constraintWithIdentifier: 代替")));
- (NSLayoutConstraint*)el_constraintRightToSuperView __attribute__((deprecated("el_constraintWithIdentifier: 代替")));
- (NSLayoutConstraint*)el_constraintCentreXToSuperView __attribute__((deprecated("el_constraintWithIdentifier: 代替")));
- (NSLayoutConstraint*)el_constraintCentreYToSuperView __attribute__((deprecated("el_constraintWithIdentifier: 代替")));;
- (NSLayoutConstraint*)el_constraintWidth __attribute__((deprecated("el_constraintWithIdentifier: 代替")));
- (NSLayoutConstraint*)el_constraintHeight __attribute__((deprecated("el_constraintWithIdentifier: 代替")));

- (NSLayoutConstraint*)el_currentConstraint;
- (NSLayoutConstraint*)el_lastConstraint;

- (NSLayoutConstraint*)el_constraintTopToBottomView:(UIView*)view;
- (NSLayoutConstraint*)el_constraintLeftToRightView:(UIView*)view;
- (NSLayoutConstraint*)el_constraintBottomToTopView:(UIView*)view;
- (NSLayoutConstraint*)el_constraintRightToLeftView:(UIView*)view;

- (NSLayoutConstraint*)el_constraintWithIdentifier:(NSString*)identifier;

- (void)el_removeConstraintWithIdentifier:(NSString*)identifier;

@end

@interface NSArray (EasyLayout_Helper)
- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisXWithSize:(CGSize)size
                                                                margin:(CGFloat)margin;

- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisYWithSize:(CGSize)size
                                                                margin:(CGFloat)margin;

- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisYFlexibleWidthWithMargin:(CGFloat)margin spacing:(CGFloat)spacing;
- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisXFlexibleHeightWithMargin:(CGFloat)margin spacing:(CGFloat)spacing;
- (NSArray<NSLayoutConstraint *>*)autoSetViewsWidth:(CGFloat)width;
- (NSArray<NSLayoutConstraint *>*)autoSetViewsheight:(CGFloat)height;
@end

