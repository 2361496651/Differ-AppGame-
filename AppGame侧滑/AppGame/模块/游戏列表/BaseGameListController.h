//
//  BaseGameListControllerViewController.h
//  AppGame
//
//  Created by supozheng on 2017/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSUInteger, GameListType) {
    Game_Action_Install,
    Game_Action_Played,
    Game_Action_Liked
};
@interface BaseGameListController : BaseViewController
@property(nonatomic,assign) NSInteger gameListType;
@end
