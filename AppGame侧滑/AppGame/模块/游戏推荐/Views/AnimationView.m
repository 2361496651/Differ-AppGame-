//
//  AnimationView.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AnimationView.h"
#import "DiffUtil.h"

@interface AnimationView ()
// 最底层的view
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exploreImage;

@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"AnimationView" owner:nil options:nil]firstObject];
//        [self setupUI];
    }
    self.frame = frame;

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAnimation)];
//    
//    [self.bgView addGestureRecognizer:tap];
    [self startAnimation];
}

- (void)setCount:(NSString *)count
{
    _count = count;
    self.countLabel.text = count;
}

- (void)startAnimation
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.5];
    animation.duration=1.5;
//    animation.autoreverses=YES;
//    animation.cumulative = YES;
    animation.removedOnCompletion=NO;
    animation.repeatCount = 1;// MAXFLOAT;
    animation.fillMode=kCAFillModeForwards;
    [self.countLabel.layer addAnimation:animation forKey:@"zoom"];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.0;
//    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.bgView.layer addAnimation:rotationAnimation forKey:nil];
    
    
    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    momAnimation.fromValue = [NSNumber numberWithFloat:-0.3];
    momAnimation.toValue = [NSNumber numberWithFloat:0.3];
    momAnimation.duration = 0.5;
    momAnimation.repeatCount = CGFLOAT_MAX;
    momAnimation.autoreverses = YES;
    self.exploreImage.userInteractionEnabled = YES;
    [self.exploreImage.layer addAnimation:momAnimation forKey:@"animateLayer"];
    
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[DiffUtil getDifferColor] setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 5;
    double animationDuration = 3;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [DiffUtil colorWithHexString:@"#21B8B8"].CGColor;
        pulsingLayer.borderWidth = 4;
        pulsingLayer.opacity = 0.6;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.0;
        scaleAnimation.toValue = @2.0;
        [scaleAnimation setRemovedOnCompletion:NO];
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.values = @[ @0.6, @0.55, @0.5,@0.45, @0.4, @0.35, @0.3, @0.25, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        [opacityAnimation setRemovedOnCompletion:NO];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
    
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 6.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE;
    [rotationAnimation setRemovedOnCompletion:NO];
    [self.bgView.layer addAnimation:rotationAnimation forKey:nil];
    
}

@end
