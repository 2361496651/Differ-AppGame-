//
//  HMDrawerViewController.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/14.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDrawerViewController : UIViewController

/**
 *  快速创建一个抽屉控制器
 *
 *  @param mainVc     主控制器
 *  @param leftMenuVc 左边菜单控制器
 *  @param leftWidth  左边菜单控制器最大显示的宽度
 *
 *  @return 抽屉控制器
 */
+(instancetype)drawerWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc leftWidth:(CGFloat)leftWidth;
/**
 *  返回抽屉控制器
 */
+ (instancetype)sharedDrawer;
/**
 *  打开左边菜单
 */
- (void)openLeftMenuWithDuration:(CGFloat)duration completion:(void (^)())completion;
/**
 *  关闭左边菜单
 */
- (void)closeLeftMenuWithDuration:(CGFloat)duration completion:(void (^)())completion;;

/**
 *  切换到指定的控制器
 */
- (void)switchViewController:(UIViewController *)vc;
/**
 *  回到主页
 */
- (void)backToMainVc;

//- (void)backToMainVccompletion:(void (^)())completion;
/**
 * 展示分享界面
 */
- (void)displayShareView;

@end
