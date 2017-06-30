//
//  NavHeadView.h
//  AppGame
//
//  Created by chan on 17/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NavHeadViewDelegate <NSObject>
@optional
-(void)navHeadBack;
-(void)navHeadShare;
-(void)navHeadQuery;
@end
@interface NavHeadView : UIView
@property(nonatomic, weak)id<NavHeadViewDelegate>delegate;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, strong)UIView *bgView;
@end
