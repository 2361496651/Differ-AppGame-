//
//  AboutTAHeader.m
//  AppGame
//
//  Created by zengchunjun on 2017/6/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AboutTAHeader.h"
#import "UserModel.h"
#import "AchievesModel.h"
#import "RankModel.h"

@interface AboutTAHeader ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeTopToSuperView;


@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *markContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *certifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *certifyContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *certifyIcon;

@property (weak, nonatomic) IBOutlet UILabel *certifyLineLabel;




@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon1;

@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon3;

@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon4;
@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon5;

@property (weak, nonatomic) IBOutlet UILabel *badgeLineLabel;



@property (weak, nonatomic) IBOutlet UILabel *guestCountLabel;

@end

@implementation AboutTAHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"AboutTAHeader" owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)setUser:(UserModel *)user
{
    _user = user;
    
    self.markLabel.text = @"签名";
    
    NSString *remarkStr = user.remark;
    if (remarkStr == nil || [remarkStr isEqualToString:@""]) {
        remarkStr = @"未设置";
    }
    self.markContentLabel.text = remarkStr;
    
    if (user.rank.name && ![user.rank.name isEqualToString:@""]) {
        self.certifyLineLabel.hidden = NO;
        
        self.certifyLabel.text = @"认证";
        self.certifyContentLabel.text = user.rank.name;
        [self.certifyIcon sd_setImageWithURL:user.rank.icon];
        
        [self layoutIfNeeded];
        self.badgeTopToSuperView.constant = CGRectGetMaxY(self.certifyContentLabel.frame) + 25;
    }else{
        
        [self layoutIfNeeded];
        self.certifyLineLabel.hidden = YES;
        self.badgeTopToSuperView.constant = CGRectGetMaxY(self.markContentLabel.frame) + 25;
    }
    
        
    self.badgeLabel.text = @"徽章";
    
    for (int i = 0;i < user.achieves.count;i++) {
        
        AchievesModel *achieve = user.achieves[i];
        
        switch (i) {
            case 0:
                [self.badgeIcon1 sd_setImageWithURL:achieve.icon];
                break;
            case 1:
                [self.badgeIcon2 sd_setImageWithURL:achieve.icon];
                break;
            case 2:
                [self.badgeIcon3 sd_setImageWithURL:achieve.icon];
                break;
            case 3:
                [self.badgeIcon4 sd_setImageWithURL:achieve.icon];
                break;
            case 4:
                [self.badgeIcon5 sd_setImageWithURL:achieve.icon];
                break;
                
            default:
                break;
        }
    }

    
    
    
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.guestCountLabel.frame);
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}

- (void)setGuestCount:(NSInteger)guestCount
{
    _guestCount = guestCount;
    self.guestCountLabel.text = [NSString stringWithFormat:@"%ld条留言",guestCount];
    
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.guestCountLabel.frame);
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

//查看全部徽章
- (IBAction)moreBadgeClick:(UIButton *)sender {
    NSLog(@"%s %d",__func__,__LINE__);
}


@end
