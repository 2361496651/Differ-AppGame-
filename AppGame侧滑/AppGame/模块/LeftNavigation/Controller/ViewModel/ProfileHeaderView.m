//
//  ProfileHeaderView.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/20.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ProfileHeaderView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UserModel.h"
#import "DifferAccountTool.h"
#import "DifferAccount.h"
#import "DiffUtil.h"

@interface ProfileHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;

//签名
@property (weak, nonatomic) IBOutlet UIButton *remarkBtn;

@property (nonatomic,assign)BOOL isMyself;

@end

@implementation ProfileHeaderView

// 是否是自己
- (BOOL)isMyself
{
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    if ([self.account.uid isEqualToString:model.uid]) {
        return YES;
    }
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil].firstObject;
        
    }
    self.frame = frame;
    return self;
}


// 关注
- (IBAction)attentionBtnClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(profileHeaderView:followerClick:)]) {
        [self.delegate profileHeaderView:self followerClick:self.account];
    }
    
}

// 头像
- (IBAction)iconBtnClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(profileHeaderView:iconImageClick:)]) {
        [self.delegate profileHeaderView:self iconImageClick:self.account];
    }
}

//签名
- (IBAction)markClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(profileHeaderView:remarkClick:)]) {
        [self.delegate profileHeaderView:self remarkClick:self.account];
    }
}

- (void)setAccount:(UserModel *)account
{
    _account = account;
    
    if (self.isMyself) {
        [self.iconBtn setImage:[DifferAccountTool getAvata] forState:UIControlStateNormal];
    }else{
        [self.iconBtn sd_setImageWithURL:account.avatar forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"menu_user_default"]];
        
    }

    NSString *nickName = account.nickname;
    if (account.nickname == nil || [account.nickname isEqualToString:@""]){
        nickName = @"未设置";
    }
    self.screenNameLabel.text = nickName;
    self.propertyLabel.text = [NSString stringWithFormat:@"关注 %ld | 粉丝 %ld",account.following,account.follower];
    
    // 是否已关注
    if ([account.is_followed integerValue]) {
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        
    }else{
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [DiffUtil getDifferColor];
    
    self.attentionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.attentionBtn.layer.borderWidth = 0.8;
    
    if (!self.isMyself) {
//        self.remarkBtn.hidden = YES;
        self.attentionBtn.hidden = NO;
    }else{
//        self.remarkBtn.hidden = NO;
        self.attentionBtn.hidden = YES;
    }
    
    
}

@end
