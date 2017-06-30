//
//  ShareView.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareView;

@protocol ShareViewDelegate <NSObject>

@optional

- (void)shareViewClickWeixin:(ShareView *)shareView;
- (void)shareViewClickWeixinCircle:(ShareView *)shareView;
- (void)shareViewClickWeibo:(ShareView *)shareView;
- (void)shareViewClickQQ:(ShareView *)shareView;
- (void)shareViewClickQQCircle:(ShareView *)shareView;
- (void)shareViewClickCopyURL:(ShareView *)shareView;

@end

@interface ShareView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,assign)id<ShareViewDelegate> delegate;

@end
