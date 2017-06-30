//
//  CountView.h
//  AppGame
//
//  Created by supozheng on 7/5/15.
//
//

#import <UIKit/UIKit.h>


// 显示控件
/*
 self.countView = [[CountView alloc] init];
 [self.view addSubview:self.countView];
 self.countView.percent = 20 / 100.f;
 [self.countView buildView:80.f height:80.f];
 self.countView.el_topToSuperView(1).el_leftToSuperView(5).el_toSize(CGSizeMake(80, 80));
 [self.countView show];
*/

@interface CountView : UIView


@property (nonatomic) CGFloat percent;

- (void)buildView:(float)width height:(float)height;

//静态显示
- (void)show;

//显示动画
- (void)showWithAnimated;

//隐藏
- (void)hide;

@end
