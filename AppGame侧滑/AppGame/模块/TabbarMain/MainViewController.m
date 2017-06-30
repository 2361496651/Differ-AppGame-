//
//  MainViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/28.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "MainViewController.h"
#import "CJNavigationController.h"

#import "DiscoverViewController.h"
#import "DifferDailyController.h"
#import "PromoteViewController.h"
#import "DynamicsVC.h"
#import "GamePlayedViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //添加所有子控制器
    [self setupAllChildController];
}

// 设置所有子控制器
- (void)setupAllChildController
{
    // 添加首页
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    discover.view.backgroundColor = [UIColor whiteColor];
    
    [self setupOneChildController:discover image:[UIImage imageNamed:@"Recommend_icon_def"] selectImage:[UIImage imageNamed:@"Recommend_icon_pre"] withTitle:@"推荐"];
    
    // 添加联系人
    DifferDailyController *vc2 = [[DifferDailyController alloc] init];
    vc2.view.backgroundColor = [UIColor whiteColor];
    
    [self setupOneChildController:vc2 image:[UIImage imageNamed:@"daily_icon_def"] selectImage:[UIImage imageNamed:@"daily_icon_pre"] withTitle:@"日报"];
    
    // 添加我
    PromoteViewController *profile = [[PromoteViewController alloc] init];
    //    profile.view.backgroundColor = [UIColor whiteColor];
    
    [self setupOneChildController:profile image:[UIImage imageNamed:@"differ_game_icon_def"] selectImage:[UIImage imageNamed:@"differ_game_icon_pre"] withTitle:nil];
    
    // 添加我
    DynamicsVC *dynamic = [[DynamicsVC alloc] init];
    //    profile.view.backgroundColor = [UIColor whiteColor];
    
    [self setupOneChildController:dynamic image:[UIImage imageNamed:@"dynamic_icon_def"] selectImage:[UIImage imageNamed:@"dynamic_icon_pre"] withTitle:@"动态"];
    
    // 添加我
    GamePlayedViewController *myGame = [[GamePlayedViewController alloc] init];
    //    profile.view.backgroundColor = [UIColor whiteColor];
    
    [self setupOneChildController:myGame image:[UIImage imageNamed:@"my_game_icon_def"] selectImage:[UIImage imageNamed:@"my_game_icon_pre"] withTitle:@"我的"];
    
    
    self.selectedIndex = 2;//默认选中中间那个
    
}

// 设置一个子控制器
- (void)setupOneChildController:(UIViewController *)vc image:(UIImage *)image selectImage:(UIImage *)selectImage withTitle:(NSString *)title
{
    // 设置tabBarItem属性
    vc.title = title;
    vc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    vc.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 添加导航控制器
    CJNavigationController *nav = [[CJNavigationController alloc] initWithRootViewController:vc];
    
    // 添加子控制器
    [self addChildViewController:nav];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
