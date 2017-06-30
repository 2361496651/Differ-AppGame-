//
//  UITabBar+AGExtension.m
//  AGVideo
//
//  Created by Mao on 16/3/15.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "UITabBar+AGExtension.h"

@implementation UITabBar (AGExtension)
- (void)ag_setDotViewHidden:(BOOL)b atIndex:(NSInteger)index{
    if (index >= self.items.count) {
        return;
    }
    CGFloat itemWidth = ScreenWidth / self.items.count;
    CGRect dotRect = CGRectMake(index * itemWidth + itemWidth - 30, 8, 8, 8);
    UIView *dotView = [self viewWithTag:1000+index];
    if (!dotView) {
        dotView = [[UIView alloc] initWithFrame:dotRect];
        dotView.layer.cornerRadius = 4;
        dotView.layer.masksToBounds = YES;
        dotView.backgroundColor = [UIColor colorWithRed:0.94 green:0.27 blue:0.31 alpha:1];
        dotView.tag = 1000 + index;
        [self addSubview:dotView];
    }else{
        [self bringSubviewToFront:dotView];
    }
    dotView.hidden = b;
}
@end
