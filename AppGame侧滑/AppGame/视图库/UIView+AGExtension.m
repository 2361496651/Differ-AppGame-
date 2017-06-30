//
//  UIView+APExtension.m
//  LittleGame
//
//  Created by Mao on 14-8-14.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import "UIView+AGExtension.h"
#import "UIView+EasyLayout.h"

#define kAGNOTICE_VIEW_TAG 1568

@implementation UIView (APExtension)
- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)screenX
{
    CGFloat x = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            x -= scrollView.contentOffset.x;
        }
    }

    return x;
}

- (CGFloat)screenY
{
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame
{
    return CGRectMake(self.screenX, self.screenY, self.width, self.height);
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)orientationWidth
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
               ? self.height
               : self.width;
}

- (CGFloat)orientationHeight
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
               ? self.width
               : self.height;
}

- (UIView *)descendantOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls])
        return self;

    for (UIView *child in self.subviews) {
        UIView *it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }

    return nil;
}

- (UIView *)ancestorOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls]) {
        return self;

    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];

    } else {
        return nil;
    }
}

- (UITableView*)ag_tableView{
    return [self ancestorOrSelfWithClass:[UITableView class]];
}
- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (CGPoint)offsetFromView:(UIView *)otherView
{
    CGFloat x = 0.0f, y = 0.0f;
    for (UIView *view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}
- (UIImage *)screenshot
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIViewController*)ag_viewController{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)responder;
        }else{
            responder = [responder nextResponder];
        }
    }
    return nil;
}
- (UINavigationController*)ag_navigationController{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)responder;
        }else{
            responder = [responder nextResponder];
        }
    }
    return nil;
}
- (UITabBarController*)ag_tabBarController{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController*)responder;
        }else{
            responder = [responder nextResponder];
        }
    }
    return nil;
}
- (void)removeConstraintsRelatedToSuperView{
    NSMutableArray *constraint = [NSMutableArray array];
    for (NSLayoutConstraint *each in self.superview.constraints) {
        if ([each.firstItem isEqual:self] || [each.secondItem isEqual:self]) {
            [constraint addObject:each];
        }
    }
    [self.superview removeConstraints:constraint];
}
- (void)showNoticeWithType:(AGViewNoticeType)type info:(NSString*)info offsetOnHorizontal:(CGFloat)offset{
    [[self viewWithTag:kAGNOTICE_VIEW_TAG] removeFromSuperview];
    UIView *contentView = [UIView new];
    contentView.tag = kAGNOTICE_VIEW_TAG;
    contentView.frame = self.bounds;
    [self addSubview:contentView];
    if(AG_IOS8_OR_LATER){
        contentView.el_edgesToSuperView(0, 0, 0, 0);
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    [contentView addSubview:imageView];
    [contentView addSubview:label];
    label.font = [UIFont systemFontOfSize:12];
    imageView.el_axisYToSuperView(0).el_axisYToSuperView(offset);
    label.el_axisYToSuperView(0).el_constraintTo(NSLayoutAttributeTop, NSLayoutRelationEqual, imageView, NSLayoutAttributeBottom, 20, 0);
    if (type == AGViewNoticeTypeInfo) {
        imageView.image = [UIImage imageNamed:@"icon_download_pre"];
    }else if (type == AGViewNoticeTypeWarning){
        imageView.image = [UIImage imageNamed:@"icon_download_pre"];
    }
    label.textColor = [UIColor lightGrayColor];
    label.text = info;
}
- (void)showNoticeWithType:(AGViewNoticeType)type info:(NSString*)info{
    [self showNoticeWithType:type info:info offsetOnHorizontal:-80];
}
- (void)hideNotice{
    [[self viewWithTag:kAGNOTICE_VIEW_TAG] removeFromSuperview];
}

- (void)ag_showOnWindow{
    if (![self.superview viewWithTag:self.hash]){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
        backgroundView.alpha = 0;
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        backgroundView.tag = self.hash;
        [window addSubview:backgroundView];
        [window addSubview:self];
        self.el_axisYToSuperView(0);
        NSLayoutConstraint *constraintBT = self.el_currentConstraint;
        [window layoutIfNeeded];
        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:0.7f
              initialSpringVelocity:1.
                            options:0
                         animations: ^{
                             backgroundView.alpha = 1;
                             [window removeConstraint:constraintBT];
                             self.el_axisXToSuperView(0);
                             [window layoutIfNeeded];
                         } completion: ^(BOOL finished) {
                         }];
    }
}
- (void)ag_hideFromWindow{
    if (self.superview) {
        UIView *backgroundView = [self.superview viewWithTag:self.hash];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            for (NSLayoutConstraint *each in self.superview.constraints) {
                if (([each.firstItem isEqual:self] && [each.secondItem isEqual:self.superview])|| ([each.firstItem isEqual:self.superview] && [each.secondItem isEqual:self])) {
                    if (each.firstAttribute == NSLayoutAttributeCenterY && each.secondAttribute == NSLayoutAttributeCenterY) {
                        [self.superview removeConstraint:each];
                        break;
                    }
                }
            }
            backgroundView.alpha = 0;
            //todo
            self.el_constraintTo(NSLayoutAttributeBottom,NSLayoutRelationEqual, self.superview,NSLayoutAttributeBottom, 0, -40);
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
    
}
- (void)ag_emergeOnWindow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self ag_emergeOnView:window];
}
- (void)ag_sinkFromSuperview{
    if (self.superview) {
        UIView *backgroundView = [self.superview viewWithTag:self.hash];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self anyBottomConstraint].constant = [self anyHeightConstraint].constant;
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }

}

- (void)ag_emergeOnView:(UIView*)view sinkAfterDelay:(NSTimeInterval)delay{
    [self ag_emergeOnView:view];
    __weak typeof(self) weakSelf = self;
    if (isgreater(delay, 0)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf ag_sinkFromSuperview];
        });
    }
}
- (void)ag_emergeOnView:(UIView*)view{
    if (![self.superview viewWithTag:self.hash]) {
        UIButton *backgroundView = [[UIButton alloc] initWithFrame:view.bounds];
        @weakify(self);
        [[backgroundView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self ag_sinkFromSuperview];
        }];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.tag = self.hash;
        [view addSubview:backgroundView];
        [view addSubview:self];
        self.el_leftToSuperView(0).el_rightToSuperView(0).el_bottomToSuperView(-[self anyHeightConstraint].constant);
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.2 animations:^{
            [self anyBottomConstraint].constant = 0;
            [view layoutIfNeeded];
        }];
    }
}

- (void)ag_addSubView:(UIView*)view{
    [self addSubview:view];
    view.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1;
    }];
}
- (void)ag_removeFromSuperview{
    if (self.superview) {
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)ag_setShadow{
    [self ag_setShadow:CGSizeMake(3, 3) shadowColor:[UIColor grayColor] opacity:0.5 radius:2.0];
}

- (void)ag_setShadow:(CGSize)offset shadowColor:(UIColor*)shadowColor opacity:(float)opacity radius:(float)radius{
    self.layer.shadowOffset = offset;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

- (void)ag_setHidden:(BOOL)hidden{
    self.hidden = NO;
    if (hidden) {
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }else{
        self.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.hidden = NO;
        }];
    }


}
- (NSLayoutConstraint*)anyTopConstraint{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeTop) || ([each.secondItem isEqual:self] && each.secondAttribute == NSLayoutAttributeTop)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)anyLeadingConstraint{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeLeading) || ([each.secondItem isEqual:self] && each.secondAttribute == NSLayoutAttributeLeading)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)anyBottomConstraint{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeBottom) || ([each.secondItem isEqual:self] && each.secondAttribute == NSLayoutAttributeBottom)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)anyTrailingConstraint{
    if (self.superview) {
        for (NSLayoutConstraint *each in self.superview.constraints) {
            if([each isMemberOfClass:[NSLayoutConstraint class]]){
                if(([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeTrailing) || ([each.secondItem isEqual:self] && each.secondAttribute == NSLayoutAttributeTrailing)){
                    return each;
                }
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)anyHeightConstraint{
    for (NSLayoutConstraint *each in self.constraints) {
        if([each isMemberOfClass:[NSLayoutConstraint class]]){
            if([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeHeight){
                return each;
            }
        }
    }
    return nil;
}
- (NSLayoutConstraint*)anyWidthConstraint{
    for (NSLayoutConstraint *each in self.constraints) {
        if([each isMemberOfClass:[NSLayoutConstraint class]]){
            if([each.firstItem isEqual:self] && each.firstAttribute == NSLayoutAttributeWidth){
                return each;
            }
        }
    }
    return nil;
}
- (void)hideSubviews{
    for (UIView *each in self.subviews) {
        each.hidden = YES;
        [each hideSubviews];
    }
}
- (void)showSubviews{
    for (UIView *each in self.subviews) {
        each.hidden = NO;
        [each showSubviews];
    }
}
- (UIImageView*)addVMarkImageViewWithSize:(CGSize)size{
    NSString * key = [NSString stringWithFormat:@"官标%@x%@",@(size.width), @(size.height)];
    UIImage *image = [[PINMemoryCache sharedCache] objectForKey:key];
    if (!image) {
        image = [UIImage imageNamed:@"大官标"];
        if (!CGSizeEqualToSize(image.size, size)) {
            image = [image scaleToCoverSize:size];
        }
        [[PINMemoryCache sharedCache] setObject:image forKey:key];
    }
    UIImageView *aImageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:aImageView];
    aImageView.el_toSize(size).el_rightToRight(self, 0).el_bottomToBottom(self, 0);
    aImageView.contentMode = UIViewContentModeScaleAspectFit;
    return aImageView;
}
- (UIImageView*)addVMarkImageViewWithType:(AGVmarkSizeType)type{
    CGFloat vmarkWH = 0;
    switch (type) {
        case AGVmarkSizeTypeSmall:
            vmarkWH = 13;
            break;
        case AGVmarkSizeTypeNormal:
            vmarkWH = 16;
            break;
        case AGVmarkSizeTypeLarge:
            vmarkWH = 24;
            break;
        default:
            break;
    }
    NSString *key = [NSString stringWithFormat:@"common_vmark_%@",@(vmarkWH * 2)];
    
    UIImage *image = [[PINMemoryCache sharedCache] objectForKey:key];
    if (!image) {
        image = [UIImage imageNamed:key];
        [[PINMemoryCache sharedCache] setObject:image forKey:key];
    }
    UIImageView *aImageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:aImageView];
    aImageView.el_toSize(CGSizeMake(vmarkWH, vmarkWH)).el_rightToSuperView(0).el_bottomToSuperView(0);
    aImageView.contentMode = UIViewContentModeScaleAspectFit;
    return aImageView;
}

- (void)enumerateAllSubviewsUsingBlock:(void (^)(__kindof UIView *view, NSUInteger idx, BOOL *stop))block{
    NSMutableArray *views = [NSMutableArray arrayWithArray:self.subviews];
    NSUInteger idx = 0;
    BOOL stop = NO;
    while (views.count) {
        UIView *view = views.firstObject;
        if (block) {
            block(view, idx, &stop);
        }
        if (stop) {
            break;
        }
        [views removeObjectAtIndex:0];
        if (view.subviews.count) {
            [views addObjectsFromArray:view.subviews];
        }
    }
}
- (void)ag_logAllGestures{
    [self enumerateAllSubviewsUsingBlock:^(__kindof UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.gestureRecognizers.count) {
            NSLog(@"%@", view.gestureRecognizers);
        }
    }];
}
@end

@implementation UIView (Debug)
//
//- (void)enableWireFrameDebug{
//    [[UIView class] aspect_hookSelector:@selector(setFrame:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
//        UIView *view = [info instance];
//        view.layer.borderWidth = 0.5;
//        view.layer.borderColor = [UIColor randomColor].CGColor;
//    } error:nil];
//}
@end

@implementation UIView (SetLines)

- (void)setBottomLineWithColor:(UIColor *)color {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    line.el_edgesToSuperView(EL_INGNORE, 0, 0, 0).el_toHeight(1);
}

- (void)setTopLineWithColor:(UIColor *)color {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    line.el_edgesToSuperView(0, 0, EL_INGNORE, 0).el_toHeight(1);
}

- (void)setRightLineWithColor:(UIColor *)color {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    line.el_edgesToSuperView(0, EL_INGNORE, 0, 0).el_toWidth(1);
}

- (void)setLeftLineWithColor:(UIColor *)color {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    line.el_edgesToSuperView(0, 0, 0, EL_INGNORE).el_toWidth(1);
}

@end
