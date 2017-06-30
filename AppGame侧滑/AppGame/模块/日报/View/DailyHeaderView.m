//
//  DailyHeaderView.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyHeaderView.h"

@interface DailyHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleCountLabel;


@end

@implementation DailyHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"DailyHeaderView" owner:nil options:nil]firstObject];
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return self;
}


- (void)setTimeTitle:(NSString *)timeTitle
{
    _timeTitle = timeTitle;
    self.timeTitleLabel.text = timeTitle;
    
}

- (void)setAirticlCount:(NSString *)airticlCount
{
    _airticlCount = airticlCount;
    self.articleCountLabel.text = airticlCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
