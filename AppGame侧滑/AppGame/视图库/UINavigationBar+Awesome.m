//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Awesome)
static char overlayKey;
static char replicaProperties;
- (NSMutableDictionary*)lt_replicaProperties{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &replicaProperties);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &replicaProperties, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (void)lt_setBackgroundImage:(UIImage *)backgroundImage{
    self.translucent = YES;
    self.barTintColor = [UIColor clearColor];
    self.lt_overlay.image = backgroundImage;
}

- (UIImageView *)lt_overlay
{
    UIImageView *overlay = objc_getAssociatedObject(self, &overlayKey);
    if (!overlay) {
        NSMutableDictionary *properties = [self lt_replicaProperties];
        properties[@"backgroundImage"] = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
        properties[@"translucent"] = @(self.translucent);
        properties[@"barTintColor"] = self.barTintColor;
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        overlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        overlay.contentMode = UIViewContentModeScaleToFill;
        overlay.userInteractionEnabled = NO;
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:overlay atIndex:0];
        objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return overlay;
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    self.translucent = YES;
    self.barTintColor = [UIColor clearColor];
    self.lt_overlay.backgroundColor = backgroundColor;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)lt_reset
{
    [self.lt_overlay removeFromSuperview];
    objc_setAssociatedObject(self, &overlayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSDictionary *properties = [self lt_replicaProperties];
    [self setBackgroundImage:properties[@"backgroundImage"] forBarMetrics:UIBarMetricsDefault];
    self.translucent = [properties[@"translucent"] boolValue];
    self.barTintColor = properties[@"barTintColor"];
    
}

@end
