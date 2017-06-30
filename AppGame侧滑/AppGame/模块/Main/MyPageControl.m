//
//  MyPageControl.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/17.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "MyPageControl.h"

@interface MyPageControl ()

- (void)updateDots;

@end

@implementation MyPageControl  // 实现部分
@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;
- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    return self;
}
- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片

    imagePageStateHighlighted = image;
    [self updateDots];
}
- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    imagePageStateNormal = image;
    [self updateDots];
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}
- (void)updateDots { // 更新显示所有的点按钮
    if (imagePageStateNormal || imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIImageView *dot = [subview objectAtIndex:i];  // 以下不解释, 看了基本明白
            dot.image = (self.currentPage == i) ? imagePageStateNormal : imagePageStateHighlighted;
        }
    }
}

@end
