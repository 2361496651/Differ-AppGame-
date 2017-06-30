//
//  AnimationCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AnimationCell.h"
#import "DiffUtil.h"

@interface AnimationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView2;

@property (weak, nonatomic) IBOutlet UIView *bgView3;



@end

@implementation AnimationCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AnimationCell" owner:nil options:nil]firstObject];
    }
    self.frame = frame;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.bgView3.backgroundColor = [[DiffUtil colorWithHexString:@"#21B8B8"] colorWithAlphaComponent:0.25];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAnimation1)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}

- (void)setCount:(NSString *)count
{
    _count = count;
    
    self.countLabel.text = count;
}


- (void)startAnimation
{
    CGRect rect = self.bgView3.frame;
    [[DiffUtil getDifferColor] setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 5;
    double animationDuration = 4;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [UIColor whiteColor].CGColor;
        pulsingLayer.borderWidth = 1;
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
        scaleAnimation.toValue = @1.8;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.bgView3.layer addSublayer:animationLayer];
}

- (void)startAnimation1
{
    NSLog(@"开始探索动画");
    if ([self.delegate respondsToSelector:@selector(animationCellStartAnimation)]) {
        [self.delegate animationCellStartAnimation];
    }
    
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1.5;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = MAXFLOAT;
//    
//    [self.bgView3.layer addAnimation:rotationAnimation forKey:nil];
//    
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    // 动画选项设定
//    animation.duration = 1.5; // 动画持续时间
//    animation.repeatCount = 1; // 重复次数
//    animation.autoreverses = NO; // 动画结束时执行逆动画
//    // 缩放倍数
//    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
//    animation.toValue = [NSNumber numberWithFloat:1.5]; // 结束时的倍率
//    
//    // 添加动画
////    [self.bgView2.layer addAnimation:animation forKey:nil];
//    [self.bgView3.layer addAnimation:animation forKey:nil];
    
}

@end
