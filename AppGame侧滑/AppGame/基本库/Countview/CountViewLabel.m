//
//  CountViewLabel.m
//  AppGame
//
//  Created by supozheng on 17/5/15.
//
//

#import "CountViewLabel.h"

@interface CountViewLabel ()<NumberCountDelegate>

@end

@implementation CountViewLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.countLabel               = [[UILabel alloc] initWithFrame:self.bounds];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countLabel];
        self.countLabel.alpha         = 0;
        
        self.count          = [CountViewCount new];
        self.count.delegate = self;
    }
    
    return self;
}

- (void)numberCount:(NSAttributedString *)string {
    
    self.countLabel.attributedText = string;
}

- (void)showDuration:(CGFloat)duration animated:(BOOL)animated{
    
    if(animated){
        self.count.fontSize = self.fontSize;
        self.count.fromValue = self.fromValue;
        self.count.toValue   = self.toValue;
        self.count.duration  = duration;
        self.countLabel.transform    = CGAffineTransformMake(1.5, 0, 0, 1.5, 0, 0);
        
        [self.count startAnimation];
        
        [UIView animateWithDuration:duration animations:^{
            
            self.countLabel.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            self.countLabel.alpha     = 1.f;
        }];
    }else{
        self.count.fontSize = self.fontSize;
        self.count.fromValue = self.fromValue;
        self.count.toValue   = self.toValue;
        self.count.duration  = duration;
        self.countLabel.transform    = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        self.countLabel.alpha     = 1.f;
        
        NSNumber *number = @(self.toValue);
        NSAttributedString *ats = [self.count accessNumber:number.floatValue];
        self.countLabel.attributedText = ats;
    }

}

- (void)hideDuration:(CGFloat)duration {
    
    self.count.fromValue = self.toValue;
    self.count.toValue   = 0;
    self.count.duration  = duration;
    
    [self.count startAnimation];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.countLabel.transform = CGAffineTransformMake(0.5, 0, 0, 0.5, 0, 0);
        self.countLabel.alpha     = 0.f;
    }];
}

@end
