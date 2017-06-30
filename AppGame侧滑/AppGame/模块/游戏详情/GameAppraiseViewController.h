//
//  GameAppraiseController.h
//  AppGame
//
//  Created by chan on 17/5/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameModel.h"
#import "AppraiseModel.h"
#import "BaseViewController.h"
@interface GameAppraiseViewController : BaseViewController

@property(nonatomic, strong)GameModel *gameModel;
@property(nonatomic, strong)AppraiseModel *appraiseModel;
@end
