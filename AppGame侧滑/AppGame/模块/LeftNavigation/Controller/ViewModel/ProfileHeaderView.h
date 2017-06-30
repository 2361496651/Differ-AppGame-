//
//  ProfileHeaderView.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/20.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileHeaderView;
@class AccountModel;
@class ProfileHeaderView;
@class UserModel;

typedef void(^backBlock)(NSInteger tag);

@protocol ProfileHeaderViewDelegate <NSObject>

@optional
// 点击头像
- (void)profileHeaderView:(ProfileHeaderView *)headerView iconImageClick:(UserModel *)account;
// 点击个性签名
- (void)profileHeaderView:(ProfileHeaderView *)headerView remarkClick:(UserModel *)account;
// 点击关注
- (void)profileHeaderView:(ProfileHeaderView *)headerView followerClick:(UserModel *)account;


@end

@interface ProfileHeaderView : UIView

@property (nonatomic,strong)backBlock callBack;

@property (nonatomic,strong)UserModel *account;

@property (nonatomic,weak)id<ProfileHeaderViewDelegate> delegate;

@end
