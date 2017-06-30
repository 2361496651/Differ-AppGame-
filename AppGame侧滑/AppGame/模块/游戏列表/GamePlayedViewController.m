//
//  GamePlayedViewController.m
//  AppGame
//
//  Created by supozheng on 2017/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GamePlayedViewController.h"
#import "GameCollectionViewCell.h"
#import "CollectionHeadView.h"
#import "DifferNetwork.h"
#import "GameServices.h"
#import "GameListGroup.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "GameModel.h"

@interface GamePlayedViewController ()

@end

//玩过
@implementation GamePlayedViewController


- (void)viewDidLoad {
    self.gameListType = Game_Action_Played;
    [super viewDidLoad];
    
    [self setupNavigationBar];
}


// 设置顶部导航栏
- (void)setupNavigationBar {
    
    //    self.navigationController.view.backgroundColor = [DiffUtil getDifferColor];
//    self.title = @"我喜欢的游戏";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
}

- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
