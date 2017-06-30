//
//  NoGameAlertView.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/9.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "NoGameAlertView.h"

@implementation NoGameAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame
                ]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NoGameAlertView" owner:nil options:nil].firstObject;
        
    }
    self.frame = frame;
    return self;
}

- (IBAction)bgButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(alertViewBgClick:)]) {
        [self.delegate alertViewBgClick:self];
    }
}

- (IBAction)goMyGameClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(alertViewGoClick:)]) {
        [self.delegate alertViewGoClick:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
