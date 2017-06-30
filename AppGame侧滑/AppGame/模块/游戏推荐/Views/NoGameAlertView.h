//
//  NoGameAlertView.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/9.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoGameAlertView;

@protocol NoGameAlertViewDelegate <NSObject>

- (void)alertViewBgClick:(NoGameAlertView *)alertView;
- (void)alertViewGoClick:(NoGameAlertView *)alertView;

@end

@interface NoGameAlertView : UIView

@property (nonatomic,assign)id<NoGameAlertViewDelegate> delegate;

@end
