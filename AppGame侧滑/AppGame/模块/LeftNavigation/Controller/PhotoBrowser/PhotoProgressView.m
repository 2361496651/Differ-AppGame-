//
//  PhotoProgressView.m
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "PhotoProgressView.h"

@implementation PhotoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    // 获取参数
//    let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
//    let radius = rect.width * 0.5 - 3
//    let startAngle = CGFloat(-M_PI_2)
//    let endAngle = CGFloat(2 * M_PI) * progress + startAngle
//    // 创建贝塞尔曲线
//    let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//    // 绘制一条中心点的线
//    path.addLineToPoint(center)
//    path.closePath()
//    // 设置绘制的颜色
//    UIColor(white: 1.0, alpha: 0.4).setFill()
//    // 开始绘制
//    path.fill()
    
    
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = rect.size.width * 0.5 - 3;
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = 2 * M_PI * self.progress + startAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path addLineToPoint:center];
    [path closePath];
    [[UIColor whiteColor] setFill];
    [path fill];
}


@end
