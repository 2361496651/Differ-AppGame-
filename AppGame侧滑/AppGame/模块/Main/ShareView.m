//
//  ShareView.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()

@property (weak, nonatomic) IBOutlet UIView *weChatView;
@property (weak, nonatomic) IBOutlet UIView *weChatFriendView;
@property (weak, nonatomic) IBOutlet UIView *QQZoneView;

@property (weak, nonatomic) IBOutlet UIView *QQFriendView;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil]firstObject];
    }
    
    self.frame = frame;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 隐藏相应平台
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    if (!hadInstalledWeixin) {
        self.weChatView.hidden = YES;
        self.weChatFriendView.hidden = YES;
    }
    
    if (!hadInstalledQQ) {
        self.QQZoneView.hidden = YES;
        self.QQFriendView.hidden = YES;
    }
}

- (IBAction)weixinClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewClickWeixin:)]) {
        [self.delegate shareViewClickWeixin:self];
    }
}

- (IBAction)weixinCircleClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewClickWeixinCircle:)]) {
        [self.delegate shareViewClickWeixinCircle:self];
    }
}

- (IBAction)weiboClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewClickWeibo:)]) {
        [self.delegate shareViewClickWeibo:self];
    }
}

- (IBAction)qqClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewClickQQ:)]) {
        [self.delegate shareViewClickQQ:self];
    }
}


- (IBAction)qqCircleClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewClickQQCircle:)]) {
        [self.delegate shareViewClickQQCircle:self];
    }
}

- (IBAction)copyURLClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewClickCopyURL:)]) {
        [self.delegate shareViewClickCopyURL:self];
    }
}


@end
