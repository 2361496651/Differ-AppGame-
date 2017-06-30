//
//  UIView+AGAutoLayout.m
//  AGJointOperationSDK
//
//  Created by Mao on 16/3/2.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "UIView+EasyLayout.h"
#import <objc/runtime.h>

static char CurrentConstraintKey;
static char LastConstraintKey;
static char OppositeKey;
static BOOL ELFloatNotEqual(CGFloat a, CGFloat b){
    if (fabs(a - b) > FLT_EPSILON) {
        return YES;
    }
    return NO;
}

@interface NSLayoutConstraint (EasyLayout)

- (void)el_setOpposite:(BOOL)b;
- (BOOL)el_opposite;
@end

@implementation NSLayoutConstraint (EasyLayout)

- (void)el_setOpposite:(BOOL)b{
    objc_setAssociatedObject(self, &OppositeKey, @(b), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)el_opposite{
    return [objc_getAssociatedObject(self, &OppositeKey) boolValue];
}

@end

@implementation UIView (EasyLayout)
- (UIView*(^)(NSLayoutAttribute attr1, NSLayoutRelation relation, UIView *toView, NSLayoutAttribute attr2, CGFloat multiplier, CGFloat constant, UILayoutPriority priority))el_allAttributesTo{
    return ^UIView*(NSLayoutAttribute attr1, NSLayoutRelation relation, UIView *toView, NSLayoutAttribute attr2, CGFloat multiplier, CGFloat constant , UILayoutPriority priority){
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attr1 relatedBy:relation toItem:toView attribute:attr2 multiplier:multiplier constant:constant];
        constraint.priority = priority;
        constraint.active = YES;
        [self el_setCurrentConstraint:constraint];
        return self;
    };
}

- (UIView*(^)(NSLayoutAttribute attr1, NSLayoutRelation relation, UIView *toView, NSLayoutAttribute attr2, CGFloat multiplier, CGFloat constant))el_constraintTo{
    return ^UIView*(NSLayoutAttribute attr1, NSLayoutRelation relation, UIView *toView, NSLayoutAttribute attr2, CGFloat multiplier, CGFloat constant){
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attr1 relatedBy:relation toItem:toView attribute:attr2 multiplier:multiplier constant:constant];
        constraint.active = YES;
        [self el_setCurrentConstraint:constraint];
        return self;
    };
}

- (UIView*(^)(UIView *view, NSLayoutAttribute attribute, CGFloat constant))el_constantToAttribute{
    return ^UIView*(UIView *view, NSLayoutAttribute attribute, CGFloat constant){
        return self.el_constraintTo(attribute, NSLayoutRelationEqual, view, attribute, 1, constant);
    };
}

- (UIView*(^)(UIView *view, NSLayoutAttribute attribute))el_stickToAttribute{
    return ^UIView*(UIView *view, NSLayoutAttribute attribute){
        return self.el_constraintTo(attribute, NSLayoutRelationEqual, view, attribute, 1, 0);
    };
}

- (UIView*(^)(NSLayoutAttribute aAttribute, UIView *view, NSLayoutAttribute bAttribute))el_attributeToAttribute{
    return ^UIView*(NSLayoutAttribute aAttribute, UIView *view, NSLayoutAttribute bAttribute){
        return self.el_constraintTo(aAttribute, NSLayoutRelationEqual, view, bAttribute, 1, 0);
    };
}

- (UIView*(^)(NSString *identifier))el_identifier;{
    return ^UIView*(NSString *identifier){
        [self el_currentConstraint].identifier = identifier;
        return self;
    };
}

- (UIView*(^)(CGFloat multiplier))el_multiplier{
    return ^UIView*(CGFloat multiplier){
        NSLayoutConstraint *oldConstraint = [self el_currentConstraint];
        oldConstraint.active = NO;
        self.el_constraintTo(oldConstraint.firstAttribute, oldConstraint.relation, oldConstraint.secondItem, oldConstraint.secondAttribute, multiplier, oldConstraint.constant);
        [[self el_currentConstraint] el_setOpposite:[oldConstraint el_opposite]];
        return self;
    };
}
- (UIView*(^)(CGFloat constant))el_constant{
    return ^UIView*(CGFloat constant){
        [self el_currentConstraint].constant = constant;
        return self;
    };
}

- (UIView*(^)(UILayoutPriority priority))el_priority;{
    return ^UIView*(UILayoutPriority priority){
        NSLayoutConstraint *oldConstraint = [self el_currentConstraint];
        if (ELFloatNotEqual(priority, UILayoutPriorityRequired) && ELFloatNotEqual(oldConstraint.priority, UILayoutPriorityRequired)) {
            oldConstraint.priority = priority;
        }else{
            oldConstraint.active = NO;
            self.el_allAttributesTo(oldConstraint.firstAttribute, oldConstraint.relation, oldConstraint.secondItem, oldConstraint.secondAttribute, oldConstraint.multiplier, oldConstraint.constant, priority);
            [[self el_currentConstraint] el_setOpposite:[oldConstraint el_opposite]];
        }
        return self;
    };
}
- (UIView*(^)(NSLayoutRelation relation))el_relationInEL{
    return ^UIView*(NSLayoutRelation relation){
        NSLayoutConstraint *oldConstraint = [self el_currentConstraint];
        oldConstraint.active = NO;
        if (oldConstraint.el_opposite) {
            relation = -relation;
        }
        self.el_constraintTo(oldConstraint.firstAttribute, relation, oldConstraint.secondItem, oldConstraint.secondAttribute, oldConstraint.multiplier, oldConstraint.constant);
        [[self el_currentConstraint] el_setOpposite:[oldConstraint el_opposite]];
        return self;
    };
}


- (void)el_setCurrentConstraint:(NSLayoutConstraint*)constraint{
    NSLayoutConstraint *lastConstraint = [self el_currentConstraint];
    if(lastConstraint){
        objc_setAssociatedObject(self, &LastConstraintKey, lastConstraint, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &CurrentConstraintKey, constraint, OBJC_ASSOCIATION_RETAIN);
}

- (UIView*(^)(CGSize size))el_toSize;{
    return ^UIView*(CGSize size){
        return self.el_toWidth(size.width).el_toHeight(size.height);
    };
}
- (UIView*(^)(CGFloat))el_toWidth{
    return ^UIView*(CGFloat constant){
        return self.el_constraintTo(NSLayoutAttributeWidth, NSLayoutRelationEqual, nil, NSLayoutAttributeNotAnAttribute, 1, constant);
    };
}
- (UIView*(^)(CGFloat))el_toHeight{
    return ^UIView*(CGFloat constant){
        return self.el_constraintTo(NSLayoutAttributeHeight, NSLayoutRelationEqual, nil, NSLayoutAttributeNotAnAttribute, 1, constant);
    };
}

///设置宽度约束
- (UIView*(^)(UIView *view, CGFloat multiplier))el_toWidthToWidth{
    return ^UIView*(UIView *view, CGFloat multiplier){
        return self.el_constraintTo(NSLayoutAttributeWidth, NSLayoutRelationEqual, view, NSLayoutAttributeWidth, multiplier, 0);
    };
}
///设置高度约束
- (UIView*(^)(UIView *view, CGFloat multiplier))el_toHeightToHeight{
    return ^UIView*(UIView *view, CGFloat multiplier){
        return self.el_constraintTo(NSLayoutAttributeHeight, NSLayoutRelationEqual, view, NSLayoutAttributeHeight, multiplier, 0);
    };
}



- (UIView*(^)(CGPoint offset))el_centreToSuperView{
    return ^UIView*(CGPoint offset){
        return self.el_axisXToSuperView(offset.x).el_axisYToSuperView(offset.y);
    };
}
- (UIView*(^)(CGFloat offsetX))el_axisXToSuperView{
    return ^UIView*(CGFloat constant){
        self.el_axisXToAxisX(self.superview, constant);
        return self;
    };
}
- (UIView*(^)(CGFloat offsetY))el_axisYToSuperView{
    return ^UIView*(CGFloat constant){
        self.el_axisYToAxisY(self.superview, constant);
        return self;
    };
}


- (UIView*(^)(UIView *view, CGPoint CGPoint))el_centreTo{
    return ^UIView*(UIView *view, CGPoint offset){
        self.el_axisXToAxisX(view, offset.x).el_axisYToAxisY(view, offset.y);
        return self;
    };
}
- (UIView*(^)(UIView *view,CGFloat offsetX))el_axisXToAxisX{
    return ^UIView*(UIView *view,CGFloat constant){
        return self.el_constraintTo(NSLayoutAttributeCenterX, NSLayoutRelationEqual, view, NSLayoutAttributeCenterX, 1, constant);
    };
}



- (UIView*(^)(UIView *view,CGFloat offsetY))el_axisYToAxisY{
    return ^UIView*(UIView *view,CGFloat constant){
        return self.el_constraintTo(NSLayoutAttributeCenterY, NSLayoutRelationEqual, view, NSLayoutAttributeCenterY, 1, constant);
    };
}

- (UIView*(^)(UIView *view, CGFloat distance))el_topToTop{
    return ^UIView*(UIView *view, CGFloat constant){
        return self.el_constantToAttribute(view, NSLayoutAttributeTop, constant);
    };
}

- (UIView*(^)(UIView *view, CGFloat distance))el_leftToLeft{
    return ^UIView*(UIView *view, CGFloat constant){
        return self.el_constantToAttribute(view, NSLayoutAttributeLeft, constant);
    };}


- (UIView*(^)(UIView *view, CGFloat distance))el_bottomToBottom{
    return ^UIView*(UIView *view, CGFloat constant){
        self.el_constantToAttribute(view, NSLayoutAttributeBottom,-constant);
        [[self el_currentConstraint] el_setOpposite:YES];
        return self;
    };
}

- (UIView*(^)(UIView *view, CGFloat distance))el_rightToRight{
    return ^UIView*(UIView *view, CGFloat constant){
        self.el_constantToAttribute(view, NSLayoutAttributeRight,-constant);
        [[self el_currentConstraint] el_setOpposite:YES];
        return self;
    };
}

- (UIView*(^)())el_edgesStickToSuperView{
    return ^UIView*(){
        return self.el_edgesToSuperView(0, 0, 0, 0);
    };
}

- (UIView*(^)(CGFloat topInset, CGFloat leftInset, CGFloat bottomInset, CGFloat rightInset))el_edgesToSuperView{
    return ^UIView*(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
        if (ELFloatNotEqual(top, EL_INGNORE)) {
            self.el_topToSuperView(top);
        }
        if (ELFloatNotEqual(left, EL_INGNORE)) {
            self.el_leftToSuperView(left);
        }
        if (ELFloatNotEqual(bottom, EL_INGNORE)) {
            self.el_bottomToSuperView(bottom);
        }
        if (ELFloatNotEqual(right, EL_INGNORE)) {
            self.el_rightToSuperView(right);
        }
        return self;
    };
}
- (UIView*(^)(CGFloat distance))el_topToSuperView{
    return ^UIView*(CGFloat constant){
        return self.el_topToTop(self.superview, constant);
    };
}
- (UIView*(^)(CGFloat distance))el_leftToSuperView{
    return ^UIView*(CGFloat constant){
        return self.el_leftToLeft(self.superview, constant);
    };
}
- (UIView*(^)(CGFloat distance))el_bottomToSuperView{
    return ^UIView*(CGFloat constant){
        return self.el_bottomToBottom(self.superview, constant);
    };
}
- (UIView*(^)(CGFloat distance))el_rightToSuperView{
    return ^UIView*(CGFloat constant){
        return self.el_rightToRight(self.superview, constant);
    };
}

- (UIView*(^)(CGFloat multiplier))el_widthEqualToHeight{
    return ^UIView*(CGFloat multiplier){
        return self.el_constraintTo(NSLayoutAttributeWidth, NSLayoutRelationEqual, self, NSLayoutAttributeHeight, multiplier, 0);
    };
}

- (UIView*(^)(CGFloat multiplier))el_heightEqualTowidth{
    return ^UIView*(CGFloat multiplier){
        return self.el_constraintTo(NSLayoutAttributeHeight, NSLayoutRelationEqual, self, NSLayoutAttributeWidth, multiplier, 0);
    };
}
- (UIView*(^)(UIView*,CGFloat distance))el_topToBottom{
    return ^UIView*(UIView *view,CGFloat constant){
        return self.el_constraintTo(NSLayoutAttributeTop, NSLayoutRelationEqual, view, NSLayoutAttributeBottom, 1, constant);
    };
}
- (UIView*(^)(UIView*,CGFloat distance))el_leftToRight{
    return ^UIView*(UIView *view,CGFloat constant){
        return self.el_constraintTo(NSLayoutAttributeLeft, NSLayoutRelationEqual, view, NSLayoutAttributeRight, 1, constant);
    };
}
- (UIView*(^)(UIView*,CGFloat distance))el_bottomToTop{
    return ^UIView*(UIView *view,CGFloat constant){
        self.el_constraintTo(NSLayoutAttributeBottom, NSLayoutRelationEqual, view, NSLayoutAttributeTop, 1, -constant);
        [[self el_currentConstraint] el_setOpposite:YES];
        return self;
    };
}
- (UIView*(^)(UIView*,CGFloat distance))el_rightToLeft{
    return ^UIView*(UIView *view,CGFloat constant){
        self.el_constraintTo(NSLayoutAttributeRight, NSLayoutRelationEqual, view, NSLayoutAttributeLeft, 1, -constant);
        [[self el_currentConstraint] el_setOpposite:YES];
        return self;
    };
}

- (UIView*(^)(UIViewController * viewController))el_stickToTopLayoutGuide{
    return ^UIView*(UIViewController * viewController){
        return self.el_closeToTopLayoutGuide(viewController, 0);
    };
}
- (UIView*(^)(UIViewController * viewController))el_stickToBottomLayoutGuide{
    return ^UIView*(UIViewController * viewController){
        return self.el_closeToBottomLayoutGuide(viewController, 0);
    };
}

- (UIView*(^)(UIViewController * viewController, CGFloat inset))el_closeToTopLayoutGuide{
    return ^UIView*(UIViewController * viewController, CGFloat inset){
        return self.el_toTopLayoutGuide(viewController, inset, NSLayoutRelationEqual);
    };
}
- (UIView*(^)(UIViewController * viewController, CGFloat inset))el_closeToBottomLayoutGuide{
    return ^UIView*(UIViewController * viewController, CGFloat inset){
        return self.el_toBottomLayoutGuide(viewController, inset, NSLayoutRelationEqual);
    };
}

- (UIView*(^)(UIViewController * viewController, CGFloat inset, NSLayoutRelation relation))el_toTopLayoutGuide{
    return ^UIView*(UIViewController * viewController, CGFloat inset, NSLayoutRelation relation){
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:relation toItem:viewController.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:inset];
        [viewController.view  addConstraint:constraint];
        [self el_setCurrentConstraint:constraint];
        return self;
    };
}
- (UIView*(^)(UIViewController * viewController, CGFloat inset, NSLayoutRelation relation))el_toBottomLayoutGuide{
    return ^UIView*(UIViewController * viewController, CGFloat inset, NSLayoutRelation relation){
        self.translatesAutoresizingMaskIntoConstraints = NO;
        inset = -inset;
        if (relation == NSLayoutRelationLessThanOrEqual) {
            relation = NSLayoutRelationGreaterThanOrEqual;
        } else if (relation == NSLayoutRelationGreaterThanOrEqual) {
            relation = NSLayoutRelationLessThanOrEqual;
        }
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:relation toItem:viewController.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:inset];
        [viewController.view addConstraint:constraint];
        [self el_setCurrentConstraint:constraint];
        return self;
    };
}
@end

@implementation UIView (EasyLayout_Helper)

- (NSLayoutConstraint*)el_constraintTopToSuperView{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeTop && [each.secondItem isEqual:self.superview ] && each.secondAttribute == NSLayoutAttributeTop) || (([each.firstItem isEqual:self.superview] && each.firstAttribute == NSLayoutAttributeTop) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeTop)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintLeftToSuperView{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeLeft && [each.secondItem isEqual:self.superview ] && each.secondAttribute == NSLayoutAttributeLeft) || (([each.firstItem isEqual:self.superview] && each.firstAttribute == NSLayoutAttributeLeft) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeLeft)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintBottomToSuperView{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeBottom && [each.secondItem isEqual:self.superview ] && each.secondAttribute == NSLayoutAttributeBottom) || (([each.firstItem isEqual:self.superview] && each.firstAttribute == NSLayoutAttributeBottom) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeBottom)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintRightToSuperView{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeRight && [each.secondItem isEqual:self.superview ] && each.secondAttribute == NSLayoutAttributeRight) || (([each.firstItem isEqual:self.superview] && each.firstAttribute == NSLayoutAttributeRight) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeRight)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintCentreXToSuperView{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if ([each isMemberOfClass:[NSLayoutConstraint class]]) {
                if (([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeCenterX &&[each.secondItem isEqual:self.superview] && each.secondAttribute == NSLayoutAttributeCenterX) || ([each.firstItem isEqual:self.superview] && each.firstAttribute == NSLayoutAttributeCenterX && [each.secondItem isEqual:self] && each.secondAttribute == NSLayoutAttributeCenterX)) {
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintCentreYToSuperView{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if ([each isMemberOfClass:[NSLayoutConstraint class]]) {
                if (([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeCenterY &&[each.secondItem isEqual:self.superview] && each.secondAttribute == NSLayoutAttributeCenterY) || ([each.firstItem isEqual:self.superview] && each.firstAttribute == NSLayoutAttributeCenterY && [each.secondItem isEqual:self] && each.secondAttribute == NSLayoutAttributeCenterY)) {
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintWidth{
    for (NSLayoutConstraint *each in self.constraints) {
        if([each isMemberOfClass:[NSLayoutConstraint class]]){
            if([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeWidth){
                return each;
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintHeight{
    for (NSLayoutConstraint *each in self.constraints) {
        if([each isMemberOfClass:[NSLayoutConstraint class]]){
            if([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeHeight){
                return each;
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_currentConstraint{
    return objc_getAssociatedObject(self, &CurrentConstraintKey);
}

- (NSLayoutConstraint*)el_lastConstraint{
    return objc_getAssociatedObject(self, &LastConstraintKey);
}

- (NSLayoutConstraint*)el_constraintTopToBottomView:(UIView*)view{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeTop && [each.secondItem isEqual:view ] && each.secondAttribute == NSLayoutAttributeBottom) || (([each.firstItem isEqual:view] && each.firstAttribute == NSLayoutAttributeTop) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeBottom)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintLeftToRightView:(UIView*)view{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeLeft && [each.secondItem isEqual:view ] && each.secondAttribute == NSLayoutAttributeRight) || (([each.firstItem isEqual:view] && each.firstAttribute == NSLayoutAttributeLeft) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeLeft)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintBottomToTopView:(UIView*)view{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeBottom && [each.secondItem isEqual:view ] && each.secondAttribute == NSLayoutAttributeTop) || (([each.firstItem isEqual:view] && each.firstAttribute == NSLayoutAttributeBottom) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeTop)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)el_constraintRightToLeftView:(UIView*)view{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeRight && [each.secondItem isEqual:view ] && each.secondAttribute == NSLayoutAttributeLeft) || (([each.firstItem isEqual:view] && each.firstAttribute == NSLayoutAttributeRight) && [each.secondItem isEqual:self ] && each.secondAttribute == NSLayoutAttributeLeft)){
                    return each;
                }
            }
        }
    }
    return nil;
}

- (NSLayoutConstraint*)el_constraintWithIdentifier:(NSString*)identifier{
    for (NSLayoutConstraint *each in self.constraints) {
        if([each isMemberOfClass:[NSLayoutConstraint class]]){
            if ([each.identifier isEqualToString:identifier]) {
                return each;
            }
        }
    }
    return nil;
}

- (void)el_removeConstraintWithIdentifier:(NSString*)identifier{
    NSLayoutConstraint *aConstraint = [self el_constraintWithIdentifier:identifier];
    if (aConstraint) {
        aConstraint.active = NO;
    }
    
}
@end

@implementation NSArray (EasyLayout_Helper)
- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisXWithSize:(CGSize)size
                                                                margin:(CGFloat)margin{
    
    NSMutableArray<NSLayoutConstraint*> *constraints = [NSMutableArray new];
    CGFloat itemWidth = size.width;
    CGFloat count = self.count;
    
    for (NSInteger i = 0; i < self.count; ++i) {
        UIView *view = self[i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [view.el_axisYToSuperView(0).el_constraintTo(NSLayoutAttributeCenterX, NSLayoutRelationEqual, view.superview, NSLayoutAttributeCenterX, MAX(0.0001, i / (count - 1) * 2), itemWidth * (i + 0.5) - (i * (count * itemWidth + 2*margin))/(count-1) + margin).el_toSize(size) el_currentConstraint];
        [constraints addObject:constraint];
        
    }
    return constraints;
}

- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisYWithSize:(CGSize)size
                                                                margin:(CGFloat)margin{
    NSMutableArray<NSLayoutConstraint*> *constraints = [NSMutableArray new];
    CGFloat itemWidth = size.width;
    CGFloat count = self.count;
    
    for (NSInteger i = 0; i < self.count; ++i) {
        UIView *view = self[i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [view.el_axisXToSuperView(0).el_constraintTo(NSLayoutAttributeCenterY, NSLayoutRelationEqual, view.superview, NSLayoutAttributeCenterY, MAX(0.0001, i / (count - 1) * 2), itemWidth * (i + 0.5) - (i * (count * itemWidth + 2*margin))/(count-1) + margin).el_toSize(size) el_currentConstraint];
        [constraints addObject:constraint];
        
    }
    return constraints;
}

- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisYFlexibleWidthWithMargin:(CGFloat)margin spacing:(CGFloat)spacing {
    NSMutableArray<NSLayoutConstraint*> *constraints = [NSMutableArray new];
    for (UIView *tmp in self) {
        NSInteger index = [self indexOfObject:tmp];
        
        if (index == 0) {
            tmp.el_leftToSuperView(margin).el_axisYToSuperView(0);
        }
        
        // 索引小于数组对象数量减 1，为了过滤到最后一个对象
        if (index < self.count - 1) {
            UIView *next = self[index + 1];
            tmp.el_toWidthToWidth( next, 1).el_rightToLeft(next, spacing);
        }
        else {
            tmp.el_rightToSuperView(margin);
        }
        NSLayoutConstraint *constraint = [tmp.el_axisYToSuperView(0) el_currentConstraint];
        [constraints addObject:constraint];
    }
    return constraints;
}

- (NSArray<NSLayoutConstraint *>*)el_distributeViewsAlongAxisXFlexibleHeightWithMargin:(CGFloat)margin spacing:(CGFloat)spacing {
    NSMutableArray<NSLayoutConstraint*> *constraints = [NSMutableArray new];
    for (UIView *tmp in self) {
        NSInteger index = [self indexOfObject:tmp];
        
        // 索引小于数组对象数量减 1，为了过滤到最后一个对象
        if (index == 0) {
            tmp.el_topToSuperView(margin).el_axisXToSuperView(0);
        }
        
        if (index < self.count - 1) {
            UIView *next = self[index + 1];
            tmp.el_toHeightToHeight(next,1).el_bottomToTop(next, spacing);
        }
        else {
            tmp.el_bottomToSuperView(margin);
        }
        NSLayoutConstraint *constraint = [tmp.el_axisYToSuperView(0) el_currentConstraint];
        [constraints addObject:constraint];
    }
    return constraints;
    
}

- (NSArray<NSLayoutConstraint *>*)autoSetViewsWidth:(CGFloat)width{
    return nil;
}
- (NSArray<NSLayoutConstraint *>*)autoSetViewsheight:(CGFloat)height{
    return nil;
}
@end
