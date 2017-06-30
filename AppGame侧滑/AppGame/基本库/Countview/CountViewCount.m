//
//  CountViewCount.m
//  AppGame
//
//  Created by supozheng on 17/5/15.
//
//

#import "CountViewCount.h"
#import "NSString+RichText.h"

@implementation CountViewCount

- (void)startAnimation {
    
    // 初始化值
    CGFloat fromeValue = self.fromValue;
    CGFloat toValue    = self.toValue;
    CGFloat duration   = (self.duration <= 0 ? 1.f : self.duration);
    
    self.conutAnimation = [POPBasicAnimation animation];
    // 设定动画
    self.conutAnimation.fromValue      = @(fromeValue);
    self.conutAnimation.toValue        = @(toValue);
    self.conutAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.69 :0.11 :0.32 :0.88];
    self.conutAnimation.duration       = duration;
    
    // 只有执行了代理才会执行计数引擎
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberCount:)]) {
        /* 将计算出来的值通过writeBlock动态给控件设定 */
        self.conutAnimation.property = \
        [POPMutableAnimatableProperty propertyWithName:@"conutAnimation"
                                           initializer:^(POPMutableAnimatableProperty *prop) {
                                               prop.writeBlock      = ^(id obj, const CGFloat values[]) {
                                            
                                                   NSNumber *number = @(values[0]);
                                                   NSAttributedString *ats = [self accessNumber:number.floatValue];
                                                   [self.delegate numberCount:ats];
                                               };
                                           }];
        
        // 添加动画
        [self pop_addAnimation:self.conutAnimation forKey:@"conutAnimation"];
    }

}

// 处理富文本
- (NSAttributedString *)accessNumber:(float )number {
    
    float count    = number;
    NSString *countStr = [NSString stringWithFormat:@"%.1f",count/10.0];
    NSString *totalStr = [NSString stringWithFormat:@"%@", countStr];
    
//    UIFont *font1       = [UIFont fontWithName:LATO_LIGHT size:40.f];
//    UIFont *font2       = [UIFont fontWithName:LATO_LIGHT size:19.f];
        
    UIFont *font1       = [UIFont systemFontOfSize:self.fontSize-5];
//    UIFont *font2       = [UIFont systemFontOfSize:self.fontSize/2-1];
    
//    NSRange totalRange   = [totalStr range];              // 全局的区域
    NSRange countRange   = [countStr rangeFrom:totalStr]; // %的区域
    
    return [totalStr createAttributedStringAndConfig:@[
                                                       // 全局设置
                                                       [ConfigAttributedString font:font1
                                                                              range:countRange],
                                                       [ConfigAttributedString foregroundColor:[UIColor di_MAIN2]
                                                                                         range:countRange],

                                                       ]];
}

@end
