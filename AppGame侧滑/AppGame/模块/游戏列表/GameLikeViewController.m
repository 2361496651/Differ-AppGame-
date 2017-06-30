//
//  GameLikeViewController.m
//  AppGame
//
//  Created by supozheng on 2017/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameLikeViewController.h"
#import "GameCollectionViewCell.h"
#import "CollectionHeadView.h"
#import "DifferNetwork.h"
#import "GameListGroup.h"
#import "GameServices.h"
#import <MJExtension.h>
#import "GameModel.h"

@interface GameLikeViewController ()

@end

//喜欢
@implementation GameLikeViewController

- (void)viewDidLoad {
    self.gameListType = Game_Action_Liked;
    [super viewDidLoad];
}



@end
