//
//  DailyTopicCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "ZFPlayer.h"

#import "VideoPlayerView.h"


@class DailyTopicCell;

@protocol DailyTopicCellDelegate <NSObject>

- (void)dailyTopicCellClickDownLoad:(GameModel *)game;

@end

@interface DailyTopicCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)GameModel *game;

@property (nonatomic,copy)NSString *fontColor;

@property (nonatomic,weak)id<DailyTopicCellDelegate> delegate;


@property (nonatomic,strong)VideoPlayerView *videoPlayView;

//@property (nonatomic, strong) UIButton                      *playBtn;
///** model */
//@property (nonatomic, strong) ZFVideoModel                  *model;
///** 播放按钮block */
//@property (nonatomic, copy  ) void(^playBlock)(UIButton *);

@end
