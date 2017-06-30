//
//  CountView.m
//  AppGame
//
//  Created by supozheng on 17/5/15.
//
//

#import "CountView.h"
#import "CircleView.h"
#import "RotatedAngleView.h"
#import "CountViewLabel.h"
#import "UIView+SetRect.h"

@interface CountView ()

@property (nonatomic, strong) CircleView         *fullCircle;
@property (nonatomic, strong) CircleView         *showCircle;
@property (nonatomic, strong) RotatedAngleView   *rotateView;
@property (nonatomic, strong) CountViewLabel *countLabel;

@end

@implementation CountView

- (void)buildView:(float)width height:(float)height {
    
    CGRect circleRect = CGRectZero;
    CGRect rotateRect = CGRectZero;
    
        
    circleRect = CGRectMake(0, 0, width, height);
    rotateRect = CGRectMake(0, 0, circleRect.size.width, circleRect.size.height);
    
    
    // 完整的圆
    self.fullCircle           = [CircleView createDefaultViewWithFrame:circleRect];
    self.fullCircle.lineColor = [UIColor di_Circle1];
    [self.fullCircle buildView];
    
    // 局部显示的圆
    self.showCircle = [CircleView createDefaultViewWithFrame:circleRect];
    [self.showCircle buildView];
    
    // 旋转的圆
    self.rotateView = [[RotatedAngleView alloc] initWithFrame:rotateRect];
    [self.rotateView addSubview:self.fullCircle];
    [self.rotateView addSubview:self.showCircle];
    [self addSubview:self.rotateView];
    
    // 计数的数据
    self.countLabel = [[CountViewLabel alloc] initWithFrame:rotateRect];
    self.countLabel.backgroundColor = [UIColor clearColor];
//    self.countLabel.x += 4;
    float ratio = 100/40;
    self.countLabel.fontSize = width/ratio + 4;
    
    [self addSubview:self.countLabel];
}

- (void)show {
    
    CGFloat circleFullPercent = 1;
    CGFloat duration          = 0;
    
    // 进行参数复位
    [self.fullCircle strokeEnd:0 animated:NO duration:0];
    [self.showCircle strokeEnd:0 animated:NO duration:0];
    [self.fullCircle strokeStart:0 animated:NO duration:0];
    [self.showCircle strokeStart:0 animated:NO duration:0];
    [self.rotateView roateAngle:0];
    
    // 设置动画
    [self.fullCircle strokeEnd:circleFullPercent animated:NO duration:duration];
    [self.showCircle strokeEnd:circleFullPercent * self.percent animated:NO duration:duration];
    [self.rotateView roateAngle:45.f duration:duration];
    self.countLabel.toValue = self.percent * 100;
    [self.countLabel showDuration:duration animated:NO];
}

- (void)showWithAnimated {
    
    CGFloat circleFullPercent = 1;
    CGFloat duration          = 0;
    
    // 进行参数复位
    [self.fullCircle strokeEnd:0 animated:NO duration:0];
    [self.showCircle strokeEnd:0 animated:NO duration:0];
    [self.fullCircle strokeStart:0 animated:NO duration:0];
    [self.showCircle strokeStart:0 animated:NO duration:0];
    [self.rotateView roateAngle:0];
    
    // 设置动画
    [self.fullCircle strokeEnd:circleFullPercent animated:YES duration:duration];
    [self.showCircle strokeEnd:circleFullPercent * self.percent animated:YES duration:duration];
    [self.rotateView roateAngle:45.f duration:duration];
    self.countLabel.toValue = self.percent * 100;
    [self.countLabel showDuration:duration animated:YES];
}

- (void)hide {
    
    CGFloat duration          = 0.75;
    CGFloat circleFullPercent = 0.75;
    
    [self.fullCircle strokeStart:circleFullPercent animated:YES duration:duration];
    [self.showCircle strokeStart:self.percent * circleFullPercent animated:YES duration:duration];
    [self.rotateView roateAngle:90.f duration:duration];
    [self.countLabel hideDuration:duration];
}

@end
