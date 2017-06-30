//
//  GameListMainViewController.m
//  AppGame
//
//  Created by supozheng on 2017/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameListMainViewController.h"
#import "DiffUtil.h"
#import "DLSlideView.h"
#import "GameLikeViewController.h"
#import "GamePlayedViewController.h"
#import "GameServices.h"

@interface GameListMainViewController ()
@property (nonatomic, strong) DLTabedSlideView *tabedSlideView;
@end

@implementation GameListMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setSlideView];
    
}

// 设置顶部导航栏
- (void)setupNavigationBar {
    
//    self.navigationController.view.backgroundColor = [DiffUtil getDifferColor];
    self.title = @"我的游戏";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
}

-(void)setSlideView{
    self.tabedSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)] ;
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.backgroundColor = [UIColor whiteColor];
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    self.tabedSlideView.tabItemSelectedColor = [UIColor blackColor];
    self.tabedSlideView.tabItemNormalColor = [UIColor HEX:0x333333];
    self.tabedSlideView.tabbarTrackColor = [UIColor di_MAIN2];
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@"tabbarBk"];
    self.tabedSlideView.tabbarBottomSpacing = 3.0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"喜欢" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"玩过" image:nil selectedImage:nil];
    self.tabedSlideView.tabbarItems = @[item1, item2];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
    
//    self.tabedSlideView.el_edgesToSuperView(0,0,0,0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 2;
}

- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            GameLikeViewController *ctrl = [[GameLikeViewController alloc] init];
            return ctrl;
        }
        case 1:
        {
            GamePlayedViewController *ctrl = [[GamePlayedViewController alloc] init];
            return ctrl;
        }
            
        default:
            return nil;
    }
    return nil;
}


@end
