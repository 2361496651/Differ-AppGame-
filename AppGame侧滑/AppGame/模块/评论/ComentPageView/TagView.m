//
//  TagView.m
//  AppGame
//
//  Created by chan on 17/5/8.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "TagView.h"
#import "UIView+EasyLayout.h"



@implementation TagView

-(UIView *) initWithFrame:(CGRect)frame TagType:(TagType) tagType BorderColor:(UIColor *)color{
    self = [super init];
    self.frame = frame;
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = frame;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = color.CGColor;
    
    if (tagType == TagTypeDottedLine) {
        //虚线边框
        borderLayer.lineDashPattern = @[@5, @5];
    }else{
        //实线边框
        borderLayer.lineDashPattern = nil;
    }
    
    [self.layer addSublayer:borderLayer];
    return self;
}

-(UILabel *)tagText{
    if (!_tagText) {
        _tagText = [UILabel new];
        [self addSubview:_tagText];
        _tagText.el_axisYToSuperView(0).el_axisXToSuperView(0);
        _tagText.font = [UIFont systemFontOfSize:self.frame.size.height/2];
    }
    return _tagText;
}

@end
