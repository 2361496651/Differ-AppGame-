//
//  TopicHeaderView.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "TopicHeaderView.h"
#import <UIImageView+WebCache.h>
#import "TopicModel.h"
#import "DiffUtil.h"

@interface TopicHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameContent;



@end

@implementation TopicHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"TopicHeaderView" owner:nil options:nil].firstObject;
    }
    self.frame = frame;
    return self;
}

- (void)setTextColor:(NSString *)textColor
{
    _textColor = textColor;
    self.gameContent.textColor = [DiffUtil colorWithHexString:textColor];
}

- (void)setTopic:(TopicModel *)topic
{
    _topic = topic;
    
    [self.gameIcon sd_setImageWithURL:topic.cover];
    self.gameContent.text = topic.content;
    
    [self layoutIfNeeded];
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.gameContent.frame) - 10;
    self.frame = frame;
    
}



@end
